/// ジェムパズルの盤面状態。
/// 時刻、ボード、手数、スコアなど完全なゲーム状態を保持。

import 'gem_board.dart';

class GemState {
  const GemState({
    required this.board,
    required this.moves,
    required this.score,
    required this.timestamp,
    this.matches = const [],
  });

  /// 現在の盤面
  final GemBoard board;

  /// ここまでの手数
  final int moves;

  /// 現在のスコア
  final int score;

  /// ゲーム開始時刻（タイムアタックなど用）
  final DateTime timestamp;

  /// 消えたジェムの位置リスト（アニメーション用）
  /// 形式: [(x, y), ...]
  final List<(int, int)> matches;

  /// factory: JSON から復元
  factory GemState.fromJson(Map<String, Object?> j) => GemState(
        board: GemBoard.fromJson(j['board']! as Map<String, Object?>),
        moves: j['moves']! as int,
        score: j['score']! as int,
        timestamp: DateTime.parse(j['timestamp']! as String),
        matches: (j['matches'] as List?)
                ?.cast<List>()
                .map((p) => (p[0] as int, p[1] as int))
                .toList() ??
            [],
      );

  /// コピー（一部フィールドを変更）
  GemState copyWith({
    GemBoard? board,
    int? moves,
    int? score,
    DateTime? timestamp,
    List<(int, int)>? matches,
  }) =>
      GemState(
        board: board ?? this.board,
        moves: moves ?? this.moves,
        score: score ?? this.score,
        timestamp: timestamp ?? this.timestamp,
        matches: matches ?? this.matches,
      );

  /// JSON に変換
  Map<String, Object?> toJson() => {
        'board': board.toJson(),
        'moves': moves,
        'score': score,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'matches': matches.map((p) => [p.$1, p.$2]).toList(),
      };

  @override
  String toString() =>
      'GemState(moves=$moves, score=$score, matches=${matches.length})';
}
