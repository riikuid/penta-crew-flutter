/// User-facing fallback messages used when the server gives none.
///
/// Tone follows the prototype copy: short sentences, no exclamation marks.
abstract final class AppMessages {
  static const String timeout =
      'The connection is taking too long. Check your network and try again.';
  static const String noConnection =
      "Can't reach the server. Check your internet connection.";
  static const String generic = 'Something went wrong. Please try again.';
  static const String sessionExpired =
      'Your session has expired. Please sign in again.';
  static const String forbidden = "You don't have access to this page.";
  static const String cancelled = 'The request was cancelled.';
}
