import 'package:flutter_test/flutter_test.dart';
import 'package:suci/core/result/result.dart';

void main() {
  group('Result Type Tests', () {
    test('Ok handles value and maps correctly', () {
      const result = Result.ok(42);

      expect(result.isOk, isTrue);
      expect(result.isErr, isFalse);
      expect(result.unwrapOr(0), equals(42));

      final mapped = result.map((v) => 'Value: $v');
      expect(mapped, equals(const Result.ok('Value: 42')));

      final folded = result.fold(
        onSuccess: (data) => 'Success $data',
        onFailure: (err, _) => 'Failed $err',
      );
      expect(folded, equals('Success 42'));
    });

    test('Err handles error and propagates in map', () {
      final exception = Exception('Operation failed');
      final result = Result<int>.err(exception);

      expect(result.isOk, isFalse);
      expect(result.isErr, isTrue);
      expect(result.unwrapOr(100), equals(100));

      final mapped = result.map((v) => v * 2);
      expect(mapped.isErr, isTrue);

      final folded = result.fold(
        onSuccess: (data) => 'Success $data',
        onFailure: (err, _) => 'Error: $err',
      );
      expect(folded, contains('Operation failed'));
    });
  });
}
