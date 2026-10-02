import 'dart:async';

enum SessionEvent {
  /// The API rejected the token. Emitted by `AuthInterceptor`.
  unauthorized,
}

/// Bridge from the network layer to `AuthCubit` without the network layer
/// importing any presentation code.
class SessionEvents {
  final _controller = StreamController<SessionEvent>.broadcast();

  Stream<SessionEvent> get stream => _controller.stream;

  void emit(SessionEvent event) {
    if (!_controller.isClosed) _controller.add(event);
  }

  Future<void> dispose() => _controller.close();
}
