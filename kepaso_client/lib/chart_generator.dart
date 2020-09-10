import 'kepaso_client.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class KepasoLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  KepasoLineChart(this.seriesList, {this.animate});

  factory KepasoLineChart.generate(List<CloudEvent> events) {
    return new KepasoLineChart(_createData(events), animate: false);
  }

  static List<charts.Series<CloudEvent, int>> _createData(List<CloudEvent> events) {
    return events.first.data.keys.toList().asMap().entries.map((entry) => new charts.Series<CloudEvent, int>(
      id: entry.value,
      colorFn: (CloudEvent event, index) => charts.MaterialPalette.getOrderedPalettes(11)[entry.key].shadeDefault,
      domainFn: (CloudEvent event, index) => index,
      measureFn: (CloudEvent event, _) => event.data[entry.value],
      data: events,
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
        seriesList,
        animate: animate,
    );
  }
}
