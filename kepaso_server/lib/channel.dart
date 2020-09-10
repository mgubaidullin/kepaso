import 'kepaso_server.dart';

class KepasoStreamChannel extends ApplicationChannel {

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    }

  @override
  Controller get entryPoint {
    return Router()
      ..route("/*").link(() => FileController("web/")..addCachePolicy(const CachePolicy(preventCaching: true), (path) => false))
      ..route("/events").link(() => KepasoEventController())
      ..route("/stream").link(() => KepasoStreamController());
  }
}
