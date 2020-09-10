import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimplePieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimplePieChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory SimplePieChart.withSampleData() {
    return new SimplePieChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory SimplePieChart.withRandomData() {
    return new SimplePieChart(_createRandomData());
  }

  /// Create random data.
  static List<charts.Series<LinearSales2, int>> _createRandomData() {
    final random = new Random();

    final data = [
      new LinearSales2(0, random.nextInt(100)),
      new LinearSales2(1, random.nextInt(100)),
      new LinearSales2(2, random.nextInt(100)),
      new LinearSales2(3, random.nextInt(100)),
    ];

    return [
      new charts.Series<LinearSales2, int>(
        id: 'Sales',
        domainFn: (LinearSales2 sales, _) => sales.year,
        measureFn: (LinearSales2 sales, _) => sales.sales,
        data: data,
      )
    ];
  }
  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList, animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales2, int>> _createSampleData() {
    final data = [
      new LinearSales2(0, 100),
      new LinearSales2(1, 75),
      new LinearSales2(2, 25),
      new LinearSales2(3, 5),
    ];

    return [
      new charts.Series<LinearSales2, int>(
        id: 'Sales',
        domainFn: (LinearSales2 sales, _) => sales.year,
        measureFn: (LinearSales2 sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales2 {
  final int year;
  final int sales;

  LinearSales2(this.year, this.sales);
}