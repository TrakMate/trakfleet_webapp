import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../utils/appColors.dart';
import '../../utils/appResponsive.dart';
import '../widgets/charts/tripsChart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedGroup = "BAXY General Team";
  DateTime selectedDate = DateTime.now();

  final List<String> groups = [
    "BAXY General Team",
    "IoT Development",
    "Firmware QA",
    "BLE Integration",
    "Manufacturing Team",
  ];
  final int totalVehicles = 5075;

  final List<Map<String, dynamic>> baseStatuses = [
    {'label': 'Moving', 'color': tGreen, 'percent': 22.0},
    {'label': 'Stopped', 'color': tRed, 'percent': 40.0},
    {'label': 'Idle', 'color': tOrange1, 'percent': 30.0},
    {'label': 'Disconnected', 'color': tGrey, 'percent': 20.0},
    {'label': 'Non-Coverage', 'color': Colors.purple, 'percent': 20.0},
  ];

  List<Map<String, dynamic>> _getStatusWithCounts() {
    final total = totalVehicles;
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

  Widget _buildMobileLayout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(isDark),
          const SizedBox(height: 15),
          _buildGroupSelector(isDark),
          const SizedBox(height: 6),
          _buildDateSelector(isDark),
          const SizedBox(height: 15),

          // Scrollable content (no Expanded inside)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Left Vehicle Summary
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

                  // Right Vehicle Status Progress
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
                  SizedBox(height: 15),
                  // Alerts Summary
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
                        _buildAlertsHeaderSection(isDark),
                        const SizedBox(height: 5),
                        Divider(
                          color:
                              isDark
                                  ? tWhite.withOpacity(0.6)
                                  : tBlack.withOpacity(0.6),
                          thickness: 0.6,
                        ),
                        const SizedBox(height: 5),
                        _buildAlertsBottomSection(),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 250,
                    width: double.infinity,
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
                    child: SingleChildScrollView(
                      child: buildAlertsWidget(isDark: isDark),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 325,
                    width: double.infinity,
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
                    padding: const EdgeInsets.all(2),
                    child: buildVehicleMap(isDark: isDark, zoom: 14),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: double.infinity,
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
                        _buildTripsHeaderSection(isDark),
                        const SizedBox(height: 5),
                        Divider(
                          color:
                              isDark
                                  ? tWhite.withOpacity(0.6)
                                  : tBlack.withOpacity(0.6),
                          thickness: 0.6,
                        ),
                        const SizedBox(height: 5),
                        _buildTripsBottomSection(),
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

  Widget _buildTabletLayout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitle(isDark),
              Row(
                children: [
                  _buildGroupSelector(isDark),
                  const SizedBox(width: 10),
                  _buildDateSelector(isDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Left Vehicle Summary
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
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
              const SizedBox(width: 10),

              // Right Vehicle Status Progress
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
                        child: _buildMobileDynamicStatusBar(
                          _getStatusWithCounts(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 325,
            width: double.infinity,
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
            padding: const EdgeInsets.all(5),
            child: buildVehicleMap(isDark: isDark, zoom: 14),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
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
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAlertsHeaderSection(isDark),
                    const SizedBox(height: 5),
                    Divider(
                      color:
                          isDark
                              ? tWhite.withOpacity(0.6)
                              : tBlack.withOpacity(0.6),
                      thickness: 0.6,
                    ),
                    const SizedBox(height: 5),
                    _buildAlertsBottomSection(),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 225,
                  width: double.infinity,
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
                  child: SingleChildScrollView(
                    child: buildAlertsWidget(isDark: isDark),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitle(isDark),
            Row(
              children: [
                _buildGroupSelector(isDark),
                const SizedBox(width: 10),
                _buildDateSelector(isDark),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    // Left Vehicle Summary
                    Expanded(
                      flex: 3,
                      child: Container(
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
                    Expanded(
                      flex: 7,
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.5,
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
                              child: _buildDynamicStatusBar(
                                _getStatusWithCounts(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Alerts Summary
                    Expanded(
                      flex: 3,
                      child: Container(
                        // width: double.infinity,
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
                            _buildAlertsHeaderSection(isDark),
                            const SizedBox(height: 5),
                            Divider(
                              color:
                                  isDark
                                      ? tWhite.withOpacity(0.6)
                                      : tBlack.withOpacity(0.6),
                              thickness: 0.6,
                            ),
                            const SizedBox(height: 5),
                            _buildAlertsBottomSection(),
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
                      flex: 3,
                      child: Container(
                        height: 325,
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
                            _buildTripsHeaderSection(isDark),
                            const SizedBox(height: 5),
                            Divider(
                              color:
                                  isDark
                                      ? tWhite.withOpacity(0.6)
                                      : tBlack.withOpacity(0.6),
                              thickness: 0.6,
                            ),
                            const SizedBox(height: 5),
                            _buildTripsBottomSection(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 7,
                      child: Container(
                        height: 325,
                        width: double.infinity,
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
                        padding: const EdgeInsets.all(4),
                        child:
                        // kIsWeb
                        //     ? GoogleMap(
                        //       initialCameraPosition: const CameraPosition(
                        //         target: LatLng(
                        //           12.9716,
                        //           77.5946,
                        //         ), // Example: Bengaluru
                        //         zoom: 14,
                        //       ),
                        //       zoomControlsEnabled: true,
                        //       mapType: MapType.normal,
                        //       markers: {
                        //         Marker(
                        //           markerId: const MarkerId('main'),
                        //           position: const LatLng(12.9716, 77.5946),
                        //           infoWindow: const InfoWindow(
                        //             title: 'HQ Location',
                        //           ),
                        //         ),
                        //       },
                        //       onMapCreated: (
                        //         GoogleMapController controller,
                        //       ) {
                        //         // Optional controller storage
                        //       },
                        //     )
                        //     : Center(
                        //       child: Text(
                        //         'Map is supported only on web platform.',
                        //         style: TextStyle(
                        //           color:
                        //               isDark
                        //                   ? Colors.white70
                        //                   : Colors.black54,
                        //           fontSize: 14,
                        //         ),
                        //       ),
                        //     ),
                        buildVehicleMap(isDark: isDark, zoom: 14),
                      ),
                    ),

                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 325,
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
                        child: SingleChildScrollView(
                          child: buildAlertsWidget(isDark: isDark),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 325,
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
                      flex: 3,
                      child: Container(
                        height: 325,
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
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 325,
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(bool isDark) => Text(
    'Dashboard',
    style: GoogleFonts.urbanist(
      fontSize: 20,
      color: isDark ? tWhite : tBlack,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _buildGroupSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLabelBox("Group Name", tBlue, isDark),
            const SizedBox(width: 5),
            _buildDynamicDropdown(isDark),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          '(Note: Filter by Group Name)',
          style: GoogleFonts.urbanist(
            fontSize: 10,
            color: isDark ? tWhite.withOpacity(0.6) : tBlack.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLabelBox("Date", tBlue, isDark),
            const SizedBox(width: 5),
            _buildDynamicDatePicker(isDark),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          '(Note: Filter by Date)',
          style: GoogleFonts.urbanist(
            fontSize: 10,
            color: isDark ? tWhite.withOpacity(0.6) : tBlack.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLabelBox(String text, Color textColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: tTransparent,
        border: Border.all(width: 0.5, color: isDark ? tWhite : tBlack),
      ),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDynamicDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: tTransparent,
        border: Border.all(width: 0.6, color: isDark ? tWhite : tBlack),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: false,
          hint: Text(
            'Select Group',
            style: GoogleFonts.urbanist(fontSize: 12.5, color: tGrey),
          ),
          items:
              groups
                  .map(
                    (group) => DropdownMenuItem<String>(
                      value: group,
                      child: Text(
                        group,
                        style: GoogleFonts.urbanist(
                          fontSize: 12.5,
                          color: isDark ? tWhite : tBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          value: selectedGroup,
          onChanged: (value) => setState(() => selectedGroup = value),
          iconStyleData: IconStyleData(
            icon: Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: isDark ? tWhite : tBlack,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            padding: EdgeInsets.zero,
            maxHeight: 200,
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
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.zero,
            height: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicDatePicker(bool isDark) {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: tTransparent,
          border: Border.all(width: 0.6, color: isDark ? tWhite : tBlack),
        ),
        child: Text(
          DateFormat('dd MMM yyyy').format(selectedDate).toUpperCase(),
          style: GoogleFonts.urbanist(
            fontSize: 12.5,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.blueAccent,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Widget _buildVehicleHeaderSection(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTotalVehiclesInfo(isDark),
        _buildIconCircle('icons/vehicle.svg', tBlue),
      ],
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

  Widget _buildTotalVehiclesInfo(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Vehicles',
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
              '$totalVehicles',
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
      color: color.withOpacity(0.25),
      shape: BoxShape.circle,
    ),
    padding: const EdgeInsets.all(15),
    child: SvgPicture.asset(iconPath, width: 30, height: 30, color: color),
  );

  Widget _buildVehicleBottomSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAnyValuesColumn(
          iconPath: 'icons/vehicle.svg',
          iconColor: tGreen,
          title: 'Active Vehicles',
          value: '900',
        ),
        _buildAnyValuesColumn(
          iconPath: 'icons/vehicle.svg',
          iconColor: tRedDark,
          title: 'Inactive Vehicles',
          value: '450',
        ),
      ],
    );
  }

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
        'iconPath': 'icons/distance.svg',
        'iconColor': tGreen,
        'title': 'Distance Covered (km)',
        'value': '120,450',
      },
      {
        'iconPath': 'icons/consumedhours.svg',
        'iconColor': tPink,
        'title': 'Consumed Hours',
        'value': '3,450',
      },
      {
        'iconPath': 'icons/completed.svg',
        'iconColor': tBlue,
        'title': 'Completed Trips',
        'value': '45,300',
      },
      {
        'iconPath': 'icons/battery.svg',
        'iconColor': tOrange1,
        'title': 'Power (kWh)',
        'value': '75,200',
      },
    ];

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(), // avoid nested scroll
      shrinkWrap: true, // so it fits inside Column
      crossAxisCount: 2, // 2 items per row
      crossAxisSpacing: 10,
      mainAxisSpacing: 0,
      childAspectRatio: 1.8, // adjust spacing shape
      children:
          tripStats.map((stat) {
            return _buildAnyValuesColumn(
              iconPath: stat['iconPath'],
              iconColor: stat['iconColor'],
              title: stat['title'],
              value: stat['value'],
            );
          }).toList(),
    );
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

  Widget _buildDynamicStatusBar(List<Map<String, dynamic>> statuses) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = totalVehicles;

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
    final total = totalVehicles;

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

  Widget buildVehicleMap({bool isDark = false, double zoom = 12.0}) {
    final vehicles = [
      {'location': const LatLng(12.9716, 77.5946), 'status': 'moving'},
      {'location': const LatLng(12.9750, 77.6000), 'status': 'idle'},
      {'location': const LatLng(12.9680, 77.5800), 'status': 'stopped'},
      {'location': const LatLng(12.9650, 77.6200), 'status': 'disconnected'},
      {'location': const LatLng(12.9810, 77.6050), 'status': 'moving'},
      {'location': const LatLng(12.9890, 77.6100), 'status': 'idle'},
      {'location': const LatLng(12.9600, 77.5950), 'status': 'stopped'},
      {'location': const LatLng(12.9550, 77.5850), 'status': 'disconnected'},
      {'location': const LatLng(12.9760, 77.5900), 'status': 'moving'},
      {'location': const LatLng(12.9830, 77.6000), 'status': 'idle'},
    ];

    final tileUrl =
        isDark
            ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
            : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';

    String getTruckIcon(String status) {
      switch (status) {
        case 'moving':
          return 'assets/icons/truck1.svg';
        case 'idle':
          return 'assets/icons/truck2.svg';
        case 'stopped':
          return 'assets/icons/truck3.svg';
        case 'disconnected':
          return 'assets/icons/truck4.svg';
        default:
          return 'assets/icons/truck1.svg';
      }
    }

    return FlutterMap(
      key: const ValueKey('vehicle_map_widget'),
      options: MapOptions(
        initialCenter: const LatLng(12.9716, 77.5946),
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
        MarkerLayer(
          markers:
              vehicles.map((vehicle) {
                final LatLng point = vehicle['location'] as LatLng;
                final String iconPath = getTruckIcon(
                  vehicle['status'] as String,
                );

                return Marker(
                  point: point,
                  width: 35,
                  height: 35,
                  child: SvgPicture.asset(iconPath, width: 25, height: 25),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget buildAlertsWidget({bool isDark = false}) {
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
        Text(
          'Alerts Info',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ...alerts.map((alert) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
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
                          color: getAlertColor(alert['alertType']!),
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
