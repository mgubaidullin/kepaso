import 'kepaso_client.dart';

class MainLayout extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: APP_BAR,
        toolbarHeight: 78.0,
        centerTitle: false,
        title: Row(
          children: [FaIcon(FontAwesomeIcons.checkCircle, color: BLUE), Divider(indent: 10), Text('KEPASO', style: LOGO)],
        ),
        actions: <Widget>[
          // action button
          Hero(tag: "demo", child: _buildButtonBar()),
        ],
      ),
      body: Container(
          color: GRAY,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [LeftMenu(), ChartLayout()],
          )),
    );
  }

  Widget _buildButtonBar() {
    return Container(
        width: 300,
        padding: EdgeInsets.only(right: 12.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          GetBuilder<DemoController>(
              builder: (demo) => FlatButton(
                  child: Text(demo.active() ? "Stop demo" : "Start demo", style: BUTTON),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                  color: BLUE,
                  textColor: WHITE,
                  hoverColor: BLUE,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
                  onPressed: () {
                    demo.active() ? demo.stop() : demo.start();
                  })),
        ]));
  }
}

class ChartLayout extends StatelessWidget {
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
        builder: (dataController) =>
            dataController.events.isEmpty ? Expanded(child: new Text("")) : Expanded(child: Padding(padding: const EdgeInsets.only(right: 12), child: _getCharts(context, dataController))));
  }

  Widget _getCharts(BuildContext context, DataController dataController) {
    List<List<CloudEvent>> events = dataController.get();
    switch (events.length) {
      case 1:
        return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: Row(
            children: [_getChart(events.first)],
          ))]);
      case 2:
        return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: Row(
            children: [_getChart(events[0]), _getChart(events[1])],
          ))]);
      case 3:
        return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: Row(
            children: [_getChart(events[0]), _getChart(events[1])],
          )),
          Expanded(
              child: Row(
            children: [_getChart(events[2])],
          ))]);
      case 4:
        return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: Row(
            children: [_getChart(events[0]), _getChart(events[1])],
          )),
          Expanded(
              child: Row(
            children: [_getChart(events[2]), _getChart(events[3])],
          ))]);
      default:
        return new Text("");
    }
  }

  Widget _getChart(List<CloudEvent> events) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
            child: Card(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flex(direction: Axis.horizontal, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Padding(padding: EdgeInsets.only(left: 12), child: Text(events.first.type, style: CHART_TITLE)),
                  IconButton(icon: FaIcon(FontAwesomeIcons.times, color: BLUE), iconSize: 12, splashRadius: 24, onPressed: () {
                    Get.find<DataController>().removeEventType(events.first);
                  })
                ],),
                Expanded(child: Padding(child: KepasoLineChart.generate(events), padding: EdgeInsets.all(6)))
              ],
            ))));
  }
}
