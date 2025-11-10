import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:tm_fleet_management/src/utils/appColors.dart';

import '../../utils/appResponsive.dart';
import '../widgets/charts/alertsPieChart.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  DateTime selectedDate = DateTime.now();

  int currentPage = 1;
  int rowsPerPage = 10;
  int totalPages = 10; // 100 alerts / 10 per page

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(isDark),
    );
  }

  Widget _buildMobileLayout() {
    return Container();
  }

  Widget _buildTabletLayout() {
    return Container();
  }

  Widget _buildDesktopLayout(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitle(isDark),
            Row(
              children: [
                _buildFilterBySearch(isDark),
                SizedBox(width: 10),
                _buildDynamicDatePicker(isDark),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 4, child: _buildAlertsOverview(isDark)),
              const SizedBox(width: 10),
              Expanded(flex: 6, child: _buildAlertsTable(isDark)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(bool isDark) => Text(
    'Alerts',
    style: GoogleFonts.urbanist(
      fontSize: 20,
      color: isDark ? tWhite : tBlack,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _buildFilterBySearch(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 250,
          height: 40,
          decoration: BoxDecoration(
            color: tTransparent,
            border: Border.all(color: isDark ? tWhite : tBlack, width: 1),
          ),
          child: TextField(
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? tWhite : tBlack,
            ),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? tWhite : tBlack,
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: isDark ? tWhite : tBlack,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '(Note: Filter by Search)',
          style: GoogleFonts.urbanist(
            fontSize: 10,
            color: isDark ? tWhite.withOpacity(0.6) : tBlack.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicDatePicker(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: tTransparent,
              border: Border.all(width: 0.6, color: isDark ? tWhite : tBlack),
            ),
            child: Center(
              child: Text(
                DateFormat('dd MMM yyyy').format(selectedDate).toUpperCase(),
                style: GoogleFonts.urbanist(
                  fontSize: 12.5,
                  color: isDark ? tWhite : tBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
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

  Widget _buildAlertsTable(bool isDark) {
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

    // Generate dummy alerts
    final List<Map<String, dynamic>> alerts = List.generate(100, (index) {
      final type = alertTypes[index % alertTypes.length];
      final isCritical = [
        'Over Speed',
        'Power Disconnect',
        'Battery Low',
        'SOS Triggered',
        'Fall Detected',
      ].contains(type);

      return {
        'imei': '3568790400${(index + 100).toString().padLeft(3, '0')}',
        'vehicleId': 'VH-${index % 15 + 1}',
        'alertTime': DateFormat(
          'dd MMM yyyy, hh:mm a',
        ).format(DateTime.now().subtract(Duration(minutes: index * 3))),
        'category': isCritical ? 'Critical' : 'Non-Critical',
        'type': type,
      };
    });

    // Pagination logic
    final startIndex = (currentPage - 1) * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, alerts.length);
    final currentPageAlerts = alerts.sublist(startIndex, endIndex);

    Color getCategoryColor(String category) {
      return category == 'Critical' ? tRed : tOrange1;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;

        return Container(
          width: maxWidth,
          height: maxHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scrollable Table Area
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: maxWidth),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            isDark
                                ? tBlue.withOpacity(0.15)
                                : tBlue.withOpacity(0.05),
                          ),
                          headingTextStyle: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w700,
                            color: isDark ? tWhite : tBlack,
                            fontSize: 13,
                          ),
                          dataTextStyle: GoogleFonts.urbanist(
                            color: isDark ? tWhite : tBlack,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                          columnSpacing: 30,
                          border: TableBorder.all(
                            color:
                                isDark
                                    ? tWhite.withOpacity(0.1)
                                    : tBlack.withOpacity(0.1),
                            width: 0.4,
                          ),

                          dividerThickness: 0.01,
                          columns: const [
                            DataColumn(label: Text('IMEI Number')),
                            DataColumn(label: Text('Vehicle ID')),
                            DataColumn(label: Text('Alert Time')),
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Alert Type')),
                          ],
                          rows:
                              currentPageAlerts.map((alert) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(alert['imei'])),
                                    DataCell(Text(alert['vehicleId'])),
                                    DataCell(Text(alert['alertTime'])),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getCategoryColor(
                                            alert['category'],
                                          ).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Text(
                                          alert['category'],
                                          style: GoogleFonts.urbanist(
                                            color: getCategoryColor(
                                              alert['category'],
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(alert['type'])),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Pagination Controls
              if (totalPages > 1) _buildPaginationControls(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlertsOverview(bool isDark) {
    final Map<String, double> criticalAlerts = {
      'Power Disconnect': 30,
      'Battery Low': 25,
      'Tilt Alert': 20,
      'Fall Detected': 15,
      'SOS Triggered': 10,
    };

    final Map<String, double> nonCriticalAlerts = {
      'GPRS Lost': 20,
      'Over Speed': 30,
      'Ignition On': 25,
      'Ignition Off': 15,
      'Geo Fence Alert': 10,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: GoogleFonts.urbanist(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? tWhite : tBlack,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildAlertInfoCard(
              title: 'Total Alerts',
              count: '1276383',
              iconPath: 'icons/alerts.svg',
              gradientColor: tBlue,
              isDark: isDark,
            ),
            const SizedBox(width: 10),
            _buildAlertInfoCard(
              title: 'Critical Alerts',
              count: '12383',
              iconPath: 'icons/alerts.svg',
              gradientColor: tRedDark,
              isDark: isDark,
            ),
            const SizedBox(width: 10),
            _buildAlertInfoCard(
              title: 'Non-Critical Alerts',
              count: '12763',
              iconPath: 'icons/alerts.svg',
              gradientColor: tOrange1,
              isDark: isDark,
            ),
          ],
        ),
        const SizedBox(height: 15),
        // AlertsPieChart(),
        Text(
          'Critical Alerts',
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? tWhite : tBlack,
          ),
        ),
        const SizedBox(height: 10),
        _buildAnimatedAlertsBar(criticalAlerts, alertColors, isDark),
        const SizedBox(height: 10),
        _buildLegends(criticalAlerts, alertColors, isDark),

        const SizedBox(height: 20),

        // ===== Non-Critical Alerts =====
        Text(
          'Non-Critical Alerts',
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? tWhite : tBlack,
          ),
        ),
        const SizedBox(height: 10),
        _buildAnimatedAlertsBar(nonCriticalAlerts, alertColors, isDark),
        const SizedBox(height: 10),
        _buildLegends(nonCriticalAlerts, alertColors, isDark),
      ],
    );
  }

  // Animated Bar
  // Widget _buildAnimatedAlertsBar(
  //   Map<String, double> data,
  //   Map<String, Color> colors,
  //   bool isDark,
  // ) {
  //   double total = data.values.fold(0, (a, b) => a + b);

  //   return Container(
  //     width: double.infinity,
  //     height: 60,
  //     decoration: BoxDecoration(
  //       border: Border.all(width: 0.3, color: isDark ? tWhite : tBlack),
  //     ),
  //     child: Row(
  //       children:
  //           data.entries.map((entry) {
  //             double percentage = (entry.value / total);
  //             return Expanded(
  //               flex: (percentage * 1000).toInt(),
  //               child: TweenAnimationBuilder<double>(
  //                 tween: Tween<double>(begin: 0, end: percentage),
  //                 duration: const Duration(milliseconds: 800),
  //                 curve: Curves.easeInOut,
  //                 builder: (context, value, child) {
  //                   return FractionallySizedBox(
  //                     widthFactor: value,
  //                     alignment: Alignment.centerLeft,
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         color: colors[entry.key] ?? Colors.grey,
  //                       ),
  //                       child: Tooltip(
  //                         message:
  //                             "${entry.key}: ${(entry.value).toStringAsFixed(1)}%",
  //                         child: Container(),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             );
  //           }).toList(),
  //     ),
  //   );
  // }

  Widget _buildAnimatedAlertsBar(
    Map<String, double> data,
    Map<String, Color> colors,
    bool isDark,
  ) {
    double total = data.values.fold(0, (a, b) => a + b);

    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        color: tTransparent,
        // border: Border.all(width: 0.3, color: isDark ? tWhite : tBlack),
      ),
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
                      color: colors[entry.key] ?? tGrey,
                      child: Tooltip(
                        message:
                            "${entry.key}: ${(entry.value).toStringAsFixed(1)}%",
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

  // Legends Row
  Widget _buildLegends(
    Map<String, double> data,
    Map<String, Color> colors,
    bool isDark,
  ) {
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children:
          data.keys.map((key) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[key] ?? Colors.grey,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  key,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: isDark ? tWhite : tBlack,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  /// Reusable widget for alert info cards
  Widget _buildAlertInfoCard({
    required String title,
    required String count,
    required String iconPath,
    required Color gradientColor,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: SweepGradient(
            colors: [
              gradientColor.withOpacity(0.6),
              gradientColor.withOpacity(0.2),
            ],
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? tWhite : tBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  iconPath,
                  width: 25,
                  height: 25,
                  color: gradientColor,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              count,
              style: GoogleFonts.urbanist(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: isDark ? tWhite : tBlack,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(bool isDark) {
    const int visiblePageCount = 5;

    // Determine start and end of visible window
    int startPage =
        ((currentPage - 1) ~/ visiblePageCount) * visiblePageCount + 1;
    int endPage = (startPage + visiblePageCount - 1).clamp(1, totalPages);

    final pageButtons = <Widget>[];

    for (int pageNum = startPage; pageNum <= endPage; pageNum++) {
      final isSelected = pageNum == currentPage;

      pageButtons.add(
        GestureDetector(
          onTap: () {
            if (!mounted) return;
            setState(() => currentPage = pageNum);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? tBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    isSelected
                        ? tBlue
                        : (isDark ? Colors.white54 : Colors.black54),
              ),
            ),
            child: Text(
              '$pageNum',
              style: GoogleFonts.urbanist(
                color:
                    isSelected
                        ? tWhite
                        : (isDark
                            ? tWhite.withOpacity(0.8)
                            : tBlack.withOpacity(0.8)),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    }

    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Previous Button
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: isDark ? tWhite : tBlack,
              size: 22,
            ),
            onPressed: () {
              if (currentPage > 1) {
                setState(() => currentPage--);
              }
            },
          ),

          /// Page Buttons (windowed 5)
          Row(children: pageButtons),

          /// Next Button
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: isDark ? tWhite : tBlack,
              size: 22,
            ),
            onPressed: () {
              if (currentPage < totalPages) {
                setState(() => currentPage++);
              }
            },
          ),

          const SizedBox(width: 16),

          /// Page Input Box
          SizedBox(
            width: 70,
            height: 32,
            child: TextField(
              controller: controller,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: isDark ? tWhite : tBlack,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Page',
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? tWhite : tBlack,
                    width: 0.8,
                  ),
                ),
              ),
              onSubmitted: (value) {
                final page = int.tryParse(value);
                if (page != null &&
                    page >= 1 &&
                    page <= totalPages &&
                    mounted) {
                  setState(() => currentPage = page);
                }
              },
            ),
          ),

          const SizedBox(width: 10),

          /// Show visible range (e.g., "1–5 of 20")
          Text(
            '$startPage–$endPage of $totalPages',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: isDark ? tWhite : tBlack,
            ),
          ),
        ],
      ),
    );
  }
}
