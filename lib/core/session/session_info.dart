/// What the router needs to know about the current session.
///
/// Implemented by `AuthCubit` and registered in the locator under this type, so
/// `core/router` never imports a feature.
abstract interface class SessionInfo {
  /// True while the stored token is still being verified at startup. The router
  /// parks every navigation on the splash screen until this becomes false.
  bool get isResolving;

  bool get isAuthenticated;

  /// Signed in **and** approved by an admin (D-01). Unverified users are
  /// confined to `/verification` and the profile editor.
  bool get isVerified;

  /// Permission slugs of the signed-in user; empty when signed out.
  Set<String> get permissions;
}

extension PermissionCheck on Set<String> {
  bool hasAny(Iterable<String> perms) => perms.any(contains);
  bool hasAll(Iterable<String> perms) => perms.every(contains);
}
