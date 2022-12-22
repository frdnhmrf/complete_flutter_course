import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = 'test@gmail.com';
  const testPassword = 'password123';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );
  FakeAuthRepository makeAuthRepository() =>
      FakeAuthRepository(addDelay: false);
  group('Fake Auth Reposutory', () {
    test("currentUser is null", () {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      expect(
        authRepository.currentUser,
        null,
      );
      expect(
        authRepository.authStateChanges(),
        emits(null),
      );
    });

    test(
      "signInWithEmailAndPassword is not null  after Sign in",
      () async {
        final authRepository = makeAuthRepository();
        addTearDown(authRepository.dispose);
        await authRepository.signInWithEmailAndPassword(
            testEmail, testPassword);
        expect(
          authRepository.currentUser,
          testUser,
        );
        expect(
          authRepository.authStateChanges(),
          emits(testUser),
        );
      },
    );

    test(
      "createUserWithEmailAndPassowrd is not null  after regitrations",
      () async {
        final authRepository = makeAuthRepository();
        addTearDown(authRepository.dispose);
        await authRepository.createUserWithEmailAndPassowrd(
            testEmail, testPassword);
        expect(
          authRepository.currentUser,
          testUser,
        );
        expect(
          authRepository.authStateChanges(),
          emits(testUser),
        );
      },
    );

    test(
      "currentUser is  null  after Signout",
      () async {
        final authRepository = makeAuthRepository();
        addTearDown(authRepository.dispose);
        await authRepository.signInWithEmailAndPassword(
            testEmail, testPassword);

        expect(
          authRepository.currentUser,
          testUser,
        );
        expect(
          authRepository.authStateChanges(),
          emits(testUser),
        );
        await authRepository.signOut();
        expect(
          authRepository.currentUser,
          null,
        );

        expect(
          authRepository.authStateChanges(),
          emits(null),
        );
      },
    );

    test(
      'Sign in after dispose throws exception',
      () {
        final authRepository = makeAuthRepository();
        authRepository.dispose();

        expect(
          () => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
          throwsStateError,
        );
      },
    );
  });
}
