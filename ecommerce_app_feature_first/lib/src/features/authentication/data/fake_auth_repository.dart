import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/subjects.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<void> signInEmailAndPassword(String email, String password);
  Future<void> createEmailAndPassowrd(String email, String password);
  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  @override
  Stream<AppUser?> authStateChanges() {
    // TODO: implement authStateChanges
    throw UnimplementedError();
  }

  @override
  Future<void> createEmailAndPassowrd(String email, String password) {
    // TODO: implement createEmailAndPassowrd
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AppUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> signInEmailAndPassword(String email, String password) {
    // TODO: implement signInEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}

class FakeAuthRepository implements AuthRepository {
  final _subject = BehaviorSubject<AppUser?>();
  final _authState = InMemoryStore<AppUser?>(null);
  @override
  Stream<AppUser?> authStateChanges() => _authState.stream; // TODO : Update

  @override
  AppUser? get currentUser => null; // TODO : Update

  @override
  Future<void> signInEmailAndPassword(String email, String password) async {
    if (currentUser == null) {
      createNewUser(email);
    }
  }

  @override
  Future<void> createEmailAndPassowrd(String email, String password) async {
    if (currentUser == null) {
      createNewUser(email);
    }
  }

  @override
  Future<void> signOut() async {
    // await Future.delayed(const Duration(seconds: 3));
    // throw Exception('Connection Failed');
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void createNewUser(String email) {
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
    );
  }
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
