@Timeout(Duration(microseconds: 500))
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testEmail = "test@gmail.com";
  const testPassword = "password123";
  group("submit", () {
    test(
      '''
    Given formType is signIn
    When signInWithEmailAndPassword succeeds
    Then true is AsyncData
    ''',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        when(() => authRepository.signInWithEmailAndPassword(
              testEmail,
              testPassword,
            )).thenAnswer((_) async => Future.value());
        final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn,
        );
        // expectLater
        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncLoading<void>(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncData<void>(null),
            )
          ]),
        );
        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, true);
      },
    );

    test(
      '''
    Given formType is signIn
    When signInWithEmailAndPassword fails
    Then true is AsynError
    ''',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        final exception = Exception("Connection Failed");
        when(() => authRepository.signInWithEmailAndPassword(
              testEmail,
              testPassword,
            )).thenThrow(exception);
        final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn,
        );
        // expectLater
        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncLoading<void>(),
            ),
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.signIn);
              expect(state.value.hasError, true);
              return true;
            })
          ]),
        );
        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, false);
      },
    );

    test(
      '''
    Given formType is register
    When createUserWithEmailAndPassowrd succeeds
    Then true is AsyncData
    ''',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        when(() => authRepository.createUserWithEmailAndPassowrd(
              testEmail,
              testPassword,
            )).thenAnswer((_) async => Future.value());
        final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.register,
        );
        // expectLater
        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncLoading<void>(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncData<void>(null),
            )
          ]),
        );
        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, true);
      },
    );

    test(
      '''
    Given formType is register
    When signInWithEmailAndPassword fails
    Then true is AsynError
    ''',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        final exception = Exception("Connection Failed");
        when(() => authRepository.createUserWithEmailAndPassowrd(
              testEmail,
              testPassword,
            )).thenThrow(exception);
        final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.register,
        );
        // expectLater
        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncLoading<void>(),
            ),
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.register);
              expect(state.value.hasError, true);
              return true;
            })
          ]),
        );
        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, false);
      },
    );

    test('''
''', () {});
  });

  group(
    "updateFromType",
    () {
      test('''
  Given formType is signIn
  Wheen updateTypeForm call with register
  Then state.formType is register 
  ''', () {
        // setup
        final authRepository = MockAuthRepository();
        final controller = EmailPasswordSignInController(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn);
        // run
        controller.updateFormType(EmailPasswordSignInFormType.register);
        // verify
        expect(
          controller.debugState,
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncData<void>(null),
          ),
        );
      });

      test(
        '''
    Given formType is register
    Wheen updateTypeForm call with signIn
    Then state.formType is signIn 
    ''',
        () {
          // setup
          final authRepository = MockAuthRepository();
          final controller = EmailPasswordSignInController(
              authRepository: authRepository,
              formType: EmailPasswordSignInFormType.register);
          // run
          controller.updateFormType(EmailPasswordSignInFormType.signIn);
          // verify
          expect(
            controller.debugState,
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncData<void>(null),
            ),
          );
        },
      );
    },
  );
}
