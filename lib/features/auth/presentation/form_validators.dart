/// Client-side checks shared by the auth forms. The password rule mirrors the
/// server's (contract §2: at least 8 characters and one digit) so the live
/// rules card on Reset password and the Register validation agree.
abstract final class FormValidators {
  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _digit = RegExp(r'\d');

  static const int passwordMinLength = 8;

  static bool isEmail(String value) => _email.hasMatch(value.trim());

  static bool hasMinLength(String password) =>
      password.length >= passwordMinLength;

  static bool containsDigit(String password) => _digit.hasMatch(password);

  static bool isStrongPassword(String password) =>
      hasMinLength(password) && containsDigit(password);
}
