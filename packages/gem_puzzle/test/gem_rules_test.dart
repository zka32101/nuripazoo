import 'package:test/test.dart';
import 'package:gem_puzzle/gem_puzzle.dart';

void main() {
  group('GemRules', () {
    late GemRules rules;

    setUp(() {
      rules = const GemRules(width: 6, height: 8, maxColors: 5);
    });

    test('initial state は有効なグリッドを生成', () {
      final spec = {'width': 6, 'height': 8};
      final state = rules.initial(spec);

      expect(state.moves, equals(0));
      expect(state.score, equals(0));
      expect(state.board.width, equals(6));
      expect(state.board.height, equals(8));
    });

    test('legalMoves は非空のジェムからの手を返す', () {
      final spec = {'width': 6, 'height': 8};
      final state = rules.initial(spec);
      final moves = rules.legalMoves(state);

      expect(moves, isNotEmpty);
      for (final move in moves) {
        expect(state.board.gemAt(move.fromX, move.fromY), isNotNegative);
      }
    });

    test('apply は手を適用して moves をインクリメント', () {
      final spec = {'width': 6, 'height': 8};
      final state = rules.initial(spec);
      final moves = rules.legalMoves(state);

      expect(moves, isNotEmpty);
      final newState = rules.apply(state, moves.first);
      expect(newState.moves, equals(state.moves + 1));
    });

    test('score は非負値を返す', () {
      final spec = {'width': 6, 'height': 8};
      final state = rules.initial(spec);
      expect(rules.score(state), greaterThanOrEqualTo(0));
    });

    test('hash は一貫性を保つ', () {
      final spec = {'width': 6, 'height': 8};
      final state = rules.initial(spec);

      final hash1 = rules.hash(state);
      final hash2 = rules.hash(state);
      expect(hash1, equals(hash2));
    });
  });

  group('GemState', () {
    test('copyWith は新しい状態を作成', () {
      final board = GemBoard(
        grid: [[0, 1], [1, 0]],
        width: 2,
        height: 2,
      );
      final state = GemState(
        board: board,
        moves: 0,
        score: 100,
        timestamp: DateTime.now(),
      );

      final newState = state.copyWith(moves: 5);
      expect(newState.moves, equals(5));
      expect(newState.score, equals(100)); // 変わらない
      expect(identical(state, newState), isFalse);
    });

    test('fromJson / toJson は可逆', () {
      final board = GemBoard(
        grid: [[0, 1], [1, 0]],
        width: 2,
        height: 2,
      );
      final original = GemState(
        board: board,
        moves: 3,
        score: 150,
        timestamp: DateTime.now(),
      );

      final json = original.toJson();
      final restored = GemState.fromJson(json);

      expect(restored.moves, equals(original.moves));
      expect(restored.score, equals(original.score));
      expect(restored.board.width, equals(original.board.width));
    });
  });

  group('GemMove', () {
    test('タップムーブの作成と変換', () {
      final move = GemMove(type: MoveType.tap, fromX: 2, fromY: 3);
      final json = move.toJson();
      final restored = GemMove.fromJson(json);

      expect(restored.type, equals(MoveType.tap));
      expect(restored.fromX, equals(2));
      expect(restored.fromY, equals(3));
    });

    test('スワイプムーブは終点を保持', () {
      final move = GemMove(
        type: MoveType.swipe,
        fromX: 1,
        fromY: 2,
        toX: 3,
        toY: 4,
      );

      expect(move.toX, equals(3));
      expect(move.toY, equals(4));
    });
  });

  group('LevelData', () {
    test('fromJson / toJson は可逆', () {
      final original = LevelData(
        id: 'level_001',
        chapter: 1,
        index: 0,
        difficulty: 3,
        spec: {'width': 6, 'height': 8},
        moveLimit: 50,
        animalId: 'animal_001',
      );

      final json = original.toJson();
      final restored = LevelData.fromJson(json);

      expect(restored.id, equals('level_001'));
      expect(restored.difficulty, equals(3));
      expect(restored.moveLimit, equals(50));
      expect(restored.animalId, equals('animal_001'));
    });
  });

  group('LevelGenerator', () {
    test('難易度に応じてレベルを生成', () {
      final gen = const LevelGenerator();

      final easy = gen.generate(
        id: 'gen_easy',
        chapter: 1,
        index: 0,
        difficulty: 2,
      );
      final hard = gen.generate(
        id: 'gen_hard',
        chapter: 1,
        index: 0,
        difficulty: 9,
      );

      // 難しいレベルの方が手数制限が厳しい（null 除外）
      if (easy.moveLimit != null && hard.moveLimit != null) {
        expect(hard.moveLimit, lessThan(easy.moveLimit!));
      }
    });
  });
}
