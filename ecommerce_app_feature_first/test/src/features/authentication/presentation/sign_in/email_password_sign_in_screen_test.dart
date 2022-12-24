import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  const testEmail = 'test@gmail.com';
  const testPassword = 'testPassword';
  late MockAuthRepository authRepository;

  setUp(
    () {
      authRepository = MockAuthRepository();
    },
  );
  group('signIn', () {
    testWidgets(
      '''
  Given formType is SignIn
  When enter valid email and password
  and on tap signIn button
  then signInWithEmailAndPassword is called
  and onSignedIn callback is called
  and error alert is not shown
  
  ''',
      (tester) async {
        var didSignIn = false;
        final r = AuthRobot(tester);
        when(
          () => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).thenAnswer((_) async => Future.value());
        await r.pumpEmailPasswordSignInContents(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn,
          onSignedIn: () => didSignIn = true,
        );
        await r.enterEmail(testEmail);
        await r.enterPassword(testPassword);
        await r.tapEmailPasswordSubmitButton();
        verify(
          () => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).called(1);
        r.expectErrorAlertNotFound();
        expect(didSignIn, true);
      },
    );
  });
}
