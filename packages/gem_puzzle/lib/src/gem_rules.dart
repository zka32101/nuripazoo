/// ジェムパズルのゲームルール実装。
/// puzzle_core の PuzzleRules<S, M> を実装。

import 'package:puzzle_core/puzzle.dart';

import 'gem_state.dart';
import 'gem_move.dart';
import 'gem_board.dart';

class GemRules implements PuzzleRules<GemState, GemMove> {
  const GemRules({
    this.width = 6,
    this.height = 8,
    this.matchLength = 3,
    this.maxColors = 5,
  });

  /// グリッド幅
  final int width;

  /// グリッド高さ
  final int height;

  /// 消滅に必要な連続ジェム数（デフォルト3個）
  final int matchLength;

  /// ジェムの色種類数（0 ~ maxColors-1）
  final int maxColors;

  @override
  GemState initial(Map<String, Object?> spec) {
    // spec から盤面を再構成（レベルデータ由来）
    final grid = _createInitialGrid(spec);
    final board = GemBoard(
      grid: grid,
      width: width,
      height: height,
      gravity: true,
    );
    return GemState(
      board: board,
      moves: 0,
      score: 0,
      timestamp: DateTime.now(),
    );
  }

  /// 初期グリッドを spec から作成（シンプル実装）
  List<List<int>> _createInitialGrid(Map<String, Object?> spec) {
    // TODO: spec の形式に応じてグリッド生成
    // 暫定実装：ランダム配置
    final grid = <List<int>>[];
    for (int y = 0; y < height; y++) {
      final row = <int>[];
      for (int x = 0; x < width; x++) {
        row.add(DateTime.now().microsecond % maxColors);
      }
      grid.add(row);
    }
    return grid;
  }

  @override
  List<GemMove> legalMoves(GemState state) {
    final moves = <GemMove>[];

    // すべての位置でタップ可能（ルール次第で制限も可能）
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (state.board.gemAt(x, y) != -1) {
          moves.add(GemMove(type: MoveType.tap, fromX: x, fromY: y));

          // 上下左右へのスワイプも合法
          for (final (dx, dy) in [(-1, 0), (1, 0), (0, -1), (0, 1)]) {
            final nx = x + dx;
            final ny = y + dy;
            if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
              if (state.board.gemAt(nx, ny) != -1) {
                moves.add(GemMove(
                  type: MoveType.swipe,
                  fromX: x,
                  fromY: y,
                  toX: nx,
                  toY: ny,
                ));
              }
            }
          }
        }
      }
    }

    return moves;
  }

  @override
  GemState apply(GemState state, GemMove move) {
    // TODO: 手を適用して新しい状態を返す
    // - ジェム交換
    // - マッチング判定・消滅
    // - スコア計算
    // - 重力適用

    // 暫定実装：moves を +1 するだけ
    return state.copyWith(moves: state.moves + 1);
  }

  @override
  bool isWon(GemState state) {
    // TODO: ゲーム終了条件の判定
    // 暫定実装：常に false（無限パズル）
    return false;
  }

  @override
  int score(GemState state) => state.score;

  @override
  String hash(GemState state) {
    // 盤面をハッシュ化（探索の重複除外用）
    final buffer = StringBuffer();
    for (final row in state.board.grid) {
      for (final gem in row) {
        buffer.write(gem);
      }
    }
    return buffer.toString();
  }
}
