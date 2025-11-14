import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../utils/appColors.dart';
import '../../utils/appLogger.dart';
import '../../utils/appResponsive.dart';
import '../widgets/charts/alertsChart.dart';
import '../widgets/charts/doughnutChart.dart';
import '../widgets/charts/speedDistanceChart.dart';
import '../widgets/charts/tripsChart.dart';

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
      default:
        return tBlack;
    }
  }

  final Map<String, Color> statusColors = {
    'moving': tGreen.withOpacity(0.9),
    'stopped': tRed.withOpacity(0.9),
    'idle': tOrange1.withOpacity(0.9),
    'halted': tBlue.withOpacity(0.9),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: buildDeviceCard(
            isDark: isDark,
            imei: device['imei'] ?? '12265679827872127',
            vehicleNumber: device['vehicleNumber'] ?? 'VGFDG4251271677',
            status: device['status'] ?? 'Moving',
            fuel: device['fuel'] ?? '',
            odo: device['odo'] ?? '',
            trips: device['trips'] ?? '',
            alerts: device['alerts'] ?? '',
            location: device['location'] ?? '',
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              // padding: const EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Left panel
                      Expanded(
                        flex: 5,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 🔹 Left section (Title + Doughnut Charts)
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 225,
                                decoration: BoxDecoration(
                                  color: isDark ? tBlack : tWhite,
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color:
                                          isDark
                                              ? tWhite.withOpacity(0.25)
                                              : tBlack.withOpacity(0.15),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SingleDoughnutChart(
                                      currentValue: 12.8,
                                      avgValue: 12,
                                      title: "Voltage",
                                      unit: "V",
                                      primaryColor: tBlue,
                                      isDark: isDark,
                                    ),
                                    SingleDoughnutChart(
                                      currentValue: 72,
                                      avgValue: 55,
                                      title: "Speed",
                                      unit: "km/h",
                                      primaryColor: tGreen,
                                      isDark: isDark,
                                    ),
                                    SingleDoughnutChart(
                                      currentValue: 64,
                                      avgValue: 50,
                                      title: "Fuel",
                                      unit: "%",
                                      primaryColor: tBlueSky,
                                      isDark: isDark,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // 🔹 Right section (Info cards)
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildInfoCard(
                                    isDark,
                                    "Odometer (km)",
                                    "25,412",
                                    tBlueGradient2,
                                  ),
                                  const SizedBox(height: 10),

                                  _buildInfoCard(
                                    isDark,
                                    "Vehicle ON Hours (hrs)",
                                    "4527289",
                                    tRedGradient2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Right panel (placeholder for map, chart, etc.)
                      Expanded(flex: 5, child: _buildDeviceStatus(isDark)),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 330,
                          decoration: BoxDecoration(
                            color: isDark ? tBlack : tWhite,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color:
                                    isDark
                                        ? tWhite.withOpacity(0.25)
                                        : tBlack.withOpacity(0.15),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 6,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTripsHeaderSection(isDark),
                              Divider(
                                color:
                                    isDark
                                        ? tWhite.withOpacity(0.6)
                                        : tBlack.withOpacity(0.6),
                                thickness: 0.6,
                              ),
                              SizedBox(height: 5),
                              _buildTripsBottomSection(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 330,
                          decoration: BoxDecoration(
                            color: isDark ? tBlack : tWhite,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color:
                                    isDark
                                        ? tWhite.withOpacity(0.25)
                                        : tBlack.withOpacity(0.15),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(5),
                          child: buildVehicleMap(isDark: isDark, zoom: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 330,
                          decoration: BoxDecoration(
                            color: isDark ? tBlack : tWhite,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color:
                                    isDark
                                        ? tWhite.withOpacity(0.25)
                                        : tBlack.withOpacity(0.15),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAlertsHeaderSection(isDark),
                              Divider(
                                color:
                                    isDark
                                        ? tWhite.withOpacity(0.6)
                                        : tBlack.withOpacity(0.6),
                                thickness: 0.6,
                              ),
                              _buildAlertsBottomSection(),
                              const SizedBox(height: 5),
                              Text(
                                'Alerts Info',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: isDark ? tWhite : tBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: _buildAlertsWidget(isDark: isDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 330,
                          decoration: BoxDecoration(
                            color: isDark ? tBlack : tWhite,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color:
                                    isDark
                                        ? tWhite.withOpacity(0.25)
                                        : tBlack.withOpacity(0.15),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(15),
                          child: TripsChart(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 330,
                          decoration: BoxDecoration(
                            color: isDark ? tBlack : tWhite,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color:
                                    isDark
                                        ? tWhite.withOpacity(0.25)
                                        : tBlack.withOpacity(0.15),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(15),
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
                              const SizedBox(height: 15),
                              _buildStatusBarChart(isDark),
                              const SizedBox(height: 10),
                              // Legend
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _LegendItem(
                                    color: tGreen.withOpacity(0.9),
                                    label: "Moving",
                                  ),
                                  SizedBox(width: 6),
                                  _LegendItem(
                                    color: tOrange1.withOpacity(0.9),
                                    label: "Idle",
                                  ),
                                  SizedBox(width: 6),
                                  _LegendItem(
                                    color: tRed.withOpacity(0.9),
                                    label: "Stopped",
                                  ),
                                  SizedBox(width: 6),
                                  _LegendItem(
                                    color: tBlue.withOpacity(0.9),
                                    label: "Halted",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 330,
                          decoration: BoxDecoration(
                            color: isDark ? tBlack : tWhite,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color:
                                    isDark
                                        ? tWhite.withOpacity(0.25)
                                        : tBlack.withOpacity(0.15),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(15),
                          child: AlertsChart(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    bool isDark,
    String title,
    String value,
    Gradient cardColor,
  ) {
    return Container(
      width: double.infinity, // fits 2 per row
      decoration: BoxDecoration(
        color: tTransparent,
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            color: isDark ? tWhite.withOpacity(0.25) : tBlack.withOpacity(0.15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? tBlack : tWhite,
              // border: Border.all(width: 0.5, color: isDark ? tWhite : tBlack),
            ),
            child: Text(
              title,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: isDark ? tWhite : tBlack,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          /// Gradient Value Box
          Container(
            height: 78,
            width: double.infinity,
            decoration: BoxDecoration(gradient: cardColor),
            alignment: Alignment.center,
            child: Text(
              value,
              style: GoogleFonts.urbanist(
                fontSize: 33,
                color: tWhite,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeviceCard({
    required bool isDark,
    required String vehicleNumber,
    required String status,
    required String imei,
    required String fuel,
    required String odo,
    required String trips,
    required String alerts,
    required String location,
  }) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'moving':
        statusColor = tGreen;
        break;
      case 'idle':
        statusColor = tOrange1;
        break;
      case 'stopped':
        statusColor = tRed;
        break;
      case 'disconnected':
        statusColor = tGrey;
        break;
      default:
        statusColor = tBlack;
    }

    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        // color: tGrey.withOpacity(0.1),
        color: isDark ? tBlack : tWhite,
        // borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            color: isDark ? tWhite.withOpacity(0.25) : tBlack.withOpacity(0.15),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SvgPicture.asset('icons/truck1.svg', width: 80, height: 80),
          Image.asset(
            'images/truck1.png',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ===== Top Row =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ==== Left Side (IMEI + Vehicle + Status) ====
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // IMEI + Vehicle ID Container
                          Flexible(
                            child: Container(
                              width: 350,
                              // constraints: const BoxConstraints(
                              //   minWidth: 200,
                              //   maxWidth: 400,
                              // ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: statusColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // IMEI Box
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: SweepGradient(
                                        colors: [
                                          statusColor,
                                          statusColor.withOpacity(0.6),
                                        ],
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      '727288256$imei',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? tWhite : tBlack,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  // Vehicle ID Text
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          'VEHICLE - $vehicleNumber',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? tWhite : tBlack,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Moving Status Container
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: SweepGradient(
                                colors: [
                                  statusColor,
                                  statusColor.withOpacity(0.6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? tWhite : tBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ==== Right Side ====
                    SvgPicture.asset(
                      'icons/immobilize_ON.svg',
                      width: 25,
                      height: 25,
                      color: isDark ? tRed : tGreen,
                    ),
                  ],
                ),

                const SizedBox(height: 2),
                Divider(
                  // color:
                  //     isDark
                  //         ? tWhite.withOpacity(0.4)
                  //         : tBlack.withOpacity(0.4),
                  color: statusColor,
                  thickness: 0.3,
                ),
                const SizedBox(height: 2),

                // ===== Bottom Row (Location) =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: SvgPicture.asset(
                              'icons/geofence.svg',
                              color: statusColor,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Live Location: $location',
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: isDark ? tWhite : tBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'DateTime :',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '15:52 PM 04 NOV 2025',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceStatus(bool isDark) {
    return Container(
      height: 225,
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
      child: SpeedDistanceChart(),
    );
  }

  Widget _buildStatusBarChart(bool isDark) {
    final Map<String, Color> statusColors = this.statusColors;

    final Map<String, Map<String, int>> hourlyStatusBreakdown = {
      '12:00 AM': {'moving': 50, 'stopped': 10},
      '01:00 AM': {'idle': 60},
      '02:00 AM': {'moving': 60},
      '03:00 AM': {'moving': 15, 'idle': 45},
      '04:00 AM': {'halted': 60},
      '05:00 AM': {'stopped': 30, 'moving': 30},
      '06:00 AM': {'stopped': 60},
      '07:00 AM': {'idle': 60},
      '08:00 AM': {'moving': 20, 'idle': 20, 'stopped': 20},
      '09:00 AM': {'moving': 45, 'idle': 15},
      '10:00 AM': {'halted': 60},
      '11:00 AM': {'moving': 60},
      '12:00 PM': {'idle': 20, 'halted': 40},
      '01:00 PM': {'moving': 30, 'stopped': 30},
      '02:00 PM': {'moving': 40, 'idle': 10, 'stopped': 10},
      '03:00 PM': {'moving': 25, 'idle': 20, 'stopped': 15},
      '04:00 PM': {'moving': 30, 'idle': 30},
      '05:00 PM': {'moving': 60},
      '06:00 PM': {'idle': 60},
      '07:00 PM': {'stopped': 60},
      '08:00 PM': {'moving': 60},
      '09:00 PM': {'moving': 30, 'idle': 30},
      '10:00 PM': {'stopped': 60},
      '11:00 PM': {'moving': 60},
    };

    // Ensure hours are sorted chronologically
    final hours = hourlyStatusBreakdown.keys.toList();

    // --- ✅ Combine every 2 consecutive hours in normal order ---
    final Map<String, Map<String, int>> mergedData = {};
    for (int i = 0; i < hours.length; i += 2) {
      final hour1 = hours[i];
      final hour2 = (i + 1 < hours.length) ? hours[i + 1] : null;

      // Label like "02:00 PM - 03:00 PM"
      String label = hour2 != null ? "$hour1\n$hour2" : hour1;

      final combined = <String, int>{};

      // Merge hour1 data
      hourlyStatusBreakdown[hour1]!.forEach((k, v) {
        combined[k] = (combined[k] ?? 0) + v;
      });

      // Merge hour2 data if present
      if (hour2 != null) {
        hourlyStatusBreakdown[hour2]!.forEach((k, v) {
          combined[k] = (combined[k] ?? 0) + v;
        });
      }

      mergedData[label] = combined;
    }

    final mergedHours = mergedData.keys.toList();

    return SizedBox(
      height: 240,
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
                  if (index < 0 || index >= mergedHours.length) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      mergedHours[index],
                      style: GoogleFonts.urbanist(
                        fontSize: 8,
                        color: isDark ? tWhite : tBlack,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),

          // ✅ Tooltip data (unchanged)
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(10),
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (group) => isDark ? tWhite : tBlack,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final label = mergedHours[group.x.toInt()];
                final data = mergedData[label]!;

                final entries =
                    data.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value));

                final spans = <TextSpan>[
                  TextSpan(
                    text: '$label\n',
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

          // ✅ Generate merged stacked bars
          barGroups: List.generate(mergedHours.length, (index) {
            final label = mergedHours[index];
            final data = mergedData[label]!;

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
                  width: 15,
                  borderRadius: BorderRadius.circular(0),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAlertsHeaderSection(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTotalAlertsInfo(isDark),
        _buildIconCircle('icons/alerts.svg', tRedDark),
      ],
    );
  }

  Widget _buildTripsHeaderSection(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTotalTripsInfo(isDark),
        _buildIconCircle('icons/trip.svg', tPink2),
      ],
    );
  }

  Widget _buildTotalAlertsInfo(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alerts',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '575',
          style: GoogleFonts.urbanist(
            fontSize: 35,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalTripsInfo(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trips',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '50745',
          style: GoogleFonts.urbanist(
            fontSize: 35,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildIconCircle(String iconPath, Color color) => Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      // color: color.withOpacity(0.25),
      gradient: SweepGradient(
        colors: [color.withOpacity(0.6), color.withOpacity(0.2)],
      ),
      shape: BoxShape.circle,
    ),
    padding: const EdgeInsets.all(15),
    child: SvgPicture.asset(iconPath, width: 30, height: 30, color: color),
  );

  Widget _buildAlertsBottomSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAnyValuesColumn(
          iconPath: 'icons/alerts.svg',
          iconColor: tRedDark,
          title: 'Crtitical Alerts',
          value: '195',
        ),
        _buildAnyValuesColumn(
          iconPath: 'icons/alerts.svg',
          iconColor: tBlue1,
          title: 'Non-Critical Alerts',
          value: '380',
        ),
      ],
    );
  }

  Widget _buildTripsBottomSection() {
    final List<Map<String, dynamic>> tripStats = [
      {
        'iconPath': 'icons/completed.svg',
        'iconColor': tBlue,
        'title': 'Completed Trips',
        'value': '1250',
      },
      {
        'iconPath': 'icons/trip.svg',
        'iconColor': tOrange1,
        'title': 'Avg. Trips',
        'value': '200',
      },
      {
        'iconPath': 'icons/distance.svg',
        'iconColor': tGreen,
        'title': 'Distance Covered (km)',
        'value': '120,450',
      },
      {
        'iconPath': 'icons/distance.svg',
        'iconColor': tRedDark,
        'title': 'Avg. Dist. Covered (km)',
        'value': '25,200',
      },
      {
        'iconPath': 'icons/consumedhours.svg',
        'iconColor': tPink,
        'title': 'Consumed Hours',
        'value': '3,450',
      },
      {
        'iconPath': 'icons/consumedhours.svg',
        'iconColor': tBlueSky,
        'title': 'Avg. Consumed Hours',
        'value': '45',
      },
    ];

    // 🔹 Build rows with 2 items each
    List<Widget> rows = [];
    for (int i = 0; i < tripStats.length; i += 2) {
      final first = tripStats[i];
      final second = (i + 1 < tripStats.length) ? tripStats[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              // First item
              Expanded(
                child: _buildAnyValuesColumn(
                  iconPath: first['iconPath'],
                  iconColor: first['iconColor'],
                  title: first['title'],
                  value: first['value'],
                ),
              ),

              const SizedBox(width: 10),

              // Second item (if exists)
              Expanded(
                child:
                    second != null
                        ? _buildAnyValuesColumn(
                          iconPath: second['iconPath'],
                          iconColor: second['iconColor'],
                          title: second['title'],
                          value: second['value'],
                        )
                        : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _buildAnyValuesColumn({
    required String iconPath,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(iconPath, width: 25, height: 25, color: iconColor),
            const SizedBox(width: 5),
            Text(
              value,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: isDark ? tWhite : tBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildVehicleMap({bool isDark = false, double zoom = 14.0}) {
    //Step 1: Ensure valid map data
    if (widget.device == null || widget.device is! Map) {
      return const Center(child: Text("Invalid device data"));
    }

    final deviceLatLngRaw = widget.device['latlng'];
    LatLng? deviceLatLng;

    if (deviceLatLngRaw is LatLng) {
      deviceLatLng = deviceLatLngRaw;
    } else if (deviceLatLngRaw is Map) {
      final lat = deviceLatLngRaw['lat'] ?? deviceLatLngRaw['latitude'];
      final lng = deviceLatLngRaw['lng'] ?? deviceLatLngRaw['longitude'];
      if (lat != null && lng != null) {
        deviceLatLng = LatLng(lat.toDouble(), lng.toDouble());
      }
    }

    if (deviceLatLng == null) {
      return const Center(child: Text("No location data available"));
    }

    final deviceStatus = widget.device['status'] ?? 'unknown';
    final tileUrl =
        isDark
            ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
            : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';

    String getTruckIcon(String status) {
      switch (status.toLowerCase()) {
        case 'moving':
          return 'assets/icons/truck1.svg';
        case 'idle':
          return 'assets/icons/truck3.svg';
        case 'stopped':
          return 'assets/icons/truck4.svg';
        case 'disconnected':
          return 'assets/icons/truck5.svg';
        default:
          return 'assets/icons/truck1.svg';
      }
    }

    Color getCircleColor(String status) {
      switch (status.toLowerCase()) {
        case 'moving':
          return tGreen.withOpacity(0.3);
        case 'idle':
          return tOrange1.withOpacity(0.3);
        case 'stopped':
          return tRed.withOpacity(0.3);
        case 'disconnected':
          return tGrey.withOpacity(0.3);
        default:
          return tBlue.withOpacity(0.3);
      }
    }

    final iconPath = getTruckIcon(deviceStatus);
    final circleColor = getCircleColor(deviceStatus);

    // ✅ Step 2: Bounded size for FlutterMap
    return SizedBox(
      height: 300,
      child: FlutterMap(
        key: const ValueKey('vehicle_map_widget'),
        options: MapOptions(
          initialCenter: deviceLatLng,
          initialZoom: zoom,
          maxZoom: 18.0,
          minZoom: 3.0,
        ),
        children: [
          TileLayer(
            urlTemplate: tileUrl,
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          CircleLayer(
            circles: [
              CircleMarker(
                point: deviceLatLng,
                color: circleColor,
                borderStrokeWidth: 1,
                borderColor: circleColor.withOpacity(0.7),
                radius: 125,
                useRadiusInMeter: true,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: deviceLatLng,
                width: 35,
                height: 35,
                child: SvgPicture.asset(iconPath, width: 30, height: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsWidget({bool isDark = false}) {
    // 10 dummy alert entries
    final List<Map<String, String>> alerts = List.generate(10, (index) {
      final alertTypes = [
        'Power Disconnect',
        'GPRS Lost',
        'Over Speed',
        'Ignition On',
        'Ignition Off',
        'Geo Fence Alert',
        'Battery Low',
        'Tilt Alert',
        'Fall Detected',
        'SOS Triggered',
      ];

      return {
        'vehicleId': 'VHC-${1000 + index}',
        'imei': 'IMEI-${8900000 + index}',
        'dateTime': '26 Oct 2025, ${10 + index}:15:30',
        'alertType': alertTypes[index % alertTypes.length],
      };
    });

    Color getAlertColor(String type) {
      if (type.contains('Disconnect') || type.contains('Lost')) return tRed;
      if (type.contains('Low') || type.contains('Fall')) return tOrange1;
      if (type.contains('Speed')) return Colors.amber;
      if (type.contains('Ignition')) return tBlue;
      if (type.contains('Geo') || type.contains('Tilt')) return Colors.purple;
      if (type.contains('SOS')) return Colors.redAccent;
      return tGrey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...alerts.map((alert) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 4, top: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? tBlack : tWhite,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 6,
                    color:
                        isDark
                            ? tWhite.withOpacity(0.1)
                            : tBlack.withOpacity(0.1),
                  ),
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Vehicle ID + IMEI
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle: ${alert['vehicleId']}',
                        style: GoogleFonts.urbanist(
                          color: isDark ? tWhite : tBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'IMEI: ${alert['imei']}',
                        style: GoogleFonts.urbanist(
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  // Date & Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        alert['dateTime']!,
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.grey[800],
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Alert Type
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          // color: getAlertColor(alert['alertType']!),
                          gradient: SweepGradient(
                            colors: [
                              getAlertColor(alert['alertType']!),
                              getAlertColor(
                                alert['alertType']!,
                              ).withOpacity(0.5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          alert['alertType']!,
                          style: GoogleFonts.urbanist(
                            color: isDark ? tBlack : tWhite,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
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
