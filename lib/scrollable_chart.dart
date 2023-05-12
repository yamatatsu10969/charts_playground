import 'dart:math';

import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';

class ScrollableChartScreen extends StatefulWidget {
  const ScrollableChartScreen({Key? key}) : super(key: key);

  @override
  _ScrollableChartScreenState createState() => _ScrollableChartScreenState();
}

class _ScrollableChartScreenState extends State<ScrollableChartScreen> {
  List<double> _values = <double>[];
  double targetMax = 0;
  final bool _isScrollable = true;
  final bool _fixedAxis = true;
  int minItems = 31;
  int? _selected;

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _updateValues();
  }

  void _updateValues() {
    final Random rand = Random();
    final double difference = rand.nextDouble() * 15;

    targetMax = 3 +
        ((rand.nextDouble() * difference * 0.75) - (difference * 0.25))
            .roundToDouble();
    _values.addAll(List.generate(minItems, (index) {
      return 2 + rand.nextDouble() * difference;
    }));
  }

  void _addValues() {
    _values = List.generate(minItems, (index) {
      if (_values.length > index) {
        return _values[index];
      }

      return 2 + Random().nextDouble() * targetMax;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chartState = ChartState(
      data: ChartData.fromList(
        _values.map((e) => ChartItem<void>(e)).toList(),
        axisMax: 20,
      ),
      itemOptions: BarItemOptions(
        padding: EdgeInsets.symmetric(horizontal: _isScrollable ? 8.0 : 2.0),
        minBarWidth: _isScrollable ? 10.0 : 4.0,
        barItemBuilder: (data) {
          return BarItem(
            color: data.itemIndex == _selected ? Colors.yellow : Colors.grey,
            radius: const BorderRadius.vertical(
              top: Radius.circular(24.0),
            ),
          );
        },
      ),
      behaviour: ChartBehaviour(
        scrollSettings: _isScrollable
            ? const ScrollSettings()
            : const ScrollSettings.none(),
        onItemClicked: (item) {
          print('Clicked');
          setState(() {
            _selected = item.itemIndex;
          });
        },
        onItemHoverEnter: (_) {
          print('Hover Enter');
        },
        onItemHoverExit: (_) {
          print('Hover Enter');
        },
      ),
      backgroundDecorations: [
        HorizontalAxisDecoration(
          endWithChart: false,
          lineWidth: 1.0,
          axisStep: 5,
          lineColor: Colors.grey,
        ),
        VerticalAxisDecoration(
          endWithChart: false,
          lineWidth: 1.0,
          axisStep: 1,
          lineColor: Colors.grey,
        ),
        GridDecoration(
          showVerticalGrid: false,
          showHorizontalGrid: false,
          showHorizontalValues: false,
          showVerticalValues: true,
          verticalAxisValueFromIndex: (index) => (index + 1).toString(),
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );

    final height = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scrollable chart',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Colors.white,
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: const [
                          0.5,
                          1.0
                        ]),
                  ),
                  width: _fixedAxis ? 34.0 : 0.0,
                  height: height,
                  child: DecorationsRenderer(
                    _fixedAxis
                        ? [
                            HorizontalAxisDecoration(
                              asFixedDecoration: true,
                              lineWidth: 1.0,
                              axisStep: 5,
                              showValues: true,
                              showLines: false,
                              showTopValue: true,
                              endWithChart: false,
                              axisValue: (value) => '$value',
                              legendPosition: HorizontalLegendPosition.start,
                              legendFontStyle:
                                  Theme.of(context).textTheme.bodySmall,
                              valuesAlign: TextAlign.end,
                              valuesPadding: const EdgeInsets.only(top: 8.0),
                              lineColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withOpacity(0.6),
                            ),
                          ]
                        : [],
                    chartState,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: _isScrollable
                        ? const ScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    child: AnimatedChart(
                      duration: const Duration(milliseconds: 450),
                      width: MediaQuery.of(context).size.width - 24.0,
                      height: height,
                      state: chartState,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
