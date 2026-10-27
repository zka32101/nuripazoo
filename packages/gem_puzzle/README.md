# gem_puzzle

Everpuzz シリーズ2本目（ジェムパズル×動物育成）のパズルロジック・面生成・検証。

UI（Flutter）は別途この上に載せます。

## 概要

ジェムパズルの盤面ルール、レベル定義、レベル生成などを **pure Dart** で実装。

`puzzle_core` の `PuzzleRules<GemState, GemMove>` トレイトを実装し、
色ソート（`color_sort`）と共通のパズル検証・探索基盤を共有します。

## 構成

```
lib/src/
├─ gem_board.dart        # 盤面グリッド
├─ gem_state.dart        # パズル状態（完全なゲーム状態）
├─ gem_move.dart         # 手（操作）
├─ gem_rules.dart        # PuzzleRules 実装
├─ level_data.dart       # レベル定義・パック定義
└─ generator.dart        # レベル生成
```

## 使用例

### 基本的なゲーム進行

```dart
import 'package:gem_puzzle/gem_puzzle.dart';

final rules = GemRules(width: 6, height: 8);
final state = rules.initial({'width': 6, 'height': 8});

// 合法手を取得
final moves = rules.legalMoves(state);

// 手を適用
final newState = rules.apply(state, moves.first);

// 状態確認
print('Moves: ${newState.moves}, Score: ${newState.score}');
```

### レベル生成

```dart
final gen = LevelGenerator();

// 難易度3のレベルを生成
final level = gen.generate(
  id: 'gem_001',
  chapter: 1,
  index: 0,
  difficulty: 3,
  animalId: 'animal_001',
);

print('Level: ${level.id}, Moves: ${level.moveLimit}');
```

## puzzle_core との連携

- `PuzzleRules<GemState, GemMove>` を実装
- `Progress`：レベルクリア履歴を記録（color_sort と共通）
- `Telemetry`：ゲームイベントをログ（Firebase Analytics へ）

## テスト

```bash
cd packages/gem_puzzle
dart test
```

## 今後の拡張

- [ ] マッチング判定（3個以上揃ったジェムの消滅）
- [ ] 重力・落下処理
- [ ] スコア計算ロジック詳細化
- [ ] ソルバー（BFS で最小手数を求める）
- [ ] 難易度推定（ソルバーで難易度を自動計算）
