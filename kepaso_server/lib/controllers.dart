import 'cloud_event.dart';
import 'kepaso_server.dart';

final StreamController<String> controller = StreamController<String>.broadcast();

class KepasoEventController extends ResourceController {

  @Operation.post()
  Future<Response> publish() async {
    final map = await request.body.decode<Map<String, dynamic>>();
    final CloudEvent event = CloudEvent()..readFromMap(map);
    controller.add("data: ${json.encode(event.asMap())} \n\n");
    return Response.ok(event)..contentType = ContentType.json;
  }
}

class KepasoStreamController extends Controller {

  @override
  Future<Response> handle(Request request) async {
    return Response.ok(controller.stream)
      ..bufferOutput = false
      ..contentType = ContentType("text", "event-stream", charset: "utf-8");
  }
}
