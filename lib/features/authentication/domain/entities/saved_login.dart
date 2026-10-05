/// Login details the user asked the app to remember ("Remember me").
final class SavedLogin {
  const SavedLogin({required this.loginId, required this.password});

  final String loginId;
  final String password;
}
