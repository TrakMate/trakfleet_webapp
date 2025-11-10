import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../utils/appColors.dart';
import '../../utils/appResponsive.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime selectedDate = DateTime.now();
  String _selectedMenu = 'Devices';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveLayout(
      mobile: _buildLayout(isDark),
      tablet: _buildLayout(isDark),
      desktop: _buildLayout(isDark),
    );
  }

  Widget _buildLayout(bool isDark) {
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
                const SizedBox(width: 10),
                _buildDynamicDatePicker(isDark),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildReportsMenuBar(),
        const SizedBox(height: 20),
        Expanded(child: _buildTabContent(isDark)),
      ],
    );
  }

  Widget _buildTitle(bool isDark) => Text(
    'Reports',
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

  Widget _buildReportsMenuBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<String> menus = ['Devices', 'Trips', 'Alerts', 'Stats'];

    return Container(
      // width: double.infinity,
      width: 700,
      height: 40,
      decoration: BoxDecoration(
        color: tTransparent,
        border: Border.all(
          // top: BorderSide(color: tBlue, width: 0.5),
          // bottom: BorderSide(color: tBlue, width: 0.5),
          color: isDark ? tWhite : tBlack,
          width: 0.4,
        ),
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
            menus.map((label) {
              final bool isSelected = _selectedMenu == label;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMenu = label),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isSelected ? tBlue : tTransparent,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      label,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color:
                            isSelected
                                ? tWhite
                                : (isDark ? tWhite : tBlack.withOpacity(0.8)),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  /// Dynamically loads tab content
  Widget _buildTabContent(bool isDark) {
    switch (_selectedMenu) {
      case 'Trips':
        return _buildTripsReport(isDark);
      case 'Alerts':
        return _buildAlertsReport(isDark);
      case 'Stats':
        return _buildStatsReport(isDark);
      case 'Devices':
      default:
        return _buildDevicesReport(isDark);
    }
  }

  // Sample placeholder widgets for each tab
  Widget _buildDevicesReport(bool isDark) => Center(
    child: Text(
      'Devices Report Content',
      style: GoogleFonts.urbanist(
        fontSize: 16,
        color: isDark ? tWhite : tBlack,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _buildTripsReport(bool isDark) => Center(
    child: Text(
      'Trips Report Content',
      style: GoogleFonts.urbanist(
        fontSize: 16,
        color: isDark ? tWhite : tBlack,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _buildAlertsReport(bool isDark) => Center(
    child: Text(
      'Alerts Report Content',
      style: GoogleFonts.urbanist(
        fontSize: 16,
        color: isDark ? tWhite : tBlack,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _buildStatsReport(bool isDark) => Center(
    child: Text(
      'Stats Report Content',
      style: GoogleFonts.urbanist(
        fontSize: 16,
        color: isDark ? tWhite : tBlack,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
