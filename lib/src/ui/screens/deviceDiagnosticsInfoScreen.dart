import 'package:flutter/material.dart';

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
    final device = widget.device;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}
