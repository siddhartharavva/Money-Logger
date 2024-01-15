import 'package:money_logger/services/auth/auth_exceptions.dart';
import 'package:money_logger/services/auth/auth_provider.dart';
import 'package:money_logger/services/auth/auth_user.dart';
import 'package:test/test.dart';
void main(){ 
  group('mock Authentication',() {
    final provider = MockAuthProvider();
    test('should not initialize to begin with',(){
      expect(provider.isInitialized, false);
    });
    test('cannot logged out if not logged in',(){
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>())
        );
    });

    test('should be able to be initiialized',() async {
      await provider.initialize();
      expect(provider.isInitialized,true);
    });

    test('User should not be null after initialization',(){
      expect(provider.currentUser,null);
    }); 

    test('should be able to initialize in less than 2 seconds',() async {
      await provider.initialize();
      expect(provider.isInitialized,true);
    },timeout: const Timeout(Duration(seconds: 2)),
    );
  test('Create user should delegate to login function',()async{
    final badEmailUser = provider.createUser(
      email: 'siddhartha@ravva.com', 
      password: 'anypassword',
      );
    expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundException>()));
    final badPasswordUser = provider.createUser(
      email:'someone@ravva.com',
      password: 'siddu@224',
    );
     expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordException>()));
    final user = await provider.createUser(
      email: 'sid', 
      password:'ravva' ,
    );

    expect(provider.currentUser, user);
    expect(user.isEmailVerified,false);
  });
    test('login user should be able to get verified',() async {
   //   await provider.initialize();
     // expect(provider.isInitialized,true);
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
  test('should be able to logout and login again',()async{
    await provider.logOut();
    await provider.logIn(
      email: 'email', 
      password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
  });
  });
  
}

class NotInitializedException implements Exception {}

class  MockAuthProvider implements AuthProvider{
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password,
    }) async {
      if(!isInitialized) throw NotInitializedException();
        await Future.delayed(const Duration(seconds: 1));
        return logIn(
          email: email, 
          password: password,
        );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1)); 
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email, 
    required String password,
    }) {
      if(!isInitialized) throw NotInitializedException();
      if(email == 'siddhartha@ravva.com') throw UserNotFoundException();
      if(password == 'siddu@224') throw WrongPasswordException();
      const user = AuthUser(isEmailVerified: false);
      _user = user;
      return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if(!isInitialized) throw NotInitializedException();
    if(_user == null) throw UserNotFoundException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() {
    if(!isInitialized) throw NotInitializedException();
    final user = _user;
    if(user == null) throw UserNotFoundException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
    throw UnimplementedError();
  }

}