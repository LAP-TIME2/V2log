#!/usr/bin/env python3
"""
site-guide annotate_and_pdf.py
==============================
steps.json + step_N_raw.png 파일들을 읽어서
어노테이션(번호 원, 강조 사각형, 화살표, 경고 배너, 블러)을 그린 뒤
PDF 가이드를 생성한다.

스크린샷 소스: Playwright MCP (browser_take_screenshot)
- 기본 해상도: 1280x720 CSS 픽셀 (DPI 무관)
- 어노테이션 좌표 = CSS 픽셀 좌표 (변환 불필요)

사용법:
    python annotate_and_pdf.py <temp_dir> <output_pdf_path> [--title "가이드 제목"]

예시:
    python annotate_and_pdf.py temp_guide docs/reference/2026-02-19_사이트가이드_Roboflow.pdf --title "Roboflow 프로젝트 생성"
"""

import json
import math
import os
import sys
from datetime import datetime
from pathlib import Path

from fpdf import FPDF
from PIL import Image, ImageDraw, ImageFilter, ImageFont

# ── 설정 ──────────────────────────────────────────────
FONT_PATH = r"C:\Windows\Fonts\malgun.ttf"
FONT_BOLD_PATH = r"C:\Windows\Fonts\malgunbd.ttf"

# 색상 (RGBA)
RED = (220, 38, 38, 230)
BLUE = (59, 130, 246, 230)
GREEN = (34, 197, 94, 230)
ORANGE = (249, 115, 22, 255)
YELLOW_BG = (254, 243, 199, 220)
YELLOW_BORDER = (234, 179, 8, 255)
WHITE = (255, 255, 255, 255)
BLACK = (0, 0, 0, 255)
SHADOW = (0, 0, 0, 80)

COLOR_MAP = {
    "red": RED,
    "blue": BLUE,
    "green": GREEN,
    "orange": ORANGE,
    "click": RED,
    "input": BLUE,
    "result": GREEN,
}

# PDF 페이지 크기 (A4 landscape에 가까운 16:10)
PDF_W = 297  # mm
PDF_H = 210  # mm


# ── 폰트 로딩 ────────────────────────────────────────
def load_font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    path = FONT_BOLD_PATH if bold and os.path.exists(FONT_BOLD_PATH) else FONT_PATH
    try:
        return ImageFont.truetype(path, size)
    except OSError:
        return ImageFont.load_default()


# ── 어노테이션 함수들 ─────────────────────────────────

def draw_circle_number(draw: ImageDraw.ImageDraw, x: int, y: int, number: int, color=RED, radius: int = 20):
    """번호가 들어간 원을 그린다."""
    # 그림자
    draw.ellipse(
        [x - radius + 2, y - radius + 2, x + radius + 2, y + radius + 2],
        fill=SHADOW,
    )
    # 원
    draw.ellipse(
        [x - radius, y - radius, x + radius, y + radius],
        fill=color,
        outline=WHITE,
        width=2,
    )
    # 숫자
    font = load_font(int(radius * 1.3), bold=True)
    text = str(number)
    bbox = font.getbbox(text)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    draw.text(
        (x - tw // 2, y - th // 2 - bbox[1]),
        text,
        fill=WHITE,
        font=font,
    )


def draw_highlight_rect(draw: ImageDraw.ImageDraw, x: int, y: int, w: int, h: int, color=RED, width: int = 3):
    """강조 사각형 (테두리)을 그린다."""
    # 반투명 배경
    overlay_color = color[:3] + (30,)
    draw.rectangle([x, y, x + w, y + h], fill=overlay_color)
    # 테두리
    draw.rectangle([x, y, x + w, y + h], outline=color, width=width)


def draw_arrow(draw: ImageDraw.ImageDraw, x1: int, y1: int, x2: int, y2: int, color=ORANGE, width: int = 3):
    """화살표를 그린다."""
    draw.line([(x1, y1), (x2, y2)], fill=color, width=width)

    # 화살촉
    angle = math.atan2(y2 - y1, x2 - x1)
    arrow_len = 15
    arrow_angle = math.pi / 6  # 30도

    ax1 = x2 - arrow_len * math.cos(angle - arrow_angle)
    ay1 = y2 - arrow_len * math.sin(angle - arrow_angle)
    ax2 = x2 - arrow_len * math.cos(angle + arrow_angle)
    ay2 = y2 - arrow_len * math.sin(angle + arrow_angle)

    draw.polygon([(x2, y2), (int(ax1), int(ay1)), (int(ax2), int(ay2))], fill=color)


def draw_warning_banner(draw: ImageDraw.ImageDraw, x: int, y: int, w: int, text: str):
    """노란색 경고 배너를 그린다."""
    font = load_font(16, bold=True)
    padding = 10
    h = 40

    # 배경
    draw.rectangle([x, y, x + w, y + h], fill=YELLOW_BG, outline=YELLOW_BORDER, width=2)

    # 경고 아이콘 + 텍스트
    warning_text = f"  {text}"
    draw.text((x + padding, y + padding), warning_text, fill=(146, 64, 14, 255), font=font)


def draw_label(draw: ImageDraw.ImageDraw, x: int, y: int, text: str, color=RED):
    """텍스트 라벨 (배경 포함)."""
    font = load_font(14, bold=True)
    padding = 6
    bbox = font.getbbox(text)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]

    # 배경
    draw.rectangle(
        [x, y, x + tw + padding * 2, y + th + padding * 2],
        fill=color,
    )
    # 텍스트
    draw.text((x + padding, y + padding - bbox[1]), text, fill=WHITE, font=font)


