import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'dart:html' as html;
import '../../utils/appResponsive.dart';

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
    return ResponsiveLayout(
      mobile: const Center(child: Text("Mobile / Tablet layout coming soon")),
      tablet: const Center(child: Text("Mobile / Tablet layout coming soon")),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final device = widget.device;
    final grafanaUrl =
        "https://play.grafana.org/d/000000012/grafana-play-home"; // ✅ public demo URL

    return SingleChildScrollView(
      child: GrafanaEmbedWidget(iframeUrl: grafanaUrl),
    );
  }
}

class GrafanaEmbedWidget extends StatefulWidget {
  final String iframeUrl;
  const GrafanaEmbedWidget({super.key, required this.iframeUrl});

  @override
  State<GrafanaEmbedWidget> createState() => _GrafanaEmbedWidgetState();
}

class _GrafanaEmbedWidgetState extends State<GrafanaEmbedWidget> {
  late html.IFrameElement _iframeElement;

  @override
  void initState() {
    super.initState();
    _iframeElement =
        html.IFrameElement()
          ..src = widget.iframeUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';

    //Register iframe properly for Flutter Web
    ui.platformViewRegistry.registerViewFactory(
      widget.iframeUrl,
      (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: widget.iframeUrl);
  }
}
