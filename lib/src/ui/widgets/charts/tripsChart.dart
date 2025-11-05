import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/appColors.dart';

class TripsChart extends StatefulWidget {
  const TripsChart({super.key});

  @override
  State<TripsChart> createState() => _TripsChartState();
}

class _TripsChartState extends State<TripsChart> {
  String _viewMode = "weekly";
  late List<Map<String, dynamic>> chartData;
  int? touchedIndex;
  @override
  void initState() {
    super.initState();
    _generateDummyData();
  }

  void _generateDummyData() {
    if (_viewMode == "weekly") {
      chartData = [
        {"label": "Mon", "trips": 12, "distance": 45, "hours": 4.2},
        {"label": "Tue", "trips": 9, "distance": 38, "hours": 3.5},
        {"label": "Wed", "trips": 15, "distance": 52, "hours": 5.0},
        {"label": "Thu", "trips": 8, "distance": 30, "hours": 2.9},
        {"label": "Fri", "trips": 13, "distance": 48, "hours": 4.6},
        {"label": "Sat", "trips": 10, "distance": 40, "hours": 3.8},
        {"label": "Sun", "trips": 6, "distance": 22, "hours": 2.0},
      ];
    } else if (_viewMode == "monthly") {
      chartData = List.generate(
        6,
        (i) => {
          "label": "W${i + 1}",
          "trips": 40 + i * 5,
          "distance": 180 + i * 20,
          "hours": 18.5 + i * 2.0,
        },
      );
    } else {
      chartData = [
        {"label": "2021", "trips": 480, "distance": 1900, "hours": 200},
        {"label": "2022", "trips": 520, "distance": 2150, "hours": 230},
        {"label": "2023", "trips": 600, "distance": 2400, "hours": 260},
        {"label": "2024", "trips": 670, "distance": 2800, "hours": 290},
        {"label": "2025", "trips": 710, "distance": 3000, "hours": 320},
      ];
    }
  }

  void _updateView(String mode) {
    setState(() {
      _viewMode = mode;
      _generateDummyData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trips Overview',
              style: GoogleFonts.urbanist(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? tWhite : tBlack,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color:
                    isDark ? tWhite.withOpacity(0.1) : tBlack.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  _buildToggleButton("Weekly"),
                  _buildToggleButton("Monthly"),
                  _buildToggleButton("Yearly"),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Chart
        SizedBox(
          height: 190,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              alignment: BarChartAlignment.spaceAround,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < chartData.length) {
                        return Text(
                          chartData[value.toInt()]["label"],
                          style: GoogleFonts.urbanist(
                            fontSize: 11,
                            color:
                                isDark
                                    ? Colors.white70
                                    : Colors.black.withOpacity(0.7),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),

              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipRoundedRadius: 10,
                  tooltipPadding: const EdgeInsets.all(10),
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,

                  // Custom background color via new API
                  getTooltipColor: (group) {
                    return isDark ? tWhite : tBlack;
                  },

                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final data = chartData[group.x.toInt()];

                    // define legend items
                    final legendColors = [tBlue, tGreen, tOrange1];
                    final legendLabels = ["Trips", "Distance", "Hours"];
                    final legendValues = [
                      "${data["trips"]}",
                      "${data["distance"]} km",
                      "${data["hours"]} h",
                    ];

                    // build tooltip text with color dots
                    final spans = <TextSpan>[
                      TextSpan(
                        text: "${data["label"]}\n",
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? tBlack : tWhite,
                        ),
                      ),
                    ];

                    for (int i = 0; i < legendLabels.length; i++) {
                      spans.add(
                        TextSpan(
                          text: "● ",
                          style: TextStyle(
                            color: legendColors[i],
                            fontSize: 14, // slightly larger dot
                          ),
                        ),
                      );
                      spans.add(
                        TextSpan(
                          text: "${legendLabels[i]}: ${legendValues[i]}\n",
                          style: GoogleFonts.urbanist(
                            color: isDark ? tBlack : tWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return BarTooltipItem(
                      '', // base text
                      const TextStyle(), // base style
                      children: spans, // rich children
                      textAlign: TextAlign.start,
                    );
                  },
                ),
              ),

              extraLinesData: ExtraLinesData(
                verticalLines:
                    touchedIndex != null
                        ? [
                          VerticalLine(
                            x: touchedIndex!.toDouble(),
                            color: isDark ? Colors.white38 : Colors.black38,
                            strokeWidth: 1.2,
                            dashArray: [5, 4],
                          ),
                        ]
                        : [],
              ),

              barGroups:
                  chartData.asMap().entries.map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    return BarChartGroupData(
                      x: i,
                      barsSpace: 5,
                      showingTooltipIndicators:
                          touchedIndex == i ? [0, 1, 2] : [],
                      barRods: [
                        BarChartRodData(
                          toY: item["trips"].toDouble(),
                          color: tBlue.withOpacity(0.9),
                          width: 8,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        BarChartRodData(
                          toY: item["distance"].toDouble() / 5,
                          color: tGreen.withOpacity(0.9),
                          width: 8,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        BarChartRodData(
                          toY: item["hours"].toDouble() * 10,
                          color: tOrange1.withOpacity(0.9),
                          width: 8,
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 5),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(color: tBlue.withOpacity(0.9), label: "Trips"),
            SizedBox(width: 6),
            _LegendItem(
              color: tGreen.withOpacity(0.9),
              label: "Distance Travelled",
            ),
            SizedBox(width: 6),
            _LegendItem(
              color: tOrange1.withOpacity(0.9),
              label: "Consumed Hours",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label) {
    final isSelected = _viewMode == label.toLowerCase();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _updateView(label.toLowerCase()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? (isDark ? tWhite : tBlack) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color:
                isSelected
                    ? (isDark ? tBlack : tWhite)
                    : (isDark ? tWhite : tBlack),
          ),
        ),
      ),
    );
  }
}

// Legend item
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? tWhite
                    : tBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
