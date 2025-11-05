import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../utils/appColors.dart';
import '../../utils/appLogger.dart';
import '../../utils/appResponsive.dart';

class DeviceGeneralInfoScreen extends StatefulWidget {
  final Map<String, dynamic> device;

  const DeviceGeneralInfoScreen({super.key, required this.device});

  @override
  State<DeviceGeneralInfoScreen> createState() =>
      _DeviceGeneralInfoScreenState();
}

class _DeviceGeneralInfoScreenState extends State<DeviceGeneralInfoScreen> {
  late Color statusColor;

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'moving':
        return tGreen;
      case 'idle':
        return tOrange1;
      case 'stopped':
        return tRed;
      case 'disconnected':
        return tGrey;
      case 'non-coverage':
        return Colors.purple;
      default:
        return tBlack;
    }
  }

  final Map<String, Color> statusColors = {
    'moving': tGreen.withOpacity(0.9),
    'stopped': tRed.withOpacity(0.9),
    'idle': tOrange1.withOpacity(0.9),
    'disconnected': tGrey.withOpacity(0.9),
    'non-coverage': Colors.purple.withOpacity(0.9),
  };

  @override
  void initState() {
    super.initState();
    // Initialize statusColor based on the device's current status
    final status = widget.device['status'] ?? '';
    LoggerUtil.getInstance.print(status);

    statusColor = getStatusColor(status);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const Center(child: Text("Mobile / Tablet layout coming soon")),
      tablet: const Center(child: Text("Mobile / Tablet layout coming soon")),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final device = widget.device;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Left panel
              Expanded(
                flex: 4,
                child: _buildDeviceInfoCard(context, device, isDark),
              ),
              const SizedBox(width: 10),

              // Right panel (placeholder for map, chart, etc.)
              Expanded(flex: 8, child: _buildDeviceStatus(isDark)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoCard(
    BuildContext context,
    Map<String, dynamic> device,
    bool isDark,
  ) {
    return Container(
      height: 215,
      decoration: BoxDecoration(
        color: isDark ? tBlack : tWhite,
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            color: isDark ? tWhite.withOpacity(0.25) : tBlack.withOpacity(0.15),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildTopRow(context, device, isDark),
          const SizedBox(height: 20),
          _buildDeviceStats(context, device, isDark),
          const SizedBox(height: 2),
          Divider(
            color: isDark ? tWhite.withOpacity(0.4) : tBlack.withOpacity(0.4),
            thickness: 0.3,
          ),
          const SizedBox(height: 2),
          _buildLocationRow(device, isDark),
        ],
      ),
    );
  }

  Widget _buildTopRow(
    BuildContext context,
    Map<String, dynamic> device,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImeiVehicleBox(device, isDark),
        const SizedBox(width: 15),
        _buildStatusAndTime(device, isDark),
      ],
    );
  }

  Widget _buildImeiVehicleBox(Map<String, dynamic> device, bool isDark) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: statusColor, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Text(
              device['imei'] ?? '',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? tBlack : tWhite,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              device['vehicleNumber'] ?? '',
              style: GoogleFonts.urbanist(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? tWhite : tBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusAndTime(Map<String, dynamic> device, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            device['status'] ?? '',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? tBlack : tWhite,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            SvgPicture.asset(
              'icons/time.svg',
              width: 16,
              height: 16,
              color: isDark ? tWhite : tBlack,
            ),
            const SizedBox(width: 2),
            Text(
              '15:52 PM 04 NOV 2025',
              style: GoogleFonts.urbanist(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? tWhite : tBlack,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceStats(
    BuildContext context,
    Map<String, dynamic> device,
    bool isDark,
  ) {
    final stats = [
      {'title': 'ODO', 'value': device['odo'] ?? '-'},
      {'title': 'Consumed Hours', 'value': '125 hrs'},
      {'title': 'Immobilize', 'value': 'OFF'},
      {'title': 'Avg. ODO', 'value': '450 km'},
      {'title': 'Avg. Consumed Hours', 'value': '25 hrs'},
      {'title': 'Alerts', 'value': device['alerts'] ?? '-'},
    ];

    List<Row> rows = [];
    for (int i = 0; i < stats.length; i += 3) {
      final chunk = stats.skip(i).take(3).toList();
      rows.add(
        Row(
          children:
              chunk
                  .map(
                    (item) => Expanded(
                      child: _buildStatItem(
                        item['title']!,
                        item['value']!,
                        isDark,
                      ),
                    ),
                  )
                  .toList(),
        ),
      );
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: rows);
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? tWhite : tBlack,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? tWhite : tBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow(Map<String, dynamic> device, bool isDark) {
    return Row(
      children: [
        SvgPicture.asset(
          'icons/geofence.svg',
          width: 16,
          height: 16,
          color: tBlue,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            'Current Location : ${device['location']}',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: isDark ? tWhite : tBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceStatus(bool isDark) {
    return Container(
      height: 215,

      decoration: BoxDecoration(
        color: isDark ? tBlack : tWhite,
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            color: isDark ? tWhite.withOpacity(0.25) : tBlack.withOpacity(0.15),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Status (Past 24 Hours)',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: isDark ? tWhite : tBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          _buildStatusBarChart(isDark),
          const SizedBox(height: 5),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: tGreen.withOpacity(0.9), label: "Moving"),
              SizedBox(width: 6),
              _LegendItem(color: tOrange1.withOpacity(0.9), label: "Idle"),
              SizedBox(width: 6),
              _LegendItem(color: tRed.withOpacity(0.9), label: "Stopped"),
              SizedBox(width: 6),
              _LegendItem(color: tGrey.withOpacity(0.9), label: "Disconnected"),
              SizedBox(width: 6),
              _LegendItem(
                color: Colors.purple.withOpacity(0.9),
                label: "Non-coverage",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBarChart(bool isDark) {
    final Map<String, Color> statusColors = this.statusColors;

    final Map<String, Map<String, int>> hourlyStatusBreakdown = {
      '03:00 PM': {'moving': 25, 'idle': 20, 'stopped': 15},
      '02:00 PM': {'moving': 40, 'idle': 10, 'stopped': 10},
      '01:00 PM': {'moving': 30, 'stopped': 30},
      '12:00 PM': {'idle': 20, 'disconnected': 40},
      '11:00 AM': {'moving': 60},
      '10:00 AM': {'disconnected': 60},
      '09:00 AM': {'moving': 45, 'idle': 15},
      '08:00 AM': {'moving': 20, 'idle': 20, 'stopped': 20},
      '07:00 AM': {'idle': 60},
      '06:00 AM': {'stopped': 60},
      '05:00 AM': {'stopped': 30, 'moving': 30},
      '04:00 AM': {'non-coverage': 60},
      '03:00 AM': {'moving': 15, 'idle': 45},
      '02:00 AM': {'moving': 60},
      '01:00 AM': {'idle': 60},
      '12:00 AM': {'moving': 50, 'stopped': 10},
      '11:00 PM': {'moving': 60},
      '10:00 PM': {'stopped': 60},
      '09:00 PM': {'moving': 30, 'idle': 30},
      '08:00 PM': {'moving': 60},
      '07:00 PM': {'stopped': 60},
      '06:00 PM': {'idle': 60},
      '05:00 PM': {'moving': 60},
      '04:00 PM': {'moving': 30, 'idle': 30},
    };

    final hours = hourlyStatusBreakdown.keys.toList();

    return SizedBox(
      height: 155,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= hours.length)
                    return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      hours[index],
                      style: GoogleFonts.urbanist(
                        fontSize: 8,
                        color: isDark ? tWhite : tBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Bar touch with tooltips
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(10),
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (group) => isDark ? tWhite : tBlack,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                // Get the hour and its data
                final hour = hours[group.x.toInt()];
                final data = hourlyStatusBreakdown[hour]!;

                // Sort entries for consistency
                final entries =
                    data.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value));

                // Build tooltip text
                final spans = <TextSpan>[
                  TextSpan(
                    text: '$hour\n',
                    style: GoogleFonts.urbanist(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? tBlack : tWhite,
                    ),
                  ),
                ];

                for (final e in entries) {
                  spans.add(
                    TextSpan(
                      text: "● ",
                      style: TextStyle(
                        color: statusColors[e.key] ?? Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  );
                  spans.add(
                    TextSpan(
                      text: "${e.key.capitalize()}: ${e.value} min\n",
                      style: GoogleFonts.urbanist(
                        fontSize: 10,
                        color: isDark ? tBlack : tWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return BarTooltipItem(
                  '',
                  const TextStyle(),
                  children: spans,
                  textAlign: TextAlign.start,
                );
              },
            ),
          ),

          // Generate stacked bars
          barGroups: List.generate(hours.length, (index) {
            final hour = hours[index];
            final data = hourlyStatusBreakdown[hour]!;

            double startY = 0.0;
            final totalMins = data.values.fold<int>(0, (sum, v) => sum + v);

            final rods =
                data.entries.map((e) {
                  final color = statusColors[e.key] ?? tBlack;
                  final endY = startY + (e.value / totalMins) * 60;
                  final item = BarChartRodStackItem(startY, endY, color);
                  startY = endY;
                  return item;
                }).toList();

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: 60,
                  rodStackItems: rods,
                  width: 6,
                  borderRadius: BorderRadius.circular(0),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

extension StringCasing on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
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
            fontSize: 11,
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
