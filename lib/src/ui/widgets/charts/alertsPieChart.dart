import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tm_fleet_management/src/utils/appColors.dart';

class AlertsPieChart extends StatefulWidget {
  const AlertsPieChart({super.key});

  @override
  State<AlertsPieChart> createState() => _AlertsPieChartState();
}

class _AlertsPieChartState extends State<AlertsPieChart> {
  int? touchedIndex;

  // Alert categories & subtypes
  final Map<String, Map<String, double>> alertCategories = {
    'Critical': {
      'Power Disconnect': 25,
      'Battery Low': 15,
      'Tilt Alert': 10,
      'Fall Detected': 30,
      'SOS Triggered': 20,
    },
    'Non-Critical': {
      'GPRS Lost': 18,
      'Over Speed': 22,
      'Ignition On': 25,
      'Ignition Off': 20,
      'Geo Fence Alert': 15,
    },
  };

  final Map<String, Color> alertColors = {
    'Power Disconnect': Colors.redAccent,
    'Battery Low': Colors.orange,
    'Tilt Alert': Colors.pinkAccent,
    'Fall Detected': Colors.deepOrange,
    'SOS Triggered': Colors.red,
    'GPRS Lost': Colors.lightBlue,
    'Over Speed': Colors.green,
    'Ignition On': Colors.teal,
    'Ignition Off': Colors.cyan,
    'Geo Fence Alert': Colors.purple,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalCritical = alertCategories['Critical']!.values.reduce(
      (a, b) => a + b,
    );
    final totalNonCritical = alertCategories['Non-Critical']!.values.reduce(
      (a, b) => a + b,
    );
    final totalAlerts = totalCritical + totalNonCritical;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alerts Chart',
          style: GoogleFonts.urbanist(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? tWhite : tBlack,
          ),
        ),
        const SizedBox(height: 30),

        Row(
          children: [
            // Chart
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Ring (Critical vs Non-Critical)
                    PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: tRed.withOpacity(0.5),
                            value: totalCritical,
                            title:
                                '${((totalCritical / totalAlerts) * 100).toStringAsFixed(1)}%',
                            titleStyle: GoogleFonts.urbanist(
                              color: isDark ? tWhite : tBlack,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            radius: 70,
                          ),
                          PieChartSectionData(
                            color: tBlue.withOpacity(0.5),
                            value: totalNonCritical,
                            title:
                                '${((totalNonCritical / totalAlerts) * 100).toStringAsFixed(1)}%',
                            titleStyle: GoogleFonts.urbanist(
                              color: isDark ? tWhite : tBlack,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            radius: 70,
                          ),
                        ],
                        centerSpaceRadius: 95,
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                      ),
                    ),

                    // Inner Ring (individual alert types)
                    PieChart(
                      PieChartData(
                        sections: _buildInnerSections(totalAlerts),
                        centerSpaceRadius: 50,
                        borderData: FlBorderData(show: false),
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  response == null ||
                                  response.touchedSection == null) {
                                touchedIndex = null;
                                return;
                              }
                              touchedIndex =
                                  response.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        sectionsSpace: 0,
                      ),
                    ),

                    // Center Text
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          touchedIndex == null
                              ? 'Total Alerts'
                              : _getAlertNameByIndex(touchedIndex!),
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? tWhite : tBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (touchedIndex == null)
                          Text(
                            totalAlerts.toInt().toString(),
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? tWhite : tBlack,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Legend
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: alertColors.length,
                  itemBuilder: (context, index) {
                    final entry = alertColors.entries.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _buildLegendItem(entry.value, entry.key, isDark),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Build inner pie sections with real percentages
  List<PieChartSectionData> _buildInnerSections(double totalAlerts) {
    final alerts = [
      ...alertCategories['Critical']!.entries,
      ...alertCategories['Non-Critical']!.entries,
    ];

    return List.generate(alerts.length, (index) {
      final alert = alerts[index].key;
      final value = alerts[index].value;
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 60 : 50;

      return PieChartSectionData(
        gradient: LinearGradient(
          colors: [
            alertColors[alert]!.withOpacity(0.9),
            alertColors[alert]!.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        value: value,
        radius: radius,
        title: '${(value / totalAlerts * 100).toStringAsFixed(1)}%',
        titleStyle: GoogleFonts.urbanist(
          color:
              Theme.of(context).brightness == Brightness.dark ? tWhite : tBlack,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      );
    });
  }

  String _getAlertNameByIndex(int index) {
    final alerts = [
      ...alertCategories['Critical']!.keys,
      ...alertCategories['Non-Critical']!.keys,
    ];
    if (index < 0 || index >= alerts.length) return '';
    return alerts[index];
  }

  Widget _buildLegendItem(Color color, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: isDark ? tWhite : tBlack,
            ),
          ),
        ),
      ],
    );
  }
}
