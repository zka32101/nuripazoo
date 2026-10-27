/// ジェムパズルレベル生成ツール。
/// 指定難易度・サイズのレベルを生成。

import 'dart:math';
import 'level_data.dart';

class LevelGenerator {
  const LevelGenerator({
    this.width = 6,
    this.height = 8,
    this.maxColors = 5,
  });

  final int width;
  final int height;
  final int maxColors;

  /// 難易度 1-10 に応じてレベルを生成
  LevelData generate({
    required String id,
    required int chapter,
    required int index,
    required int difficulty,
    String? animalId,
  }) {
    final rng = Random(id.hashCode); // ID から決定的乱数を生成

    // 難易度に応じて制約を決定
    final moveLimit = _moveLimitByDifficulty(difficulty);
    final targetScore = _targetScoreByDifficulty(difficulty);

    // 初期盤面を生成
    final grid = _generateGrid(rng);

    return LevelData(
      id: id,
      chapter: chapter,
      index: index,
      difficulty: difficulty,
      spec: {
        'width': width,
        'height': height,
        'grid': grid,
      },
      moveLimit: moveLimit,
      targetScore: targetScore,
      animalId: animalId,
    );
  }

  /// ランダムグリッドを生成
  List<List<int>> _generateGrid(Random rng) {
    final grid = <List<int>>[];
    for (int y = 0; y < height; y++) {
      final row = <int>[];
      for (int x = 0; x < width; x++) {
        row.add(rng.nextInt(maxColors));
      }
      grid.add(row);
    }
    return grid;
  }

  /// 難易度に応じた手数制限を計算
  int? _moveLimitByDifficulty(int difficulty) {
    // 難易度高いほど手数制限が厳しい
    if (difficulty <= 3) return null; // 簡単：無制限
    return switch (difficulty) {
      <= 5 => 50,
      <= 7 => 40,
      <= 9 => 30,
      _ => 20,
    };
  }

  /// 難易度に応じたターゲットスコアを計算
  int _targetScoreByDifficulty(int difficulty) {
    return 1000 * (difficulty ~/ 2 + 1);
  }
}
