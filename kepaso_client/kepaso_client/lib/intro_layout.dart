import 'kepaso_client.dart';

final random = new Random();

var example = {
  "specversion": "1.0",
  "type": "com.example.someevent",
  "source": "/source",
  "id": "C234-1234-1236",
  "time": DateTime.now().toIso8601String(),
  "datacontenttype": "application/json",
  "data": {"appinfoA": random.nextInt(100), "appinfoB": random.nextInt(100), "appinfoC": random.nextInt(100)}
};

class IntroLayout extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: APP_BAR,
        toolbarHeight: 78.0,
        centerTitle: false,
        title: Row(
          children: [FaIcon(FontAwesomeIcons.checkCircle, color: BLUE), Divider(indent: 10), Text('KEPASO', style: LOGO)],
        ),
      ),
      body: Container(
          color: GRAY,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [getIntro(context)],
          )),
    );
  }
}

Widget getIntro(BuildContext context) {
  return Hero(
      flightShuttleBuilder: (flightContext, Animation<double> animation, flightDirection, fromHeroContext, toHeroContext)
      => _buildFlight(context), tag: "demo", child: _buildPanel(context));
}

Widget _buildFlight(BuildContext context) => ListView(
      children: <Widget>[_buildCard(_buildDockerCard()), _buildCard(_buildPublisherCard()), _buildCard(_buildChartCard(show: false))],
    );

Widget _buildPanel(BuildContext context) => Container(
      width: 440,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildCard(_buildDockerCard()), _buildCard(_buildPublisherCard()), _buildCard(_buildChartCard()), _buildButton(context)],
      ),
    );

  Widget _buildButton(BuildContext context) => FlatButton(
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0)),
      color: BLUE,
      textColor: WHITE,
      hoverColor: BLUE,
      padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
      onPressed: () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 700),
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                return MainLayout();
              },
              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                return FadeTransition(
                    opacity: animation,
                    child: child,
                );
              },
            ),
          );
          Get.find<DemoController>().startDemo();
      },
      child: Text("Start demo", style: BUTTON),
    );

Widget _buildCard(Widget tile) => Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      // elevation: 3,
      child: tile,
      // ),
    );

Widget _buildRow(Widget first, second, third) => Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(padding: EdgeInsets.all(24.0), child: first),
      Expanded(child: Container(padding: EdgeInsets.only(top: 12.0, bottom: 12.0), child: second)),
      Container(padding: EdgeInsets.all(12.0), child: third)
    ]);

Widget _buildDockerCard() => _buildRow(
      FaIcon(FontAwesomeIcons.docker, color: BLUE),
      Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Application start', style: INTRO_TITLE),
        Text('docker run -p 8080:8080 kepaso/kepaso', style: INTRO_CODE),
      ]),
      FaIcon(FontAwesomeIcons.checkCircle, color: GREEN),
      // ),
    );

Widget _buildPublisherCard() => _buildRow(
    FaIcon(FontAwesomeIcons.angleDoubleRight, color: BLUE),
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('Post cloudevent to http:/host:port/events', style: INTRO_TITLE), Text(new JsonEncoder.withIndent('   ').convert(example), style: INTRO_CODE)]),
    FaIcon(FontAwesomeIcons.circle, color: GRAY));

Widget _buildChartCard({bool show = true}) => _buildRow(
    FaIcon(FontAwesomeIcons.eye, color: BLUE),
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enjoy your dashboard', style: INTRO_TITLE),
        show
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _chartContainer(SimpleBarChart.withSampleData()),
                  _chartContainer(SimplePieChart.withRandomData()),
                  _chartContainer(SimpleLineChart.withSampleData()),
                ],
              )
            : Container()
      ],
    ),
    FaIcon(FontAwesomeIcons.circle, color: GRAY));

Widget _chartContainer(Widget widget) => Container(
      width: 80,
      height: 80,
      child: widget,
    );
