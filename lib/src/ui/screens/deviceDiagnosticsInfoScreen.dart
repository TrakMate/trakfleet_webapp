import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../utils/appColors.dart';
import '../../utils/appResponsive.dart';
import '../widgets/charts/speedChart.dart';
import '../widgets/charts/vehicleVoltageChart.dart';

class DeviceDiagnosticsInfoScreen extends StatefulWidget {
  final Map<String, dynamic> device;
  const DeviceDiagnosticsInfoScreen({super.key, required this.device});

  @override
  State<DeviceDiagnosticsInfoScreen> createState() =>
      _DeviceDiagnosticsInfoScreenState();
}

class _DeviceDiagnosticsInfoScreenState
    extends State<DeviceDiagnosticsInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveLayout(
      mobile: const Center(child: Text("Mobile / Tablet layout coming soon")),
      tablet: const Center(child: Text("Mobile / Tablet layout coming soon")),
      desktop: _buildDesktopLayout(context, isDark),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isDark) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 4, child: _buildDiagnosticsCards(isDark)),
              const SizedBox(width: 10),
              Expanded(flex: 7, child: _buildDiagnosticsTableGraphs(isDark)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosticsCards(bool isDark) {
    final device = widget.device;

    // Define color gradients for each metric
    final gradients = {
      "Vehicle Voltage": [tBlue, tBlueSky],
      "Speed": [tGreen, tGreenDark],
      "Odometer": [Colors.cyan, Colors.cyanAccent],
      "RPM": [tOrange1, Colors.orangeAccent],
      "SOS": [tRedDark, Colors.redAccent],
      "Temperature": [Colors.amber, Colors.deepOrange],
      "Fuel Level": [Colors.green, Colors.lightGreen],
      "PTO": [Colors.indigo, Colors.blueAccent],
      "Ignition": [Colors.pink, Colors.pinkAccent],
    };

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Device Info",
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? tWhite : tBlack,
            ),
          ),
          const SizedBox(height: 5),

          /// Device card
          buildDeviceCard(
            isDark: isDark,
            imei: device['imei'],
            vehicleNumber: device['vehicleNumber'],
            status: device['status'],
            fuel: device['fuel'],
            odo: device['odo'],
            trips: device['trips'],
            alerts: device['alerts'],
            location: device['location'],
          ),

          const SizedBox(height: 15),

          /// Diagnostic cards grid
          GridView.count(
            crossAxisCount: 2, // two cards per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true, // so it doesn't take infinite height
            physics:
                const NeverScrollableScrollPhysics(), // disable scrolling inside column
            childAspectRatio: 2, // adjust to control card height/width balance
            children: [
              _buildInfoCard(
                isDark,
                "Vehicle Voltage (V)",
                "45",
                gradients["Vehicle Voltage"]!,
              ),
              _buildInfoCard(isDark, "Speed (km/h)", "85", gradients["Speed"]!),
              _buildInfoCard(
                isDark,
                "Odometer (km)",
                "${device['odo']}",
                gradients["Odometer"]!,
              ),
              _buildInfoCard(isDark, "RPM", "4500", gradients["RPM"]!),
              _buildInfoCard(
                isDark,
                "SOS",
                device['sos'] == "1" ? "Active" : "Inactive",
                gradients["SOS"]!,
              ),
              _buildInfoCard(
                isDark,
                "Temperature (°C)",
                "125",
                gradients["Temperature"]!,
              ),
              _buildInfoCard(
                isDark,
                "Fuel Level (%)",
                "65",
                gradients["Fuel Level"]!,
              ),
              _buildInfoCard(
                isDark,
                "PTO",
                device['pto'] == "1" ? "ON" : "OFF",
                gradients["PTO"]!,
              ),
              _buildInfoCard(
                isDark,
                "Ignition",
                device['ignition'] == "1" ? "ON" : "OFF",
                gradients["Ignition"]!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    bool isDark,
    String title,
    String value,
    List<Color> gradientColors,
  ) {
    return Container(
      width: double.infinity, // fits 2 per row
      decoration: const BoxDecoration(color: tTransparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? tBlack : tWhite,
              border: Border.all(width: 0.5, color: isDark ? tWhite : tBlack),
            ),
            child: Text(
              title,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: isDark ? tWhite : tBlack,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          /// Gradient Value Box
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
            ),
            alignment: Alignment.center,
            child: Text(
              value,
              style: GoogleFonts.urbanist(
                fontSize: 38,
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
      decoration: BoxDecoration(
        color: tTransparent,
        border: Border.all(
          color: isDark ? tWhite.withOpacity(0.4) : tBlack.withOpacity(0.4),
          width: 0.4,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMEI + Vehicle + Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns status on top
            children: [
              /// IMEI + Vehicle box (fixed width)
              Container(
                width: 250, // fixed width (adjust as you like)
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
                        // color: statusColor,
                        gradient: SweepGradient(
                          colors: [statusColor, statusColor.withOpacity(0.6)],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        imei,
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
                        'VEHICLE  - $vehicleNumber',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? tWhite : tBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),

              /// 🔹 Status container (top-aligned)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  // color: statusColor,
                  gradient: SweepGradient(
                    colors: [statusColor, statusColor.withOpacity(0.6)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? tBlack : tWhite,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Divider(
            color: isDark ? tWhite.withOpacity(0.4) : tBlack.withOpacity(0.4),
            thickness: 0.3,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SvgPicture.asset(
                'icons/geofence.svg',
                width: 16,
                height: 16,
                color: tGreen,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Live Location : $location',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: isDark ? tWhite : tBlack,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticsTableGraphs(bool isDark) {
    String selectedTab = "Statistics"; // ✅ Declare outside the builder

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────── TAB BUTTONS ───────────────
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        isDark
                            ? tWhite.withOpacity(0.3)
                            : tBlack.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildTabButton("Statistics", selectedTab, isDark, () {
                    setState(() => selectedTab = "Statistics");
                  }),
                  const SizedBox(width: 5),
                  _buildTabButton("CAN Data", selectedTab, isDark, () {
                    setState(() => selectedTab = "CAN Data");
                  }),
                ],
              ),
            ),

            // const SizedBox(height: 10),
            if (selectedTab == "Statistics") ...[
              Expanded(child: _buildStatsGraphsAndBars(isDark)),
            ] else ...[
              _buildCanDataTables(isDark),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStatsGraphsAndBars(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? tWhite : tBlack,
                      width: 0.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Vehicle Voltage (V)",
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? tWhite : tBlack,
                        ),
                      ),
                      const SizedBox(height: 5),
                      VehicleVoltageChart(
                        isDark: isDark,
                        voltageData: [12.5, 12.7, 13.2, 13.8, 14.0, 13.5, 13.1],
                        timeLabels: [
                          '10:00',
                          '10:05',
                          '10:10',
                          '10:15',
                          '10:20',
                          '10:25',
                          '10:30',
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem(tBlue, "Vehicle Voltage", isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? tWhite : tBlack,
                      width: 0.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Speed (Km/h)",
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? tWhite : tBlack,
                        ),
                      ),
                      const SizedBox(height: 5),
                      VehicleSpeedChart(
                        isDark: isDark,
                        speedData: [40, 45, 60, 72, 68, 70, 65],
                        timeLabels: [
                          '10:00',
                          '10:05',
                          '10:10',
                          '10:15',
                          '10:20',
                          '10:25',
                          '10:30',
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [_buildLegendItem(tGreen, "Speed", isDark)],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          buildStatusBars(isDark),
        ],
      ),
    );
  }

  Widget _buildCanDataTables(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? tWhite.withOpacity(0.3) : tBlack.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CAN Data Tables",
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? tWhite : tBlack,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "This section will show detailed CAN Bus data (RPM, Fuel Level, Engine Temp, etc.)",
            style: GoogleFonts.urbanist(
              fontSize: 11,
              color: isDark ? tWhite.withOpacity(0.8) : tBlack.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    String label,
    String selectedTab,
    bool isDark,
    VoidCallback onTap,
  ) {
    final bool isSelected = selectedTab == label;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? tBlue.withOpacity(0.15) : Colors.transparent,
          // borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color:
                isSelected
                    ? tBlue
                    : (isDark
                        ? tWhite.withOpacity(0.3)
                        : tBlack.withOpacity(0.3)),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color:
                isDark
                    ? (isSelected ? tBlue : tWhite.withOpacity(0.7))
                    : (isSelected ? tBlue : tBlack.withOpacity(0.7)),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
            fontWeight: FontWeight.w600,
            color: isDark ? tWhite : tBlack,
          ),
        ),
      ],
    );
  }

  Widget buildStatusBars(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBar(
          title: "Ignition Status (Last 24 Hours)",
          history: [
            1,
            1,
            0,
            0,
            1,
            1,
            1,
            0,
            0,
            1,
            1,
            1,
            0,
            0,
            0,
            1,
            1,
            1,
            0,
            0,
            1,
            0,
            0,
            1,
          ],
          onColor: tGreen,
          offColor: tRed,
          isDark: isDark,
        ),
        const SizedBox(height: 15),
        _buildStatusBar(
          title: "SOS Status (Last 24 Hours)",
          history: [
            0, 0, 1, 1, 0, 0, 1, 0, 0, 1, // last 10
            1, 0, 0, 0, 1, 0, 0, 1, 1, 0, // 10 older
            1, 0, 0, 1, // oldest 4
          ],
          onColor: tGreen,
          offColor: tRed,
          isDark: isDark,
        ),
        const SizedBox(height: 15),
        _buildStatusBar(
          title: "PTO Status (Last 24 Hours)",
          history: [
            1,
            1,
            1,
            0,
            0,
            0,
            1,
            0,
            1,
            1,
            0,
            0,
            1,
            1,
            1,
            0,
            0,
            1,
            0,
            0,
            1,
            1,
            0,
            0,
          ],
          onColor: tGreen,
          offColor: tRed,
          isDark: isDark,
        ),
        const SizedBox(height: 15),
        _buildStatusBar(
          title: "4 Wheel Drive (Last 24 Hours)",
          history: [
            0,
            0,
            0,
            0,
            1,
            1,
            1,
            1,
            0,
            0,
            0,
            0,
            1,
            1,
            1,
            0,
            0,
            0,
            1,
            1,
            0,
            0,
            0,
            0,
          ],
          onColor: tGreen,
          offColor: tRed,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildStatusBar({
    required String title,
    required List<int> history,
    required Color onColor,
    required Color offColor,
    required bool isDark,
  }) {
    // Count totals
    final Map<String, double> data = {
      "ON": history.where((v) => v == 1).length.toDouble(),
      "OFF": history.where((v) => v == 0).length.toDouble(),
    };

    final Map<String, Color> borderColors = {"ON": onColor, "OFF": offColor};

    final Map<String, Color> fillColors = {
      "ON": onColor.withOpacity(0.2),
      "OFF": offColor.withOpacity(0.2),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? tWhite : tBlack,
          ),
        ),
        const SizedBox(height: 6),

        _buildAnimatedAlertsBar(data, borderColors, fillColors, isDark),

        const SizedBox(height: 6),

        // Hour labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(24, (i) {
            final now = DateTime.now();
            final hour = now.subtract(Duration(hours: 23 - i));
            return Text(
              "${hour.hour.toString().padLeft(2, '0')}:00",
              style: GoogleFonts.urbanist(
                fontSize: 8,
                color:
                    isDark ? tWhite.withOpacity(0.7) : tBlack.withOpacity(0.7),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget buildIgnitionStatusBar(bool isDark) {
    // Example ignition data for the past 24 hours (latest first)
    final List<int> ignitionHistory = [
      1, 1, 0, 0, 1, 1, 1, 0, 0, 1, // last 10 hours
      1, 1, 0, 0, 0, 1, 1, 1, 0, 0, // older 10
      1, 0, 0, 1, // 4 oldest
    ];

    // Count how many hours ignition was ON or OFF
    final Map<String, double> ignitionData = {
      "ON": ignitionHistory.where((v) => v == 1).length.toDouble(),
      "OFF": ignitionHistory.where((v) => v == 0).length.toDouble(),
    };

    // Base solid colors (for border)
    final Map<String, Color> ignitionBorderColors = {"ON": tGreen, "OFF": tRed};

    // Light fill colors (for background)
    final Map<String, Color> ignitionFillColors = {
      "ON": tGreen.withOpacity(0.2),
      "OFF": tRed.withOpacity(0.2),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ignition Status (Last 24 Hours)",
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? tWhite : tBlack,
          ),
        ),
        const SizedBox(height: 6),

        // Bar visualization
        _buildAnimatedAlertsBar(
          ignitionData,
          ignitionBorderColors,
          ignitionFillColors,
          isDark,
        ),

        const SizedBox(height: 6),

        // Hour markers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(24, (i) {
            final now = DateTime.now();
            final hour = now.subtract(Duration(hours: 23 - i));
            return Text(
              "${hour.hour.toString().padLeft(2, '0')}:00",
              style: GoogleFonts.urbanist(
                fontSize: 8,
                color:
                    isDark ? tWhite.withOpacity(0.7) : tBlack.withOpacity(0.7),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAnimatedAlertsBar(
    Map<String, double> data,
    Map<String, Color> borderColors,
    Map<String, Color> fillColors,
    bool isDark,
  ) {
    double total = data.values.fold(0, (a, b) => a + b);

    return Container(
      width: double.infinity,
      height: 35,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:
            data.entries.map((entry) {
              double percentage = entry.value / total;

              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: percentage),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Expanded(
                    flex: (value * 1000).toInt().clamp(1, 1000),
                    child: Container(
                      decoration: BoxDecoration(
                        color: fillColors[entry.key] ?? tGrey.withOpacity(0.2),
                        border: Border.all(
                          color: borderColors[entry.key] ?? tGrey,
                          width: 1.5,
                        ),
                      ),
                      child: Tooltip(
                        message:
                            "${entry.key}: ${(entry.value).toStringAsFixed(1)} hrs",
                        child: const SizedBox.expand(),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}
