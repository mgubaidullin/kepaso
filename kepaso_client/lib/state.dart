import 'kepaso_client.dart';

class SourceController extends GetxController {
  final Map<String,String> sources = Map();

  addSource(String source) {
    if (!sources.containsKey(sources)){
      sources.putIfAbsent(source, ()  {
        select(source);
        return "";
      });
    }
  }

  remove(String source) {
    sources.remove(source);
    selectedSource.value = sources.keys.first;
    update();
  }

  final RxString selectedSource = RxString('');

  select(String name) {
    selectedSource.value = name;
    update();
  }
}

class DataController extends GetxController {
  Map<String, Set<String>> types = Map();
  Map<String, List<CloudEvent>> events = Map();

  add(CloudEvent event) {
    // add source
    Get.find<SourceController>().addSource(event.source);
    // add type
    types[event.source] =  (types[event.source] ?? Set())..add(event.type);
    // add event
    String key = event.source + ":" + event.type;
    List<CloudEvent> list = events[key] ?? [];
    list.add(event);
    if (list.length > 100){
      list.removeAt(0);
    }
    events[key] = list;
    update();
  }

  List<List<CloudEvent>> get(){
    String source = Get.find<SourceController>().selectedSource.value;
    List<String> keys = types[source].map((e) => source + ":" + e).toList();
    List<List<CloudEvent>> result = [];
    keys.forEach((key) {
      result.add(events[key]);
    });
    return result;
  }

  removeEventType(CloudEvent event) {
    String key = event.source + ":" + event.type;
    events.remove(key);
    Set<String> typeList = types[event.source]..remove(event.type);
    if (typeList.isEmpty){
      types.remove(event.source);
      Get.find<SourceController>().remove(event.source);
    } else {
      types[event.source] = typeList;
    }
    update();
  }
}


class DemoController extends GetxController {
  bool show = true;
  Timer _timer;

  bool active() =>  _timer != null && _timer.isActive;

  stop() {
    _timer.cancel();
    update();
  }

  startDemo() {
    Timer(Duration(seconds: 1), ()  {
      show = false;
      start();
    });
  }

  start() {
    Uuid uuid = Uuid();
    _timer = Timer.periodic(new Duration(milliseconds: 500), (_) {
      Get.find<DataController>().add(CloudEvent.map("org.example.event1", "/demo", uuid.v1(), {"appinfoA" : random.nextInt(100), "appinfoB" : _.tick, "appinfoC" : random.nextInt(100)}));
      Get.find<DataController>().add(CloudEvent.map("org.example.event2", "/demo", uuid.v1(), {"appinfoA" : random.nextInt(100), "appinfoB" : _.tick, "appinfoC" : random.nextInt(100)}));
    });
    update();
  }
}


