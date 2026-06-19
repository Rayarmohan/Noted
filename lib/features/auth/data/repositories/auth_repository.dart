import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get user;
  Future<UserEntity> signUp(String name, String email, String password);
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity?> getCurrentUser();
  Future<void> signOut();
}
