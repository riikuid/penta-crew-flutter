/// One business action. `R` is almost always a `Result<T>`.
///
/// Rules (see README):
/// - One usecase per file, params declared in the same file.
/// - Cubit → UseCase → Repository, always. Repositories are pure HTTP.
/// - Side effects (persist token, register device...) belong here, not in
///   the repository and not in the cubit.
abstract interface class UseCase<R, P> {
  Future<R> call(P params);
}

/// Marker for usecases that take no input: `GetMe implements UseCase<Result<User>, NoParams>`.
class NoParams {
  const NoParams();
}