def apply_blur(img: Image.Image, regions: list) -> Image.Image:
    """지정 영역에 가우시안 블러를 적용한다."""
    for region in regions:
        rx, ry, rw, rh = region["x"], region["y"], region["w"], region["h"]
        box = (rx, ry, rx + rw, ry + rh)
        cropped = img.crop(box)
        blurred = cropped.filter(ImageFilter.GaussianBlur(radius=15))
        img.paste(blurred, box)
    return img


# ── 단계별 이미지 어노테이션 ──────────────────────────

def annotate_step(img: Image.Image, step: dict, step_number: int) -> Image.Image:
    """한 단계의 스크린샷에 모든 어노테이션을 적용한다."""
    # RGBA로 변환 (투명도 지원)
    if img.mode != "RGBA":
        img = img.convert("RGBA")

    # 블러 먼저 (다른 어노테이션 아래에)
    blur_regions = step.get("blur_regions", [])
    if blur_regions:
        img = apply_blur(img, blur_regions)

    # 오버레이 레이어
    overlay = Image.new("RGBA", img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    annotations = step.get("annotations", [])

    for ann in annotations:
        ann_type = ann.get("type", "")
        color = COLOR_MAP.get(ann.get("color", "red"), RED)

        if ann_type == "highlight_rect":
            draw_highlight_rect(
                draw,
                ann.get("x", 0), ann.get("y", 0),
                ann.get("w", 100), ann.get("h", 40),
                color=color,
                width=ann.get("width", 3),
            )

        elif ann_type == "circle_number":
            draw_circle_number(
                draw,
                ann.get("x", 0), ann.get("y", 0),
                ann.get("number", step_number),
                color=color,
                radius=ann.get("radius", 20),
            )

        elif ann_type == "arrow":
            draw_arrow(
                draw,
                ann.get("x1", 0), ann.get("y1", 0),
                ann.get("x2", 0), ann.get("y2", 0),
                color=color,
                width=ann.get("width", 3),
            )

        elif ann_type == "warning":
            draw_warning_banner(
                draw,
                ann.get("x", 0), ann.get("y", 0),
                ann.get("w", 400),
                ann.get("text", "주의"),
            )

        elif ann_type == "label":
            draw_label(
                draw,
                ann.get("x", 0), ann.get("y", 0),
                ann.get("text", ""),
                color=color,
            )

    # 단계 번호 뱃지 (좌상단)
    draw_circle_number(draw, 35, 35, step_number, color=RED, radius=25)

    # 합성
    img = Image.alpha_composite(img, overlay)
    return img.convert("RGB")


# ── PDF 생성 ──────────────────────────────────────────

class GuidePDF(FPDF):
    def __init__(self, title: str, url: str):
        super().__init__(orientation="L", unit="mm", format="A4")
        self.guide_title = title
        self.guide_url = url
        self.set_auto_page_break(auto=False)

        # 한글 폰트 등록
        if os.path.exists(FONT_PATH):
            self.add_font("Malgun", "", FONT_PATH)
        if os.path.exists(FONT_BOLD_PATH):
            self.add_font("Malgun", "B", FONT_BOLD_PATH)

    def _use_font(self, style="", size=12):
        try:
            self.set_font("Malgun", style, size)
        except Exception:
            self.set_font("Helvetica", style, size)

    def add_cover_page(self, total_steps: int):
        """표지 페이지."""
        self.add_page()

        # 배경색 (어두운 그라데이션 효과 대신 단색)
        self.set_fill_color(15, 23, 42)  # slate-900
        self.rect(0, 0, PDF_W, PDF_H, "F")

        # 제목
        self.set_text_color(255, 255, 255)
        self._use_font("B", 32)
        self.set_y(60)
        self.cell(0, 20, self.guide_title, new_x="LMARGIN", new_y="NEXT", align="C")

        # URL
        self.set_text_color(148, 163, 184)  # slate-400
        self._use_font("", 14)
        self.cell(0, 10, self.guide_url, new_x="LMARGIN", new_y="NEXT", align="C")

        # 메타 정보
        self.ln(20)
        self.set_text_color(203, 213, 225)  # slate-300
        self._use_font("", 12)
        date_str = datetime.now().strftime("%Y-%m-%d")
        self.cell(0, 8, f"Generated: {date_str}  |  {total_steps} steps", new_x="LMARGIN", new_y="NEXT", align="C")
        self.cell(0, 8, "Created by Claude Code /site-guide", new_x="LMARGIN", new_y="NEXT", align="C")

        # 범례
        self.ln(15)
        self._use_font("B", 11)
        self.set_text_color(255, 255, 255)
        self.cell(0, 8, "Legend:", new_x="LMARGIN", new_y="NEXT", align="C")

        self._use_font("", 10)
        legends = [
            ("RED circle/rect = Click here", 220, 38, 38),
            ("BLUE rect = Type/Input here", 59, 130, 246),
            ("GREEN rect = Result/Confirm", 34, 197, 94),
            ("ORANGE arrow = Look here", 249, 115, 22),
            ("YELLOW banner = Warning", 234, 179, 8),
        ]
        for text, r, g, b in legends:
            self.set_text_color(r, g, b)
            self.cell(0, 7, text, new_x="LMARGIN", new_y="NEXT", align="C")

    def add_step_page(self, step: dict, annotated_img_path: str, step_number: int):
        """단계별 페이지."""
        self.add_page()

        # 헤더 바
        self.set_fill_color(30, 41, 59)  # slate-800
        self.rect(0, 0, PDF_W, 18, "F")

        self.set_text_color(255, 255, 255)
        self._use_font("B", 14)
        self.set_xy(10, 3)
        title = step.get("title", f"Step {step_number}")
        self.cell(0, 12, f"Step {step_number}: {title}", new_x="LMARGIN", new_y="NEXT")

        # 설명 텍스트
        description = step.get("description", "")
        if description:
            self.set_fill_color(241, 245, 249)  # slate-100
            self.rect(5, 20, PDF_W - 10, 12, "F")
            self.set_text_color(30, 41, 59)
            self._use_font("", 10)
            self.set_xy(8, 21)
            self.multi_cell(PDF_W - 16, 5, description)

        # 경고 텍스트
        warning = step.get("warning", "")
        if warning:
            warn_y = 34 if description else 20
            self.set_fill_color(254, 243, 199)  # yellow-100
            self.set_draw_color(234, 179, 8)
            self.rect(5, warn_y, PDF_W - 10, 10, "DF")
            self.set_text_color(146, 64, 14)
            self._use_font("B", 10)
            self.set_xy(8, warn_y + 2)
            self.cell(0, 6, f"  {warning}")

        # 스크린샷 이미지
        img_y = 20
        if description:
            img_y = 34
        if warning:
            img_y += 12

        if os.path.exists(annotated_img_path):
            # 이미지 크기 계산 (페이지에 맞추기)
            available_h = PDF_H - img_y - 5
            available_w = PDF_W - 10

            with Image.open(annotated_img_path) as im:
                iw, ih = im.size
                ratio = min(available_w / iw * (72 / 25.4), available_h / ih * (72 / 25.4))
                # mm 단위로 변환
                display_w = iw * ratio * 25.4 / 72
                display_h = ih * ratio * 25.4 / 72

            # 중앙 정렬
            img_x = (PDF_W - display_w) / 2
            self.image(annotated_img_path, x=img_x, y=img_y, w=display_w, h=display_h)


def build_pdf(temp_dir: str, output_path: str, title: str = "Site Guide"):
    """steps.json을 읽고 PDF를 생성한다."""
    temp_path = Path(temp_dir)
    steps_file = temp_path / "steps.json"

    if not steps_file.exists():
        print(f"ERROR: {steps_file} not found")
        sys.exit(1)

    with open(steps_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    steps = data.get("steps", [])
    url = data.get("url", "")
    guide_title = data.get("title", title)

    if not steps:
        print("ERROR: No steps found in steps.json")
        sys.exit(1)

    print(f"Processing {len(steps)} steps...")

    # 각 단계 이미지 어노테이션
    annotated_paths = []
    for i, step in enumerate(steps):
        step_num = i + 1
        raw_img_path = temp_path / step.get("image", f"step_{step_num}_raw.png")

        if not raw_img_path.exists():
            print(f"  WARNING: {raw_img_path} not found, skipping step {step_num}")
            annotated_paths.append(None)
            continue

        print(f"  Annotating step {step_num}: {step.get('title', '?')}")
        img = Image.open(raw_img_path)
        annotated = annotate_step(img, step, step_num)

        annotated_path = temp_path / f"step_{step_num}_annotated.png"
        annotated.save(annotated_path, "PNG")
        annotated_paths.append(str(annotated_path))

    # PDF 생성
    print(f"Generating PDF: {output_path}")
    os.makedirs(os.path.dirname(output_path) or ".", exist_ok=True)

    pdf = GuidePDF(guide_title, url)
    pdf.add_cover_page(len(steps))

    for i, step in enumerate(steps):
        step_num = i + 1
        img_path = annotated_paths[i]
        if img_path and os.path.exists(img_path):
            pdf.add_step_page(step, img_path, step_num)
        else:
            # 이미지 없이 텍스트만
            pdf.add_page()
            pdf.set_fill_color(30, 41, 59)
            pdf.rect(0, 0, PDF_W, 18, "F")
            pdf.set_text_color(255, 255, 255)
            try:
                pdf.set_font("Malgun", "B", 14)
            except Exception:
                pdf.set_font("Helvetica", "B", 14)
            pdf.set_xy(10, 3)
            pdf.cell(0, 12, f"Step {step_num}: {step.get('title', '')}")
            pdf.set_text_color(0, 0, 0)
            try:
                pdf.set_font("Malgun", "", 12)
            except Exception:
                pdf.set_font("Helvetica", "", 12)
            pdf.set_xy(10, 25)
            pdf.multi_cell(0, 6, step.get("description", "(No screenshot available)"))

    pdf.output(output_path)
    print(f"PDF saved: {output_path}")
    print(f"Total pages: {pdf.page} (1 cover + {len(steps)} steps)")


# ── CLI 진입점 ────────────────────────────────────────

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Generate annotated PDF guide from screenshots")
    parser.add_argument("temp_dir", help="Directory with steps.json and step_N_raw.png files")
    parser.add_argument("output_pdf", help="Output PDF file path")
    parser.add_argument("--title", default="Site Guide", help="Guide title")
    args = parser.parse_args()

    build_pdf(args.temp_dir, args.output_pdf, args.title)
