import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/repositories/auth_repository.dart';

import '../../helpers/stub_adapter.dart';

const _user = {
  'id': 12,
  'name': 'Nadia Putri',
  'email': 'nadia@example.com',
  'verification_status': 'pending',
};

void main() {
  group('AuthRepository', () {
    test('login posts credentials and parses token + user', () async {
      final adapter = StubAdapter.json({
        'message': 'ok',
        'data': {'token': 'abc', 'user': _user},
      });
      final repo = AuthRepository(stubDio(adapter));

      final result = await repo.login(
        email: 'nadia@example.com',
        password: 'password1',
      );

      expect(adapter.lastRequest?.method, 'POST');
      expect(adapter.lastRequest?.path, '/login');
      expect(adapter.lastJsonBody, {
        'email': 'nadia@example.com',
        'password': 'password1',
      });
      final value = (result as Success).value;
      expect(value.token, 'abc');
      expect(value.user.name, 'Nadia Putri');
    });

    test('login 401 → Failed with code invalid_credentials', () async {
      final adapter = StubAdapter.json({
        'message': 'Email or password is incorrect',
        'code': 'invalid_credentials',
      }, status: 401);
      final repo = AuthRepository(stubDio(adapter));

      final result = await repo.login(email: 'x@y.z', password: 'nope');

      final failed = result as Failed;
      expect(failed.isUnauthorized, isTrue);
      expect(failed.code, 'invalid_credentials');
      expect(failed.message, 'Email or password is incorrect');
    });

    test('register sends profile fields snake_case with date-only DOB', () async {
      final adapter = StubAdapter.json({
        'data': {'token': 't', 'user': _user},
      });
      final repo = AuthRepository(stubDio(adapter));

      await repo.register(
        email: 'new@example.com',
        password: 'password1',
        profile: ProfileFields(
          name: 'New Crew',
          phone: '+62812',
          dateOfBirth: DateTime(1999, 4, 12),
          gender: Gender.female,
          branchId: 1,
          address: 'Jl. Kemang',
        ),
      );

      expect(adapter.lastRequest?.path, '/register');
      expect(adapter.lastJsonBody, {
        'name': 'New Crew',
        'phone': '+62812',
        'date_of_birth': '1999-04-12',
        'gender': 'female',
        'branch_id': 1,
        'address': 'Jl. Kemang',
        'email': 'new@example.com',
        'password': 'password1',
        'password_confirmation': 'password1',
      });
    });

    test('register 422 → fieldErrors mapped per field', () async {
      final adapter = StubAdapter.json({
        'message': 'The given data was invalid.',
        'errors': {
          'email': ['The email has already been taken.'],
        },
      }, status: 422);
      final repo = AuthRepository(stubDio(adapter));

      final result = await repo.register(
        email: 'dup@example.com',
        password: 'password1',
        profile: ProfileFields(
          name: 'A',
          phone: '1',
          dateOfBirth: DateTime(2000),
          gender: Gender.male,
          branchId: 1,
          address: 'x',
        ),
      );

      final failed = result as Failed;
      expect(failed.isValidation, isTrue);
      expect(failed.fieldError('email'), 'The email has already been taken.');
    });

    test('getBranches parses a list', () async {
      final adapter = StubAdapter.json({
        'data': [
          {'id': 1, 'name': 'Jakarta'},
          {'id': 2, 'name': 'Bandung'},
        ],
      });
      final repo = AuthRepository(stubDio(adapter));

      final result = await repo.getBranches();

      expect((result as Success).value.map((b) => b.name), ['Jakarta', 'Bandung']);
    });

    test('changePassword PUTs current + new + confirmation', () async {
      final adapter = StubAdapter.json({'message': 'ok'});
      final repo = AuthRepository(stubDio(adapter));

      await repo.changePassword(currentPassword: 'old1', password: 'newpass1');

      expect(adapter.lastRequest?.method, 'PUT');
      expect(adapter.lastRequest?.path, '/me/password');
      expect(adapter.lastJsonBody, {
        'current_password': 'old1',
        'password': 'newpass1',
        'password_confirmation': 'newpass1',
      });
    });
  });
}
