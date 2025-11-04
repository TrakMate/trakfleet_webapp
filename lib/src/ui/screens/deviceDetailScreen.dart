import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';
import 'package:tm_fleet_management/src/ui/screens/can_data_screen.dart';
import 'package:tm_fleet_management/src/ui/screens/devicesScreen.dart';
import 'package:tm_fleet_management/src/utils/appResponsive.dart';
import '../../utils/appColors.dart';

class DeviceDetailScreen extends StatefulWidget {
  const DeviceDetailScreen({super.key});

  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  String? selectedGroup = "BAXY General Team";
  DateTime selectedDate = DateTime.now();

  final List<String> groups = [
    "BAXY General Team",
    "IoT Development",
    "Firmware QA",
    "BLE Integration",
    "Manufacturing Team",
  ];
  final int totaltrips = 5075;

  final List<Map<String, dynamic>> baseStatuses = [
    {'label': 'Moving', 'color': tBlue, 'percent': 25.0},
    {'label': 'Stopped', 'color': tGreen, 'percent': 45.0},
    {'label': 'Idle', 'color': tOrange1, 'percent': 35.0},
    {'label': 'Disconnected', 'color': tRedDark, 'percent': 20.0},
  ];

  List<Map<String, dynamic>> _getStatusWithCounts() {
    final total = totaltrips;
    final sumPercent = baseStatuses.fold<double>(
      0,
      (sum, s) => sum + (s['percent'] as double),
    );

    return baseStatuses.map((status) {
      final normalizedPercent =
          (status['percent'] as double) / sumPercent * 100;
      final count = (total * (normalizedPercent / 100)).round();
      return {...status, 'percent': normalizedPercent, 'count': count};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  // Widget _buildMobileLayout() {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;
  //   return Padding(
  //     padding: const EdgeInsets.all(10),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMobileLayout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title Row (with CAN, Battery boxes, and device icon)
          _buildTitle(context, isDark),
          const SizedBox(height: 15),

          // 🔹 Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 🔸 Vehicle Summary
                  Container(
                    width: double.infinity,
                    height: 210,
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
                      children: [
                        _buildVehicleHeaderSection(isDark),
                        const SizedBox(height: 5),
                        Divider(
                          color:
                              isDark
                                  ? tWhite.withOpacity(0.6)
                                  : tBlack.withOpacity(0.6),
                          thickness: 0.6,
                        ),
                        const SizedBox(height: 5),
                        _buildVehicleBottomSection(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🔸 Vehicle Status Progress
                  Container(
                    width: double.infinity,
                    height: 210,
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
                        Text(
                          'Vehicle Status',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: isDark ? tWhite : tBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildMobileDynamicStatusBar(_getStatusWithCounts()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🔸 Alerts Section (newly added for mobile)
                  Container(
                    width: double.infinity,
                    height: 150,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Alerts',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: isDark ? tWhite : tBlack,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '575',
                              style: GoogleFonts.urbanist(
                                fontSize: 32,
                                color: isDark ? tWhite : tBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        _buildIconCircle('icons/alerts.svg', tRedDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() => Container();

  @override
  Widget _buildDesktopLayout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildTitle(context, isDark)],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Left Vehicle Summary
            Expanded(
              child: Container(
                width: double.infinity,
                height: 210,
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
                  children: [
                    _buildVehicleHeaderSection(isDark),
                    const SizedBox(height: 5),
                    Divider(
                      color:
                          isDark
                              ? tWhite.withOpacity(0.6)
                              : tBlack.withOpacity(0.6),
                      thickness: 0.6,
                    ),
                    const SizedBox(height: 5),
                    _buildVehicleBottomSection(),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Right Vehicle Status Progress
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 210,
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
                  Text(
                    'Vehicle Status',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: isDark ? tWhite : tBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: _buildDynamicStatusBar(_getStatusWithCounts()),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Container(
                width: double.infinity,
                height: 210,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                        ),
                        _buildIconCircle('icons/alerts.svg', tRedDark),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle(context, isDark) {
    // final isMobile = MediaQuery.of(context).size.width < 600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ push icon to right
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Device Summary',
              style: GoogleFonts.urbanist(
                fontSize: 20,
                color: isDark ? tWhite : tBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),

            // CAN Data Box (Clickable)
            GestureDetector(
              onTap: () {
                // ✅ Navigate using GoRouter if using named routes
                // context.go('/home/devices/device_detail/can_data');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CanDataScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isDark ? tWhite : tBlack, width: 1),
                  color: isDark ? tTransparent : tWhite,
                ),
                child: Text(
                  'CAN Data',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? tWhite : tBlack,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Battery Details Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isDark ? tWhite : tBlack, width: 1),
                color: isDark ? tTransparent : tWhite,
              ),
              child: Text(
                'Battery Details',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? tWhite : tBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        // ✅ Device Icon on Right Corner
        GestureDetector(
          onTap: () {
            // ✅ Use GoRouter if available
            // context.go('/home/devices');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DevicesScreen()),
            );
          },
          child: SvgPicture.asset(
            'icons/device.svg', // <-- your device SVG icon path
            width: 26,
            height: 26,
            color: isDark ? tWhite : tBlack,
          ),
        ),
      ],
    );
  }

  // Widget _buildDynamicDropdown(bool isDark) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8),
  //     decoration: BoxDecoration(
  //       color: tTransparent,
  //       border: Border.all(width: 0.6, color: isDark ? tWhite : tBlack),
  //     ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton2<String>(
  //         isExpanded: false,
  //         hint: Text(
  //           'Select Group',
  //           style: GoogleFonts.urbanist(fontSize: 12.5, color: tGrey),
  //         ),
  //         items:
  //             groups
  //                 .map(
  //                   (group) => DropdownMenuItem<String>(
  //                     value: group,
  //                     child: Text(
  //                       group,
  //                       style: GoogleFonts.urbanist(
  //                         fontSize: 12.5,
  //                         color: isDark ? tWhite : tBlack,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //                 .toList(),
  //         value: selectedGroup,
  //         onChanged: (value) => setState(() => selectedGroup = value),
  //         iconStyleData: IconStyleData(
  //           icon: Icon(
  //             CupertinoIcons.chevron_down,
  //             size: 16,
  //             color: isDark ? tWhite : tBlack,
  //           ),
  //         ),
  //         dropdownStyleData: DropdownStyleData(
  //           padding: EdgeInsets.zero,
  //           maxHeight: 200,
  //           decoration: BoxDecoration(
  //             color: isDark ? tBlack : tWhite,
  //             boxShadow: [
  //               BoxShadow(
  //                 spreadRadius: 2,
  //                 blurRadius: 10,
  //                 color:
  //                     isDark
  //                         ? tWhite.withOpacity(0.25)
  //                         : tBlack.withOpacity(0.15),
  //               ),
  //             ],
  //           ),
  //         ),
  //         buttonStyleData: const ButtonStyleData(
  //           padding: EdgeInsets.zero,
  //           height: 30,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDynamicDatePicker(bool isDark) {
  //   return GestureDetector(
  //     onTap: _selectDate,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //       decoration: BoxDecoration(
  //         color: tTransparent,
  //         border: Border.all(width: 0.6, color: isDark ? tWhite : tBlack),
  //       ),
  //       child: Text(
  //         DateFormat('dd MMM yyyy').format(selectedDate).toUpperCase(),
  //         style: GoogleFonts.urbanist(
  //           fontSize: 12.5,
  //           color: isDark ? tWhite : tBlack,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> _selectDate() async {
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(2030),
  //     builder:
  //         (context, child) => Theme(
  //           data: Theme.of(context).copyWith(
  //             colorScheme: const ColorScheme.light(
  //               primary: Colors.blueAccent,
  //               onPrimary: Colors.white,
  //               onSurface: Colors.black,
  //             ),
  //           ),
  //           child: child!,
  //         ),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() => selectedDate = picked);
  //   }
  // }

  Widget _buildVehicleHeaderSection(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTotalTripsInfo(isDark),
        _buildIconCircle('icons/trip.svg', tBlue),
      ],
    );
  }

  Widget _buildTotalTripsInfo(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Trips',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Text(
              '$totaltrips',
              style: GoogleFonts.urbanist(
                fontSize: 35,
                color: isDark ? tWhite : tBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
            Positioned(
              right: -60,
              bottom: 8,
              child: Row(
                children: [
                  Text(
                    '3.48%',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: tGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    decoration: BoxDecoration(
                      color: tGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 2,
                    ),
                    child: Icon(
                      Icons.arrow_upward_outlined,
                      size: 14,
                      color: tGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleBottomSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildVehicleStatusColumn(
          iconPath: 'icons/odometer.svg',
          iconColor: tGreen,
          title: 'ODO ',
          value: '9000',
        ),
        _buildVehicleStatusColumn(
          iconPath: 'icons/speed.svg',
          iconColor: tOrange1,
          title: 'Avg speed',
          value: '45',
        ),
        _buildVehicleStatusColumn(
          iconPath: 'icons/sun.svg',
          iconColor: tOrange1,
          title: 'Duration ',
          value: '45 mins',
        ),
        _buildVehicleStatusColumn(
          iconPath: 'icons/tracking.svg',
          iconColor: tBlueSky,
          title: 'live location',
          value: '123 BTM layout, Bangalore',
        ),
      ],
    );
  }

  Widget _buildVehicleStatusColumn({
    required String iconPath,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(iconPath, width: 25, height: 25, color: iconColor),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildIconCircle(String iconPath, Color color) => Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: color.withOpacity(0.25),
      shape: BoxShape.circle,
    ),
    padding: const EdgeInsets.all(15),
    child: SvgPicture.asset(iconPath, width: 30, height: 30, color: color),
  );

  Widget _buildDynamicStatusBar(List<Map<String, dynamic>> statuses) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = totaltrips;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        double currentStart = 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======= LABELS ALIGNED TO BAR SEGMENTS =======
            SizedBox(
              height: 100, // enough vertical room for 2 label lines
              width: totalWidth,
              child: Stack(
                children:
                    statuses.asMap().entries.map((entry) {
                      final status = entry.value;

                      final count = status['count'] as int;
                      final color = status['color'] as Color;
                      final label = status['label'] as String;
                      final percent = status['percent'] as double;
                      final fraction = total > 0 ? count / total : 0.0;
                      final startX = currentStart;
                      currentStart += fraction;

                      // --- Calculate label width & overflow guard ---
                      const estimatedLabelWidth =
                          100.0; // rough label width estimate
                      double leftPos = totalWidth * startX;
                      if (leftPos + estimatedLabelWidth > totalWidth) {
                        // shift inside container
                        leftPos = totalWidth - estimatedLabelWidth - 5;
                      }

                      return Positioned(
                        left: leftPos,
                        top: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(height: 25, width: 4, color: color),
                                const SizedBox(width: 6),
                                Text(
                                  label,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    color: isDark ? tWhite : tBlack,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${percent.toStringAsFixed(1)}%',
                              style: GoogleFonts.urbanist(
                                fontSize: 20,
                                color: isDark ? tWhite : tBlack,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '$count',
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: isDark ? tWhite : tBlack,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // ======= PROGRESS BAR =======
            Stack(
              children: [
                // background
                Container(
                  width: totalWidth,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color:
                        isDark
                            ? tWhite.withOpacity(0.1)
                            : tBlack.withOpacity(0.05),
                  ),
                ),

                // colored segments
                Row(
                  children:
                      statuses.map((status) {
                        final count = status['count'] as int;
                        final color = status['color'] as Color;
                        final fraction = total > 0 ? count / total : 0.0;
                        return Container(
                          width: totalWidth * fraction,
                          height: 25,
                          color: color,
                        );
                      }).toList(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMobileDynamicStatusBar(List<Map<String, dynamic>> statuses) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = totaltrips;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        double currentStart = 0.0;

        return SizedBox(
          width: totalWidth,
          height: 120, // enough space for top/bottom labels + bar + connector
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ======= PROGRESS BAR BACKGROUND =======
              Positioned(
                top: 50,
                child: Container(
                  width: totalWidth,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color:
                        isDark
                            ? tWhite.withOpacity(0.1)
                            : tBlack.withOpacity(0.05),
                  ),
                ),
              ),

              // ======= PROGRESS BAR SEGMENTS =======
              Positioned(
                top: 50,
                child: Row(
                  children:
                      statuses.map((status) {
                        final count = status['count'] as int;
                        final color = status['color'] as Color;
                        final fraction = total > 0 ? count / total : 0.0;
                        final segmentWidth = totalWidth * fraction;

                        return Container(
                          width: segmentWidth,
                          height: 25,
                          color: color,
                        );
                      }).toList(),
                ),
              ),

              // ======= LABELS AND CONNECTOR LINES =======
              ...statuses.map((status) {
                final index = statuses.indexOf(status);

                final count = status['count'] as int;
                final color = status['color'] as Color;
                final label = status['label'] as String;
                final percent = status['percent'] as double;
                final fraction = total > 0 ? count / total : 0.0;

                final segmentStart = currentStart;
                final segmentEnd = currentStart + fraction;
                final segmentCenter =
                    segmentStart + fraction / 2; // center of segment
                currentStart = segmentEnd;

                // Determine if label is top or bottom
                final isTop = index % 2 == 0;

                // Horizontal position: label centered over segment
                const estimatedLabelWidth = 100.0;
                double leftPos =
                    totalWidth * segmentCenter - estimatedLabelWidth / 2;

                // Clamp to container edges
                if (leftPos < 0) leftPos = 0;
                if (leftPos + estimatedLabelWidth > totalWidth) {
                  leftPos = totalWidth - estimatedLabelWidth - 5;
                }

                // Vertical positions
                final barTop = 50.0;
                final barHeight = 25.0;
                final verticalOffset = isTop ? 0.0 : barTop + barHeight + 10;

                // Connector line: always from segment end
                final lineX = totalWidth * segmentEnd;
                final lineTop =
                    isTop ? verticalOffset + 30 : barTop + barHeight;
                final lineHeight =
                    isTop
                        ? barTop - (verticalOffset + 30)
                        : verticalOffset - (barTop + barHeight);

                return Stack(
                  children: [
                    // Vertical connector line
                    Positioned(
                      left: lineX - 1, // center 2px line
                      top: isTop ? lineTop : barTop + barHeight,
                      child: Container(
                        width: 2,
                        height: lineHeight.abs(),
                        color: color,
                      ),
                    ),

                    // Label + percentage
                    Positioned(
                      left: leftPos,
                      top: verticalOffset,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(height: 14, width: 3, color: color),
                              const SizedBox(width: 6),
                              Text(
                                label,
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  color: isDark ? tWhite : tBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${percent.toStringAsFixed(1)}% ($count)',
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color:
                                  isDark
                                      ? tWhite.withOpacity(0.7)
                                      : tBlack.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
