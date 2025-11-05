import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/appColors.dart';
import '../../utils/appLogger.dart';
import '../../utils/appResponsive.dart';
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
        Container(
          width: 350,
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
                  context.go('/home/devices/${widget.device['imei']}/overview');
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
                  );
                },
                context,
                isDark,
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        //Dynamic content based on selected tab
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child:
              selectedIndex == 0
                  ? DeviceGeneralInfoScreen(device: widget.device)
                  : DeviceDiagnosticsInfoScreen(device: widget.device),
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
}
