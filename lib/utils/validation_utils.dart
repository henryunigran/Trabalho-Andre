class ValidationUtils {
  static String? validateEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }
}