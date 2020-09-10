import 'kepaso_client.dart';

void main() {
  final DemoController demoController = Get.put(DemoController());
  final DataController dataController = Get.put(DataController());
  final SourceController sourceController = Get.put(SourceController());

  var channel = SseClient('/stream');
  print(channel);
  channel.stream.listen((s) {
    print(s);
    Map map = json.decode(s);
    CloudEvent e = CloudEvent.fromMap(map);
    dataController.add(e);
  });

  runApp(KepasoApp());
}

class KepasoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KEPASO 1.0',
      theme: ThemeData(
        primaryColor: BLUE,
        accentColor: BLUE,
        textTheme: GoogleFonts.redHatDisplayTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey _keyButton = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SourceController>(builder: (s) => s.sources.isEmpty ? IntroLayout() : MainLayout());
  }
}
