import 'package:kepaso_server/kepaso_server.dart';

class CloudEvent extends Serializable {
   String type;
   String specversion;
   String id;
   String source;
   DateTime time;
   String datacontenttype;
   Map<String, dynamic> data;

   CloudEvent(){}

  CloudEvent.create(this.type, this.specversion, this.id, this.source, this.time,
      this.datacontenttype, this.data);

  CloudEvent.map(String type, String source, String id, Map<String, dynamic> data) :
        this.create(type, "1.0", id, source, DateTime.now(), "application/json", data);

  CloudEvent.json(String type, String source, String id, String json) :
        this.create(type, "1.0", id, source, DateTime.now(), "application/json", jsonDecode(json) as Map<String, dynamic>);

  Map<String, dynamic> asMap() {
    return {
      "type": type,
      "specversion": specversion,
      "id": id,
      "source": source,
      "time": time.toIso8601String(),
      "datacontenttype": datacontenttype,
      "data": data
    };
  }

  void readFromMap(Map<String, dynamic> inputMap) {
    type = inputMap['type'] as String;
    specversion = inputMap['specversion'] as String;
    id = inputMap['id'] as String;
    source = inputMap['source'] as String;
    time = DateTime.parse(inputMap['time'] as String);
    datacontenttype = inputMap['datacontenttype'] as String;
    data = inputMap['data'] as Map<String,dynamic>;
  }
}