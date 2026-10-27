/// ジェムパズルのレベル定義。
/// 盤面構成、難易度、クリア条件など。

class LevelData {
  const LevelData({
    required this.id,
    required this.chapter,
    required this.index,
    required this.difficulty,
    required this.spec,
    this.moveLimit,
    this.timeLimit,
    this.targetScore,
    this.animalId,
  });

  /// レベルID（例："gem_001"）
  final String id;

  /// チャプター番号（1から始まる）
  final int chapter;

  /// チャプター内のインデックス
  final int index;

  /// 難易度（1-10）
  final int difficulty;

  /// 盤面仕様（JSON形式）
  /// 例: {"width": 6, "height": 8, "grid": [...]}
  final Map<String, Object?> spec;

  /// 手数制限（null なら無制限）
  final int? moveLimit;

  /// 時間制限（秒、null なら無制限）
  final int? timeLimit;

  /// クリアに必要なスコア
  final int? targetScore;

  /// 完成時に出現する動物ID（例："animal_001"）
  final String? animalId;

  /// factory: JSON から復元
  factory LevelData.fromJson(Map<String, Object?> j) => LevelData(
        id: j['id']! as String,
        chapter: j['chapter']! as int,
        index: j['index']! as int,
        difficulty: j['difficulty']! as int,
        spec: Map<String, Object?>.from(j['spec']! as Map),
        moveLimit: j['moveLimit'] as int?,
        timeLimit: j['timeLimit'] as int?,
        targetScore: j['targetScore'] as int?,
        animalId: j['animalId'] as String?,
      );

  /// JSON に変換
  Map<String, Object?> toJson() => {
        'id': id,
        'chapter': chapter,
        'index': index,
        'difficulty': difficulty,
        'spec': spec,
        if (moveLimit != null) 'moveLimit': moveLimit,
        if (timeLimit != null) 'timeLimit': timeLimit,
        if (targetScore != null) 'targetScore': targetScore,
        if (animalId != null) 'animalId': animalId,
      };

  @override
  String toString() =>
      'LevelData($id, ch$chapter-$index, difficulty=$difficulty)';
}

/// レベルパック（チャプター）
class LevelPack {
  const LevelPack({
    required this.id,
    required this.name,
    required this.levels,
    this.unlockAfterPrevious = false,
    this.requires,
  });

  /// パックID（例："chapter_1"）
  final String id;

  /// パック名（UI表示用）
  final String name;

  /// 所属レベルリスト
  final List<LevelData> levels;

  /// 前パック完了後に解放されるか
  final bool unlockAfterPrevious;

  /// 解放に必要なもの（例："ads_watched" など、null なら最初から解放）
  final String? requires;

  /// factory: JSON から復元
  factory LevelPack.fromJson(Map<String, Object?> j) => LevelPack(
        id: j['id']! as String,
        name: j['name']! as String,
        levels: (j['levels']! as List)
            .cast<Map<String, Object?>>()
            .map(LevelData.fromJson)
            .toList(),
        unlockAfterPrevious: j['unlockAfterPrevious'] as bool? ?? false,
        requires: j['requires'] as String?,
      );

  /// JSON に変換
  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'levels': levels.map((l) => l.toJson()).toList(),
        'unlockAfterPrevious': unlockAfterPrevious,
        if (requires != null) 'requires': requires,
      };

  @override
  String toString() => 'LevelPack($id, ${levels.length} levels)';
}
