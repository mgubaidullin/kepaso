import 'dart:html';
import 'kepaso_client.dart';

class SseClient {
  final _incomingController = StreamController<String>();
  EventSource _eventSource;
  String _serverUrl;
  Timer _errorTimer;

  SseClient(String serverUrl) {
    var clientId = Uuid().v1();
    _eventSource =
        EventSource('$serverUrl?sseClientId=$clientId', withCredentials: true);
    _serverUrl = '$serverUrl?sseClientId=$clientId';
    _eventSource.addEventListener('message', _onIncomingMessage);
    _eventSource.onOpen.listen((_) {
      _errorTimer?.cancel();
    });
    _eventSource.onError.listen((error) {
      if (!(_errorTimer?.isActive ?? false)) {
        // By default the SSE client uses keep-alive.
        // Allow for a retry to connect before giving up.
        _errorTimer = Timer(const Duration(seconds: 5), () {
          _incomingController.addError(error);
          close();
        });
      }
    });
  }

  Stream<Event> get onOpen => _eventSource.onOpen;
  Stream<String> get stream => _incomingController.stream;

  void close() {
    _eventSource.close();
    _incomingController.close();
  }

  void _onIncomingMessage(Event message) {
    final String json = (message as MessageEvent).data as String;
    _incomingController.add(json);
  }
}
