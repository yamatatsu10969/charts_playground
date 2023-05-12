import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart(this.seriesList, {super.key, this.animate = true});
  final List<charts.Series<OrdinalSales, String>> seriesList;
  final bool animate;

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return SimpleBarChart(
      _createSampleData(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          child: charts.BarChart(
            seriesList,
            animate: animate,
            behaviors: [
              charts.ChartTitle(
                'Sales',
                behaviorPosition: charts.BehaviorPosition.start,
                titleOutsideJustification:
                    charts.OutsideJustification.middleDrawArea,
              ),
              charts.ChartTitle(
                'Month',
                behaviorPosition: charts.BehaviorPosition.bottom,
                titleOutsideJustification:
                    charts.OutsideJustification.middleDrawArea,
              ),
              // q: 初期値を設定したい。真ん中くらいの zoom になるようにできる？
              // a: できない。初期値は 0.0 で、0.0 は 0% に相当する。
              charts.PanAndZoomBehavior(panningCompletedCallback: () {}),
            ],
            // primaryMeasureAxis: charts.NumericAxisSpec(
            //   renderSpec: charts.GridlineRendererSpec(
            //     labelStyle: const charts.TextStyleSpec(
            //       fontSize: 12,
            //       color: charts.MaterialPalette.white,
            //     ),
            //     lineStyle: charts.LineStyleSpec(
            //       color: charts.MaterialPalette.gray.shadeDefault,
            //     ),
            //   ),
            // ),
            // domainAxis: charts.OrdinalAxisSpec(
            //   renderSpec: charts.SmallTickRendererSpec(
            //     labelStyle: const charts.TextStyleSpec(
            //       fontSize: 12,
            //       color: charts.MaterialPalette.white,
            //     ),
            //     lineStyle: charts.LineStyleSpec(
            //       color: charts.MaterialPalette.gray.shadeDefault,
            //     ),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    // 1..31 までのデータを作成
    final data = List.generate(
      31,
      (index) => OrdinalSales((index + 1).toString(), index * 10),
    );

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
