import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utils/appColors.dart';
import '../../utils/appLogger.dart';
import '../../utils/appResponsive.dart';
import 'deviceConfigurationInfoScreen.dart';
import 'deviceDiagnosticsInfoScreen.dart';
import 'deviceGeneralInfoScreen.dart';

class DeviceControlWidget extends StatefulWidget {
  final Map<String, dynamic> device;
  final int initialTab;

  const DeviceControlWidget({
    super.key,
    required this.device,
    this.initialTab = 0,
  });

  @override
  State<DeviceControlWidget> createState() => _DeviceControlWidgetState();
}

class _DeviceControlWidgetState extends State<DeviceControlWidget> {
  late int selectedIndex;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialTab;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final device = widget.device;
    LoggerUtil.getInstance.print(device);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Container
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 450,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: isDark ? tWhite : tBlack, width: 0.6),
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  _buildTabButton(
                    "Overview",
                    0,
                    selectedIndex,
                    (i) {
                      setState(() => selectedIndex = i);
                      context.go(
                        '/home/devices/${widget.device['imei']}/overview',
                        extra: widget.device,
                      );
                    },
                    context,
                    isDark,
                  ),
                  _buildTabButton(
                    "Diagnostics",
                    1,
                    selectedIndex,
                    (i) {
                      setState(() => selectedIndex = i);
                      context.go(
                        '/home/devices/${widget.device['imei']}/diagnostics',
                        extra: widget.device,
                      );
                    },
                    context,
                    isDark,
                  ),
                  _buildTabButton(
                    "Configuration",
                    2,
                    selectedIndex,
                    (i) {
                      setState(() => selectedIndex = i);
                      context.go(
                        '/home/devices/${widget.device['imei']}/configuration',
                        extra: widget.device,
                      );
                    },
                    context,
                    isDark,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _buildLabelBox("Filter By Date", tBlue, isDark),
                const SizedBox(width: 5),
                _buildDynamicDatePicker(isDark),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        //Dynamic content based on selected tab
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child:
                selectedIndex == 0
                    ? DeviceGeneralInfoScreen(device: widget.device)
                    : selectedIndex == 1
                    ? DeviceDiagnosticsInfoScreen(device: widget.device)
                    : DeviceConfigInfoScreen(device: widget.device),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(
    String label,
    int index,
    int selectedIndex,
    void Function(int) onSelected,
    BuildContext context,
    bool isDark,
  ) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: TextButton(
        onPressed: () => onSelected(index),
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? tBlue : (isDark ? tBlack : tWhite),
          foregroundColor: isSelected ? tWhite : (isDark ? tWhite : tBlack),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDynamicDatePicker(bool isDark) {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
}
