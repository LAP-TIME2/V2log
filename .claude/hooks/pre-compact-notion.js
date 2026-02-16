#!/usr/bin/env node
/**
 * PreCompact Notion Logger
 *
 * Claude Code의 compact(자동/수동) 직전에 실행되어
 * 오늘의 작업 내용을 Notion 노트 DB에 자동 기록합니다.
 *
 * 데이터 소스:
 *   1. .claude/session-log.md — Claude가 작업 중 남긴 상세 기록
 *   2. git log — 오늘의 커밋 목록
 *
 * 설정 필요:
 *   .claude/hooks/.env 파일에 NOTION_TOKEN=ntn_xxxxx 추가
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// ── 설정 ──────────────────────────────────────────────────────
const NOTION_API = 'https://api.notion.com/v1';
const NOTION_VERSION = '2022-06-28';
const DB_ID = '2ee11395-4070-811e-bd43-d9e8b44fb595';
const AREA_PAGE_ID = '2ee1139540708195bc6bc36bc1a53202';
const PROJECT_NAME = 'V2log';


// ── 유틸리티 ──────────────────────────────────────────────────

function readStdin() {
  return new Promise((resolve) => {
    let data = '';
    process.stdin.setEncoding('utf-8');
    process.stdin.on('data', (chunk) => { data += chunk; });
    process.stdin.on('end', () => resolve(data));
    setTimeout(() => resolve(data), 2000);
  });
}

function loadEnv(envPath) {
  if (!fs.existsSync(envPath)) return {};
  const content = fs.readFileSync(envPath, 'utf-8');
  const env = {};
  for (const line of content.split('\n')) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;
    const eqIdx = trimmed.indexOf('=');
    if (eqIdx === -1) continue;
    env[trimmed.slice(0, eqIdx).trim()] = trimmed.slice(eqIdx + 1).trim().replace(/^["']|["']$/g, '');
  }
  return env;
}

/** .claude/session-log.md 읽기 (UTF-8 BOM 처리 포함) */
function readSessionLog(cwd) {
  const logPath = path.join(cwd, '.claude', 'session-log.md');
  if (!fs.existsSync(logPath)) return '';
  const buf = fs.readFileSync(logPath);
  if (buf.length === 0) return '';
  // UTF-8 BOM 제거
  const start = (buf[0] === 0xEF && buf[1] === 0xBB && buf[2] === 0xBF) ? 3 : 0;
  return buf.slice(start).toString('utf-8').trim();
}

/** .claude/session-log.md 초기화 */
function clearSessionLog(cwd) {
  const logPath = path.join(cwd, '.claude', 'session-log.md');
  if (fs.existsSync(logPath)) {
    fs.writeFileSync(logPath, '', 'utf-8');
  }
}

/** 마지막 전송 상태 파일 경로 */
function getStatePath(cwd) {
  return path.join(cwd, '.claude', 'hooks', '.last-compact-state.json');
}

/** 마지막 전송 상태 읽기 */
function readLastState(cwd) {
  const statePath = getStatePath(cwd);
  try {
    if (fs.existsSync(statePath)) {
      return JSON.parse(fs.readFileSync(statePath, 'utf-8'));
    }
  } catch {}
  return { lastCommitHash: null };
}

/** 마지막 전송 상태 저장 */
function saveLastState(cwd, state) {
  const statePath = getStatePath(cwd);
  fs.writeFileSync(statePath, JSON.stringify(state, null, 2), 'utf-8');
}

function getGitCommits(cwd) {
  try {
    const state = readLastState(cwd);
    let gitCmd;
    if (state.lastCommitHash) {
      // 마지막 전송한 커밋 이후의 새 커밋만 가져오기
      gitCmd = `git log ${state.lastCommitHash}..HEAD --format="%h|%s|%ai" --no-merges`;
    } else {
      // 상태 파일 없으면 오늘 커밋만 (첫 실행)
      const today = formatDate(new Date());
      gitCmd = `git log --since="${today}T00:00:00" --format="%h|%s|%ai" --no-merges`;
    }
    const result = execSync(gitCmd, { cwd, encoding: 'utf-8', timeout: 5000 }).trim();
    if (!result) return [];
    return result.split('\n').map((line) => {
      const [hash, message, dateStr] = line.split('|');
      const time = dateStr ? dateStr.trim().slice(11, 16) : '';
      return { hash: hash.trim(), message: message.trim(), time };
    });
  } catch {
    return [];
  }
}

