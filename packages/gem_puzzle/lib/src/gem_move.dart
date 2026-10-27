/// ジェムパズルの手（操作）。
/// タップ・ドラッグなどのユーザー入力を表現。

enum MoveType {
  /// タップ：指定位置をタップ（周囲との交換など、ルール依存）
  tap,

  /// スワイプ：2点間のスワイプ（移動・交換）
  swipe,

  /// ドラッグ：ドラッグ開始・進行・終了のシーケンス
  drag,
}

class GemMove {
  const GemMove({
    required this.type,
    required this.fromX,
    required this.fromY,
    this.toX,
    this.toY,
  });

  /// 操作種別
  final MoveType type;

  /// 開始位置 X
  final int fromX;

  /// 開始位置 Y
  final int fromY;

  /// 終了位置 X（スワイプ・ドラッグ時）
  final int? toX;

  /// 終了位置 Y（スワイプ・ドラッグ時）
  final int? toY;

  /// factory: JSON から復元
  factory GemMove.fromJson(Map<String, Object?> j) => GemMove(
        type: MoveType.values.byName(j['type']! as String),
        fromX: j['fromX']! as int,
        fromY: j['fromY']! as int,
        toX: j['toX'] as int?,
        toY: j['toY'] as int?,
      );

  /// JSON に変換
  Map<String, Object?> toJson() => {
        'type': type.name,
        'fromX': fromX,
        'fromY': fromY,
        if (toX != null) 'toX': toX,
        if (toY != null) 'toY': toY,
      };

  @override
  String toString() {
    final to = toX != null && toY != null ? '($toX,$toY)' : 'none';
    return 'GemMove($type: ($fromX,$fromY) → $to)';
  }
}
