import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../utils/appColors.dart';
import '../../utils/appResponsive.dart';
import '../widgets/charts/doughnutChart.dart';
import '../widgets/charts/fuelChart.dart';
import '../widgets/charts/odometerChart.dart';
import '../widgets/charts/rpmChart.dart';
import '../widgets/charts/speedChart.dart';
import '../widgets/charts/temperatureChart.dart';
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
  String selectedTab = "Statistics";
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
    final device = widget.device;
    return Column(
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
            onTabChanged: (tab) {
              setState(() => selectedTab = tab);
            },
            selectedTab: selectedTab,
          ),
        ),

        // ===== Dynamic Body Section =====
        if (selectedTab == "Statistics")
          _buildDiagnosticsCards(isDark)
        else
          _buildCanDataTables(isDark),
      ],
    );
  }

  Widget _buildDiagnosticsCards(bool isDark) {
    final device = widget.device;

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            title: "Fuel",
                            unit: "%",
                            primaryColor: tGreen,
                            isDark: isDark,
                          ),
                          SingleDoughnutChart(
                            currentValue: 3500,
                            avgValue: 2500,
                            title: "RPM",
                            unit: "rpm",
                            primaryColor: tBlueSky,
                            isDark: isDark,
                          ),
                          SingleDoughnutChart(
                            currentValue: 320,
                            avgValue: 280,
                            title: 'Torque',
                            unit: 'Nm',
                            primaryColor: tPink2,
                            isDark: true,
                          ),
                          SingleDoughnutChart(
                            currentValue: 64,
                            avgValue: 50,
                            title: "Temperature",
                            unit: "°C",
                            primaryColor: tOrange1,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),

                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildInfoCard(
                                isDark,
                                "Speed (km/h)",
                                "85",
                                tGreenGradient,
                              ),
                              const SizedBox(height: 20),

                              _buildInfoCard(
                                isDark,
                                "Odometer (km)",
                                "45272",
                                tBlueGradient1,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoCard(
                                      isDark,
                                      "SOS",
                                      device['sos'] == "1" ? "ON" : "OFF",
                                      device['sos'] == "1"
                                          ? tGreenGradient1
                                          : tRedGradient3,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _buildInfoCard(
                                      isDark,
                                      "PTO",
                                      device['pto'] == "1" ? "ON" : "OFF",
                                      device['pto'] == "1"
                                          ? tGreenGradient1
                                          : tRedGradient3,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _buildInfoCard(
                                      isDark,
                                      "AdBlue (L)",
                                      '45',
                                      tBlueGradient2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoCard(
                                      isDark,
                                      "Ignition",
                                      'ON',
                                      tGreenGradient2,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _buildInfoCard(
                                      isDark,
                                      "4 Wheel Drive",
                                      device['4 Wheel Drive'] == "1"
                                          ? "ON"
                                          : "OFF",
                                      device['4 Wheel Drive'] == "1"
                                          ? tGreenGradient1
                                          : tRedGradient3,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _buildInfoCard(
                                      isDark,
                                      "Immobilize",
                                      device['Immobilize'] == "1"
                                          ? "ON"
                                          : "OFF",
                                      device['Immobilize'] == "1"
                                          ? tGreenGradient1
                                          : tRedGradient3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildStatsGraphsAndBars(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    bool isDark,
    String title,
    String value,
    Gradient cardGradient,
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
            padding: const EdgeInsets.symmetric(vertical: 5),
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
            height: 75,
            width: double.infinity,
            decoration: BoxDecoration(gradient: cardGradient),
            alignment: Alignment.center,
            child: Text(
              value,
              style: GoogleFonts.urbanist(
                fontSize: 35,
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
    required Function(String) onTabChanged,
    required String selectedTab,
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
        color: isDark ? tBlack : tWhite,
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            color: isDark ? tWhite.withOpacity(0.25) : tBlack.withOpacity(0.15),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SvgPicture.asset('icons/struck1.svg', width: 80, height: 80),
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
                          Container(
                            width: 350,
                            // constraints: const BoxConstraints(
                            //   minWidth: 200,
                            //   maxWidth: 400,
                            // ),
                            decoration: BoxDecoration(
                              border: Border.all(color: statusColor, width: 1),
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

                    // ==== Right Side (Tabs) ====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildTabButton("Statistics", selectedTab, isDark, () {
                          onTabChanged("Statistics");
                        }),
                        const SizedBox(width: 5),
                        _buildTabButton("CAN Data", selectedTab, isDark, () {
                          onTabChanged("CAN Data");
                        }),
                      ],
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

  Widget _buildStatsGraphsAndBars(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                height: 250,
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
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Vehicle Voltage (V)",
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                        _buildLegendItem(tBlue, "Vehicle Voltage", isDark),
                      ],
                    ),

                    const SizedBox(height: 10),
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
                  ],
                ),
              ),
            ),

            const SizedBox(width: 20),
            Expanded(
              flex: 5,
              child: Container(
                height: 250,
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
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Speed (Km/h)",
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                        _buildLegendItem(tGreen, "Speed", isDark),
                      ],
                    ),

                    const SizedBox(height: 10),
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
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 5,
              child: Container(
                height: 250,
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
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Odometer (km)",
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                        _buildLegendItem(tBlueSky, "Odometer", isDark),
                      ],
                    ),

                    const SizedBox(height: 10),
                    OdometerChart(
                      odometerData: [10200, 10205, 10215, 10225, 10240, 10255],
                      timeLabels: [
                        '10:00',
                        '10:10',
                        '10:20',
                        '10:30',
                        '10:40',
                        '10:50',
                      ],
                      isDark: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                height: 250,
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
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "RPM",
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                        _buildLegendItem(tOrange1, "RPM", isDark),
                      ],
                    ),

                    const SizedBox(height: 10),
                    RpmChart(
                      rpmData: [800, 1500, 2500, 3000, 2800, 3200, 4000, 3500],
                      timeLabels: [
                        '10:00',
                        '10:01',
                        '10:02',
                        '10:03',
                        '10:04',
                        '10:05',
                        '10:06',
                        '10:07',
                      ],
                      isDark: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 5,
              child: Container(
                height: 250,
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
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Fuel (%)",
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                        _buildLegendItem(tGreenDark, "Fuel", isDark),
                      ],
                    ),

                    const SizedBox(height: 10),
                    FuelChart(
                      fuelData: [100, 95, 90, 85, 80, 75, 70, 65],
                      timeLabels: [
                        '10:00',
                        '10:01',
                        '10:02',
                        '10:03',
                        '10:04',
                        '10:05',
                        '10:06',
                        '10:07',
                      ],
                      isDark: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 5,
              child: Container(
                height: 250,
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
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Temperature (°C)",
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                        _buildLegendItem(tRed, "Temperature", isDark),
                      ],
                    ),

                    const SizedBox(height: 10),
                    VehicleTemperatureChart(
                      temperatureData: [72, 75, 78, 82, 85, 88, 90, 93],
                      timeLabels: [
                        '10:00',
                        '10:01',
                        '10:02',
                        '10:03',
                        '10:04',
                        '10:05',
                        '10:06',
                        '10:07',
                      ],
                      isDark: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        buildStatusBars(isDark),
      ],
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
          // color: isSelected ? tBlue.withOpacity(0.15) : Colors.transparent,
          gradient:
              isSelected
                  ? SweepGradient(colors: [tBlue, tBlue.withOpacity(0.6)])
                  : SweepGradient(colors: [tTransparent, tTransparent]),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color:
                isSelected
                    ? tTransparent
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
                    ? (isSelected ? tWhite : tWhite.withOpacity(0.7))
                    : (isSelected ? tWhite : tBlack.withOpacity(0.7)),
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
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
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
