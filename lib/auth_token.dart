class AuthToken {
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static String? get token => _token;
}
