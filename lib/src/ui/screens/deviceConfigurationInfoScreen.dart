import 'package:flutter/material.dart';

import '../../utils/appColors.dart';
import '../../utils/appResponsive.dart';

class DeviceConfigInfoScreen extends StatefulWidget {
  final Map<String, dynamic> device;

  const DeviceConfigInfoScreen({super.key, required this.device});

  @override
  State<DeviceConfigInfoScreen> createState() => _DeviceConfigInfoScreenState();
}

class _DeviceConfigInfoScreenState extends State<DeviceConfigInfoScreen> {
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: tGreen),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: tRed),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
