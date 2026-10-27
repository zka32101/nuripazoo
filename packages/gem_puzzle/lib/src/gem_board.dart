/// ジェムパズルの盤面状態。
/// グリッド（N×M）に配置されたジェムの色・状態を管理。

typedef GemGrid = List<List<int>>; // -1: 空, 0-9: ジェム色

class GemBoard {
  const GemBoard({
    required this.grid,
    required this.width,
    required this.height,
    this.gravity = true,
  });

  /// グリッド。-1 = 空、0-9 = ジェム色。
  final GemGrid grid;

  /// グリッド幅
  final int width;

  /// グリッド高さ
  final int height;

  /// 重力が有効か（落下処理）
  final bool gravity;

  /// factory: JSON からの復元
  factory GemBoard.fromJson(Map<String, Object?> j) => GemBoard(
        grid: (j['grid']! as List)
            .cast<List>()
            .map((row) => row.cast<int>().toList())
            .toList(),
        width: j['width']! as int,
        height: j['height']! as int,
        gravity: j['gravity'] as bool? ?? true,
      );

  /// 指定位置のジェムの色を取得（範囲外は -1）
  int gemAt(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return -1;
    return grid[y][x];
  }

  /// 指定位置にジェムを設置
  GemBoard setGem(int x, int y, int color) {
    if (x < 0 || x >= width || y < 0 || y >= height) return this;
    final newGrid = [for (final row in grid) [...row]];
    newGrid[y][x] = color;
    return GemBoard(
      grid: newGrid,
      width: width,
      height: height,
      gravity: gravity,
    );
  }

  /// 指定位置のジェムを削除（-1 で埋める）
  GemBoard removeGem(int x, int y) => setGem(x, y, -1);

  /// グリッドを JSON に変換
  Map<String, Object?> toJson() => {
        'grid': grid,
        'width': width,
        'height': height,
        'gravity': gravity,
      };

  @override
  String toString() => 'GemBoard($width×$height)';
}
