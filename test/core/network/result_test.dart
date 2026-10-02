import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/network/result.dart';

void main() {
  const success = Result.success(21, statusCode: 200);
  const failed = Result<int>.failed(
    'Validation failed',
    statusCode: 422,
    fieldErrors: {
      'email': ['Email wajib diisi.', 'Format email salah.'],
    },
  );

  group('Result', () {
    test('isSuccess / isFailed', () {
      expect(success.isSuccess, isTrue);
      expect(success.isFailed, isFalse);
      expect(failed.isSuccess, isFalse);
      expect(failed.isFailed, isTrue);
    });

    test('valueOrNull / errorMessage', () {
      expect(success.valueOrNull, 21);
      expect(success.errorMessage, isNull);
      expect(failed.valueOrNull, isNull);
      expect(failed.errorMessage, 'Validation failed');
    });

    test('map transforms the value and keeps statusCode', () {
      final mapped = success.map((v) => 'v$v');
      expect(mapped, isA<Success<String>>());
      expect(mapped.valueOrNull, 'v21');
      expect(mapped.statusCode, 200);
    });

    test('map keeps failure untouched (message, statusCode, fieldErrors)', () {
      final mapped = failed.map((v) => v.toString());
      expect(mapped, isA<Failed<String>>());
      final f = mapped as Failed<String>;
      expect(f.message, 'Validation failed');
      expect(f.statusCode, 422);
      expect(f.fieldErrors, (failed as Failed<int>).fieldErrors);
    });

    test('fold', () {
      expect(
        success.fold(onSuccess: (v) => 'ok $v', onFailed: (f) => 'err'),
        'ok 21',
      );
      expect(
        failed.fold(onSuccess: (v) => 'ok', onFailed: (f) => f.message),
        'Validation failed',
      );
    });

    test('pattern matching on the sealed type', () {
      final label = switch (failed) {
        Success(:final value) => 'success $value',
        Failed(:final message, :final statusCode) => '$statusCode $message',
      };
      expect(label, '422 Validation failed');
    });
  });

  group('Failed', () {
    test('status helpers', () {
      expect(const Failed<void>('x', statusCode: 401).isUnauthorized, isTrue);
      expect(const Failed<void>('x', statusCode: 403).isForbidden, isTrue);
      expect(const Failed<void>('x', statusCode: 404).isNotFound, isTrue);
      expect((failed as Failed<int>).isValidation, isTrue);
      expect(const Failed<void>('x').isUnauthorized, isFalse);
    });

    test('fieldError returns the first message or null', () {
      const f = failed as Failed<int>;
      expect(f.fieldError('email'), 'Email wajib diisi.');
      expect(f.fieldError('password'), isNull);
      expect(const Failed<void>('x').fieldError('email'), isNull);
    });
  });
}