function formatDate(d) {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

function formatTime(d) {
  return `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;
}


// ── Notion API ────────────────────────────────────────────────

async function notionFetch(token, endpoint, method, body) {
  const bodyStr = body ? JSON.stringify(body) : undefined;
  // Windows에서 한글 깨짐 방지: 명시적으로 UTF-8 Buffer로 변환
  const bodyBuffer = bodyStr ? Buffer.from(bodyStr, 'utf-8') : undefined;

  const res = await fetch(`${NOTION_API}${endpoint}`, {
    method,
    headers: {
      'Authorization': `Bearer ${token}`,
      'Notion-Version': NOTION_VERSION,
      'Content-Type': 'application/json; charset=utf-8',
      ...(bodyBuffer ? { 'Content-Length': String(bodyBuffer.length) } : {}),
    },
    body: bodyBuffer,
  });
  const data = await res.json();
  if (!res.ok) {
    throw new Error(`Notion API ${res.status}: ${data.message || JSON.stringify(data)}`);
  }
  return data;
}

async function findTodayPage(token, dateStr) {
  const result = await notionFetch(token, `/databases/${DB_ID}/query`, 'POST', {
    filter: { property: '이름', title: { contains: dateStr } },
    page_size: 1,
  });
  return result.results?.[0] || null;
}

async function createPage(token, title, blocks) {
  return notionFetch(token, '/pages', 'POST', {
    parent: { database_id: DB_ID },
    properties: {
      '이름': { title: [{ text: { content: title } }] },
      '분류': { select: { name: '중간 작업물' } },
      '영역 · 자원': { relation: [{ id: AREA_PAGE_ID }] },
    },
    children: blocks,
  });
}

async function appendBlocks(token, pageId, blocks) {
  return notionFetch(token, `/blocks/${pageId}/children`, 'PATCH', { children: blocks });
}


// ── Notion 블록 헬퍼 ─────────────────────────────────────────

function heading2(text) {
  return { type: 'heading_2', heading_2: { rich_text: [{ text: { content: text } }] } };
}
function heading3(text) {
  return { type: 'heading_3', heading_3: { rich_text: [{ text: { content: text } }] } };
}
function bullet(text) {
  return { type: 'bulleted_list_item', bulleted_list_item: { rich_text: [{ text: { content: text } }] } };
}
function paragraph(text) {
  return { type: 'paragraph', paragraph: { rich_text: [{ text: { content: text } }] } };
}
function divider() {
  return { type: 'divider', divider: {} };
}
function richBullet(segments) {
  return {
    type: 'bulleted_list_item',
    bulleted_list_item: {
      rich_text: segments.map((s) => ({
        text: { content: s.text },
        annotations: { bold: s.bold || false, italic: s.italic || false, code: s.code || false },
      })),
    },
  };
}

/**
 * session-log.md의 마크다운을 Notion 블록으로 변환
 * 지원: ## h2, ### h3, - 불릿, 일반 텍스트, --- 구분선
 */
function markdownToBlocks(md) {
  const blocks = [];
  for (const line of md.split('\n')) {
    if (line.startsWith('### '))      blocks.push(heading3(line.slice(4)));
    else if (line.startsWith('## '))  blocks.push(heading2(line.slice(3)));
    else if (line.startsWith('# '))   blocks.push(heading2(line.slice(2)));
    else if (line.startsWith('---'))  blocks.push(divider());
    else if (line.match(/^- \*\*/))   blocks.push(bullet(line.slice(2)));
    else if (line.startsWith('- '))   blocks.push(bullet(line.slice(2)));
    else if (line.startsWith('  - ')) blocks.push(bullet('  ' + line.slice(4)));
    else if (line.trim())             blocks.push(paragraph(line));
  }
  return blocks;
}


// ── DEVLOG 자동 업데이트 ─────────────────────────────────────

function updateDevlog(cwd, commits) {
  const devlogPath = path.join(cwd, 'docs', 'DEVLOG.md');
  if (!fs.existsSync(devlogPath) || commits.length === 0) return;

  const content = fs.readFileSync(devlogPath, 'utf-8');
  const today = formatDate(new Date());
  const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
  const dayLabel = dayNames[new Date().getDay()];

  const dateHeader = `### ${today} (${dayLabel})`;

  if (content.includes(dateHeader)) {
    // 기존 날짜 섹션에 커밋 추가 (중복 방지: 이미 있는 해시는 스킵)
    const filteredEntries = commits
      .filter((c) => !content.includes(c.hash))
      .map((c) => `- \`${c.message}\` — ${c.hash}`)
      .join('\n');
    if (!filteredEntries) return;

    const updated = content.replace(
      dateHeader,
      `${dateHeader}\n\n#### 커밋 (auto)\n${filteredEntries}`
    );
    fs.writeFileSync(devlogPath, updated, 'utf-8');
  } else {
    // 새 날짜 섹션 생성 → "Part 2: 개발 타임라인" 바로 아래 삽입
    const marker = '# Part 2: 개발 타임라인';
    let newEntries = '';
    for (const c of commits) {
      newEntries += `- \`${c.message}\` — ${c.hash}\n`;
    }
    const section = `\n${dateHeader}\n\n#### 커밋 (auto)\n${newEntries}\n---\n`;
    const idx = content.indexOf(marker);
    if (idx !== -1) {
      const afterMarker = content.indexOf('\n', idx) + 1;
      const updated = content.slice(0, afterMarker) + section + content.slice(afterMarker);
      fs.writeFileSync(devlogPath, updated, 'utf-8');
    }
  }
  console.log(`[pre-compact-notion] DEVLOG.md 업데이트: ${commits.length}개 커밋 추가`);
}


// ── 메인 ──────────────────────────────────────────────────────

async function main() {
  try {
    const stdinData = await readStdin();
    let hookData = {};
    try { hookData = JSON.parse(stdinData); } catch {}

    const cwd = hookData.cwd || process.cwd();
    const trigger = hookData.trigger || 'unknown';

    // 토큰 로드
    const envPath = path.join(__dirname, '.env');
    const env = loadEnv(envPath);
    const token = env.NOTION_TOKEN;
    if (!token) {
      console.error('[pre-compact-notion] NOTION_TOKEN이 설정되지 않았습니다.');
      process.exit(0);
    }

    // 정보 수집
    const now = new Date();
    const dateStr = formatDate(now);
    const timeStr = formatTime(now);
    const commits = getGitCommits(cwd);
    const sessionLog = readSessionLog(cwd);

    // ── DEVLOG.md 자동 업데이트 (Notion 전송 전) ──
    updateDevlog(cwd, commits);

    // ── 블록 구성 ──
    const blocks = [];

    // 세션 로그가 있으면 (Claude가 남긴 상세 기록)
    if (sessionLog) {
      blocks.push(...markdownToBlocks(sessionLog));
      blocks.push(divider());
    }

    // Git 커밋 섹션
    blocks.push(heading2(`🔀 Git 커밋 (${trigger === 'auto' ? '자동' : '수동'} compact ${timeStr})`));

    if (commits.length > 0) {
      for (const c of commits) {
        blocks.push(richBullet([
          { text: `[${c.time}] `, bold: true },
          { text: `${c.hash} `, code: true },
          { text: c.message },
        ]));
      }
    } else {
      blocks.push(bullet('오늘 커밋 없음'));
    }

    blocks.push(divider());
    blocks.push(paragraph(`⏱️ 기록 시각: ${dateStr} ${timeStr}`));

    // ── Notion에 기록 ──
    const title = `📋 ${dateStr} ${timeStr}~ 개발 로그 — ${PROJECT_NAME}`;
    const existing = await findTodayPage(token, dateStr);

    if (existing) {
      await appendBlocks(token, existing.id, blocks);
      console.log(`[pre-compact-notion] 기존 페이지에 추가 완료 (${dateStr})`);
    } else {
      await createPage(token, title, blocks);
      console.log(`[pre-compact-notion] 새 페이지 생성 완료: ${title}`);
    }

    // 마지막 커밋 해시 저장 (다음 compact 때 중복 방지)
    if (commits.length > 0) {
      // commits[0]이 가장 최신 커밋 (git log는 최신순 정렬)
      const latestHash = commits[0].hash;
      // 풀 해시로 저장 (short hash는 git log에서 ambiguous할 수 있음)
      try {
        const fullHash = execSync(`git rev-parse ${latestHash}`, { cwd, encoding: 'utf-8', timeout: 5000 }).trim();
        saveLastState(cwd, { lastCommitHash: fullHash, lastCompactTime: now.toISOString() });
        console.log(`[pre-compact-notion] 상태 저장: ${latestHash} (${fullHash.slice(0, 7)})`);
      } catch {
        saveLastState(cwd, { lastCommitHash: latestHash, lastCompactTime: now.toISOString() });
      }
    }

    // 세션 로그 초기화 (Notion에 전송 완료했으므로)
    if (sessionLog) {
      clearSessionLog(cwd);
      console.log('[pre-compact-notion] session-log.md 초기화 완료');
    }

  } catch (err) {
    const errorMsg = `[${new Date().toISOString()}] 오류: ${err.message}\n${err.stack || ''}\n`;
    console.error(`[pre-compact-notion] ${errorMsg}`);
    // 에러 로그 파일에 기록 (다음에 원인 추적 가능)
    try {
      const errorLogPath = path.join(__dirname, 'error.log');
      fs.appendFileSync(errorLogPath, errorMsg, 'utf-8');
    } catch {}
    process.exit(0);
  }
}

main();
