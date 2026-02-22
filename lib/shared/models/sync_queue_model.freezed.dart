// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_queue_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SyncQueueItem _$SyncQueueItemFromJson(Map<String, dynamic> json) {
  return _SyncQueueItem.fromJson(json);
}

/// @nodoc
mixin _$SyncQueueItem {
  String get id => throw _privateConstructorUsedError;
  SyncOperation get operation => throw _privateConstructorUsedError;
  String get table => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastAttemptAt => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this SyncQueueItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncQueueItemCopyWith<SyncQueueItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncQueueItemCopyWith<$Res> {
  factory $SyncQueueItemCopyWith(
    SyncQueueItem value,
    $Res Function(SyncQueueItem) then,
  ) = _$SyncQueueItemCopyWithImpl<$Res, SyncQueueItem>;
  @useResult
  $Res call({
    String id,
    SyncOperation operation,
    String table,
    Map<String, dynamic> data,
    int retryCount,
    DateTime createdAt,
    DateTime? lastAttemptAt,
    String? error,
  });
}

/// @nodoc
class _$SyncQueueItemCopyWithImpl<$Res, $Val extends SyncQueueItem>
    implements $SyncQueueItemCopyWith<$Res> {
  _$SyncQueueItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? operation = null,
    Object? table = null,
    Object? data = null,
    Object? retryCount = null,
    Object? createdAt = null,
    Object? lastAttemptAt = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            operation: null == operation
                ? _value.operation
                : operation // ignore: cast_nullable_to_non_nullable
                      as SyncOperation,
            table: null == table
                ? _value.table
                : table // ignore: cast_nullable_to_non_nullable
                      as String,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            retryCount: null == retryCount
                ? _value.retryCount
                : retryCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastAttemptAt: freezed == lastAttemptAt
                ? _value.lastAttemptAt
                : lastAttemptAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncQueueItemImplCopyWith<$Res>
    implements $SyncQueueItemCopyWith<$Res> {
  factory _$$SyncQueueItemImplCopyWith(
    _$SyncQueueItemImpl value,
    $Res Function(_$SyncQueueItemImpl) then,
  ) = __$$SyncQueueItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    SyncOperation operation,
    String table,
    Map<String, dynamic> data,
    int retryCount,
    DateTime createdAt,
    DateTime? lastAttemptAt,
    String? error,
  });
}

/// @nodoc
class __$$SyncQueueItemImplCopyWithImpl<$Res>
    extends _$SyncQueueItemCopyWithImpl<$Res, _$SyncQueueItemImpl>
    implements _$$SyncQueueItemImplCopyWith<$Res> {
  __$$SyncQueueItemImplCopyWithImpl(
    _$SyncQueueItemImpl _value,
    $Res Function(_$SyncQueueItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? operation = null,
    Object? table = null,
    Object? data = null,
    Object? retryCount = null,
    Object? createdAt = null,
    Object? lastAttemptAt = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$SyncQueueItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as SyncOperation,
        table: null == table
            ? _value.table
            : table // ignore: cast_nullable_to_non_nullable
                  as String,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        retryCount: null == retryCount
            ? _value.retryCount
            : retryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastAttemptAt: freezed == lastAttemptAt
            ? _value.lastAttemptAt
            : lastAttemptAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncQueueItemImpl implements _SyncQueueItem {
  const _$SyncQueueItemImpl({
    required this.id,
    required this.operation,
    required this.table,
    required final Map<String, dynamic> data,
    this.retryCount = 0,
    required this.createdAt,
    this.lastAttemptAt,
    this.error,
  }) : _data = data;

  factory _$SyncQueueItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncQueueItemImplFromJson(json);

  @override
  final String id;
  @override
  final SyncOperation operation;
  @override
  final String table;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @JsonKey()
  final int retryCount;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastAttemptAt;
  @override
  final String? error;

  @override
  String toString() {
    return 'SyncQueueItem(id: $id, operation: $operation, table: $table, data: $data, retryCount: $retryCount, createdAt: $createdAt, lastAttemptAt: $lastAttemptAt, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncQueueItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.table, table) || other.table == table) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastAttemptAt, lastAttemptAt) ||
                other.lastAttemptAt == lastAttemptAt) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    operation,
    table,
    const DeepCollectionEquality().hash(_data),
    retryCount,
    createdAt,
    lastAttemptAt,
    error,
  );

  /// Create a copy of SyncQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncQueueItemImplCopyWith<_$SyncQueueItemImpl> get copyWith =>
      __$$SyncQueueItemImplCopyWithImpl<_$SyncQueueItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncQueueItemImplToJson(this);
  }
}

abstract class _SyncQueueItem implements SyncQueueItem {
  const factory _SyncQueueItem({
    required final String id,
    required final SyncOperation operation,
    required final String table,
    required final Map<String, dynamic> data,
    final int retryCount,
    required final DateTime createdAt,
    final DateTime? lastAttemptAt,
    final String? error,
  }) = _$SyncQueueItemImpl;

  factory _SyncQueueItem.fromJson(Map<String, dynamic> json) =
      _$SyncQueueItemImpl.fromJson;

  @override
  String get id;
  @override
  SyncOperation get operation;
  @override
  String get table;
  @override
  Map<String, dynamic> get data;
  @override
  int get retryCount;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastAttemptAt;
  @override
  String? get error;

  /// Create a copy of SyncQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncQueueItemImplCopyWith<_$SyncQueueItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
