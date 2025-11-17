import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../utils/appColors.dart';
import '../../utils/appResponsive.dart';
import '../../utils/route/navigation_helpers.dart';

class DevicesScreen extends StatefulWidget {
  final String? filterStatus; // can be 'moving', 'stopped', etc.
  const DevicesScreen({super.key, this.filterStatus});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  OverlayEntry? _devicePopup;

  final List<String> _statuses = ['Moving', 'Stopped', 'Idle', 'Disconnected'];

  final List<String> _filterValues = [
    'Max Odo',
    'Max Trips Count',
    'Max Alerts',
    'Fuel',
    'EV',
  ];

  final List<String> _selectedStatuses = [];
  final List<String> _selectedFilterValues = [];

  bool _showFilterPanel = false;

  final Map<String, Color> _statusColors = {
    'Moving': tGreen,
    'Stopped': tRed,
    'Idle': tOrange1,
    'Disconnected': tGrey,
  };

  final MapController _mapController = MapController();

  final ValueNotifier<LatLng> _centerNotifier = ValueNotifier(
    LatLng(13.0827, 80.2707),
  );
  final ValueNotifier<double> _zoomNotifier = ValueNotifier<double>(4.5);

  bool _isZooming = false;
  Timer? _zoomDebounceTimer;
  Timer? _positionDebounceTimer;

  int currentPage = 1;
  int itemsPerPage = 10;

  // late final List<Map<String, dynamic>> allDevices;
  late List<Map<String, dynamic>> filteredallDevices;

  late final List<Marker> _cachedMarkers;

  final List<String> _truckIconPaths = [
    'icons/truck1.svg',
    'icons/truck3.svg',
    'icons/truck4.svg',
    'icons/truck5.svg',
  ];

  @override
  void initState() {
    super.initState();
    filteredallDevices = _generateDummyDevices(count: 1000, seed: 840);
    // Apply filter if navigated with a status
    if (widget.filterStatus != null) {
      filteredallDevices =
          filteredallDevices.where((device) {
            final status = device['status']?.toString().toLowerCase();
            return status == widget.filterStatus!.toLowerCase();
          }).toList();
    } else {
      filteredallDevices = filteredallDevices;
    }

    // Build markers based on filtered list
    _cachedMarkers = _buildMarkersFromDevices(filteredallDevices);

    // _cachedMarkers = _buildMarkersFromDevices(allDevices);
  }

  @override
  void dispose() {
    _zoomDebounceTimer?.cancel();
    _positionDebounceTimer?.cancel();
    _centerNotifier.dispose();
    _zoomNotifier.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _generateDummyDevices({
    int count = 1000, //50
    int seed = 840, //42
  }) {
    final Random rnd = Random(seed);
    final Map<String, List<String>> cityAreas = {
      'Bengaluru': [
        'Koramangala',
        'Indiranagar',
        'Whitefield',
        'Electronic City',
        'HSR Layout',
        'Jayanagar',
        'BTM Layout',
        'MG Road',
        'Rajajinagar',
        'Malleshwaram',
      ],
      'Chennai': [
        'Adyar',
        'T Nagar',
        'Anna Nagar',
        'Velachery',
        'Besant Nagar',
      ],
      'Hyderabad': ['Banjara Hills', 'Gachibowli', 'Madhapur'],
      'Mumbai': ['Andheri', 'Bandra', 'Powai'],
      'Kolkata': ['Salt Lake', 'Park Street'],
      'Delhi': ['Connaught Place', 'Saket'],
    };

    final Map<String, LatLng> cityAnchors = {
      'Bengaluru': LatLng(12.9716, 77.5946),
      'Chennai': LatLng(13.0827, 80.2707),
      'Hyderabad': LatLng(17.3850, 78.4867),
      'Mumbai': LatLng(19.0760, 72.8777),
      'Kolkata': LatLng(22.5726, 88.3639),
      'Delhi': LatLng(28.6139, 77.2090),
    };

    final cities = cityAreas.keys.toList();

    List<Map<String, dynamic>> devices = [];

    for (int i = 0; i < count; i++) {
      final city = cities[i % cities.length];
      final areas = cityAreas[city]!;
      final idx = i % areas.length;
      final areaName = areas[idx];

      final anchor = cityAnchors[city]!;
      final lat = anchor.latitude + (rnd.nextDouble() - 0.5) * 0.06;
      final lon = anchor.longitude + (rnd.nextDouble() - 0.5) * 0.06;

      final statuses = ['Moving', 'Idle', 'Stopped', 'Disconnected'];
      final status = statuses[rnd.nextInt(statuses.length)];

      final odo = 7000 + rnd.nextInt(9000);
      final trips = rnd.nextInt(30);
      final alerts = rnd.nextInt(6);
      final fuel = rnd.nextInt(45);

      final device = {
        'vehicleNumber': 'VHN${1000 + i}',
        'status': status,
        'imei': '${125864725 + i * 5}',
        'icid': '${156857246 + i * 3}',
        'odo': '$odo',
        'trips': '$trips',
        'alerts': '$alerts',
        'fuel': '${fuel} L',
        'location': '$areaName, $city',
        'latlng': LatLng(lat, lon),
      };

      devices.add(device);
    }

    return devices;
  }

  List<Marker> _buildMarkersFromDevices(List<Map<String, dynamic>> devices) {
    return devices.map((device) {
      final LatLng pos = device['latlng'] ?? const LatLng(0, 0);

      String iconPath;
      switch ((device['status'] ?? '').toString()) {
        case 'Moving':
          iconPath = _truckIconPaths[0];
          break;
        case 'Stopped':
          iconPath = _truckIconPaths[1];
          break;
        case 'Idle':
          iconPath = _truckIconPaths[2];
          break;
        case 'Disconnected':
        default:
          iconPath = _truckIconPaths[3];
      }

      return Marker(
        key: ValueKey<Map<String, dynamic>>(device),
        width: 40,
        height: 40,
        point: pos,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (TapDownDetails details) {
            // details.globalPosition is the tap position in screen coordinates
            final globalPos = details.globalPosition;
            _showDeviceTooltip(
              device,
              device['latlng'],
              Theme.of(context).brightness == Brightness.dark,
              globalPosition: globalPos,
              placement: 'top', // or choose logic to auto decide
            );
          },
          child: SvgPicture.asset(
            iconPath,
            width: 36,
            height: 36,
            // optionally color: _statusColors[device['status']] ?? Colors.grey,
          ),
        ),
      );
    }).toList();
  }

  List<Map<String, dynamic>> get filteredDevices {
    List<Map<String, dynamic>> result = List.from(filteredallDevices);

    if (_selectedStatuses.isNotEmpty) {
      result =
          result.where((d) => _selectedStatuses.contains(d['status'])).toList();
    }

    if (_selectedFilterValues.contains('Max Odo')) {
      result.sort(
        (a, b) =>
            int.parse(b['odo'].split(' ').first) -
            int.parse(a['odo'].split(' ').first),
      );
    } else if (_selectedFilterValues.contains('Max Trips Count')) {
      result.sort((a, b) => int.parse(b['trips']) - int.parse(a['trips']));
    } else if (_selectedFilterValues.contains('Max Alerts')) {
      result.sort((a, b) => int.parse(b['alerts']) - int.parse(a['alerts']));
    }

    return result;
  }

  int get totalPages =>
      (filteredDevices.length / itemsPerPage)
          .ceil()
          .clamp(1, double.infinity)
          .toInt();

  List<Map<String, dynamic>> get paginatedDevices {
    final start = (currentPage - 1) * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filteredDevices.length);
    if (start >= filteredDevices.length) return [];
    return filteredDevices.sublist(start, end);
  }

  void _nextPage() {
    if (currentPage < totalPages) setState(() => currentPage++);
  }

  void _previousPage() {
    if (currentPage > 1) setState(() => currentPage--);
  }

  void _changeZoom(double delta) {
    _zoomDebounceTimer?.cancel();
    final tentativeZoom = (_zoomNotifier.value + delta).clamp(3.0, 18.0);
    _zoomDebounceTimer = Timer(const Duration(milliseconds: 140), () async {
      if (!mounted) return;
      if (_isZooming) return;
      _isZooming = true;
      try {
        _mapController.move(_centerNotifier.value, tentativeZoom);
        _zoomNotifier.value = tentativeZoom;
        await Future.delayed(const Duration(milliseconds: 120));
      } finally {
        _isZooming = false;
      }
    });
  }

  void _zoomIn() => _changeZoom(1.0);
  void _zoomOut() => _changeZoom(-1.0);

  void _onMapPositionChanged(dynamic position, bool hasGesture) {
    _positionDebounceTimer?.cancel();
    _positionDebounceTimer = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      try {
        final newCenter = position.center as LatLng?;
        final newZoom = position.zoom as double?;
        if (newCenter != null) _centerNotifier.value = newCenter;
        if (newZoom != null) _zoomNotifier.value = newZoom;
      } catch (_) {}
    });
  }

  Map<String, dynamic> _getClusterInfo(List<Marker> markers) {
    int moving = 0, stopped = 0, idle = 0;
    for (var marker in markers) {
      final key = marker.key;
      if (key is ValueKey<Map<String, dynamic>>) {
        final device = key.value;
        final s = (device['status'] ?? '').toString();
        if (s == 'Moving') moving++;
        if (s == 'Stopped') stopped++;
        if (s == 'Idle') idle++;
      }
    }

    if (moving >= stopped && moving >= idle && moving > 0) {
      return {
        'status': 'Moving',
        'color': tGreen.withOpacity(0.85),
        'textColor': Colors.white,
      };
    } else if (stopped >= moving && stopped >= idle && stopped > 0) {
      return {
        'status': 'Stopped',
        'color': tRed.withOpacity(0.85),
        'textColor': Colors.white,
      };
    } else if (idle > 0) {
      return {
        'status': 'Idle',
        'color': tOrange1.withOpacity(0.9),
        'textColor': tBlack,
      };
    } else {
      return {
        'status': 'Other',
        'color': Colors.blueAccent.withOpacity(0.8),
        'textColor': Colors.white,
      };
    }
  }

  void _showDeviceTooltip(
    Map<String, dynamic> device,
    LatLng position,
    bool isDark, {
    required Offset globalPosition,
    String placement = 'top',
  }) {
    _removeDeviceTooltip();

    const double popupWidth = 200;
    const double popupHeight = 90;
    const double gap = 0;

    double left = globalPosition.dx - popupWidth / 2;
    double top = globalPosition.dy - popupHeight - gap;

    switch (placement) {
      case 'bottom':
        top = globalPosition.dy + gap;
        break;
      case 'left':
        left = globalPosition.dx - popupWidth - gap;
        top = globalPosition.dy - popupHeight / 2;
        break;
      case 'right':
        left = globalPosition.dx + gap;
        top = globalPosition.dy - popupHeight / 2;
        break;
      default:
        break;
    }

    final Size screen = MediaQuery.of(context).size;
    left = left.clamp(6.0, screen.width - popupWidth - 6.0);
    top = top.clamp(6.0, screen.height - popupHeight - 6.0);

    _devicePopup = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: left,
          top: top,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: 1,
            child: Material(
              color: tTransparent,
              child: Container(
                width: popupWidth,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isDark
                            ? [
                              Colors.black.withOpacity(0.85),
                              Colors.black.withOpacity(0.6),
                            ]
                            : [
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.6),
                            ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isDark
                            ? Colors.white24
                            : Colors.black12.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDark
                              ? Colors.black54
                              : Colors.grey.withOpacity(0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  backgroundBlendMode: BlendMode.overlay,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Device Details',
                          style: GoogleFonts.urbanist(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                        GestureDetector(
                          onTap: _removeDeviceTooltip,
                          child: Icon(
                            Icons.close,
                            size: 15,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Divider(
                      color:
                          isDark
                              ? tWhite.withOpacity(0.5)
                              : tBlack.withOpacity(0.5),
                      thickness: 0.4,
                    ),
                    SizedBox(height: 2),
                    // Device details grid
                    Wrap(
                      runSpacing: 1,
                      children: [
                        _deviceInfoRow(
                          'Vehicle',
                          device['vehicleNumber'],
                          isDark,
                        ),
                        _deviceInfoRow('Status', device['status'], isDark),
                        _deviceInfoRow('IMEI', device['imei'], isDark),
                        _deviceInfoRow('ODO', device['odo'], isDark),
                        _deviceInfoRow('Trips', device['trips'], isDark),
                        _deviceInfoRow('Alerts', device['alerts'], isDark),
                        _deviceInfoRow('Location', device['location'], isDark),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    final overlay = Overlay.of(context);
    if (overlay != null) overlay.insert(_devicePopup!);
  }

  void _removeDeviceTooltip() {
    _devicePopup?.remove();
    _devicePopup = null;
  }

  Widget _deviceInfoRow(String title, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: isDark ? tWhite : tBlack,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.urbanist(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? tWhite : tBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegends() {
    return Positioned(
      left: 12,
      bottom: 12,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: tWhite.withOpacity(0.9),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              _statusColors.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(color: e.value),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        e.key,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: tBlack,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildClusterMap() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use filtered devices instead of cached markers
    final markers = _buildMarkersFromDevices(filteredDevices);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _centerNotifier.value,
        initialZoom: _zoomNotifier.value,
        maxZoom: 18,
        minZoom: 3,
        onPositionChanged:
            (position, hasGesture) =>
                _onMapPositionChanged(position, hasGesture),
      ),
      children: [
        TileLayer(
          urlTemplate:
              isDark
                  ? 'https://tile.jawg.io/jawg-dark/{z}/{x}/{y}.png?access-token=l31D4TSqTnDrrc5swHb4XipLx8TD4nSeKdwTqfFJrSl6gNjV6bLJw4OehHeMsc6X'
                  : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),

        // --- Cluster Layer ---
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 60,
            size: const Size(35, 35),
            markers: markers,
            disableClusteringAtZoom: 13,
            builder: (context, clusterMarkers) {
              final info = _getClusterInfo(clusterMarkers);
              final color = info['color'] as Color;
              final textColor = info['textColor'] as Color;
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: color,
                  gradient: SweepGradient(
                    colors: [color, color.withOpacity(0.6)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.35),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  clusterMarkers.length.toString(),
                  style: GoogleFonts.urbanist(
                    color: textColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            // --- Handle marker tap ---
            onMarkerTap: (marker) {
              if (marker.key is ValueKey<Map<String, dynamic>>) {
                final device =
                    (marker.key as ValueKey<Map<String, dynamic>>).value;
                _showDeviceTooltip(
                  device,
                  device['latlng'],
                  isDark,
                  globalPosition: const Offset(0, 0),
                  placement: 'top',
                );
              }
            },
          ),
        ),

        // --- Zoom controls ---
        Positioned(
          right: 12,
          top: 12,
          child: Column(
            children: [
              _mapControlButton(iconPath: 'icons/zoomout.svg', onTap: _zoomIn),
              const SizedBox(height: 6),
              _mapControlButton(iconPath: 'icons/zoomin.svg', onTap: _zoomOut),
            ],
          ),
        ),

        // --- Legends ---
        _buildLegends(),
      ],
    );
  }

  Widget _buildFilterPanel(bool isDark) => Positioned(
    top: 55,
    right: 0,
    child: Material(
      color: Colors.transparent,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? tBlack : tWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isDark ? tWhite.withOpacity(0.2) : tBlack.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: isDark ? tWhite : tBlack, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterGroup(
              title: 'Vehicle Status',
              items: _statuses,
              selectedItems: _selectedStatuses,
              onTap: (item) {
                if (!mounted) return;
                setState(() {
                  if (_selectedStatuses.contains(item)) {
                    _selectedStatuses.remove(item);
                  } else {
                    _selectedStatuses.add(item);
                  }
                });
              },
              isDark: isDark,
              colorResolver: (item) => _statusColors[item] ?? tBlue,
            ),
            const SizedBox(height: 14),
            Divider(
              color: isDark ? tWhite.withOpacity(0.4) : tBlack.withOpacity(0.4),
            ),
            const SizedBox(height: 12),
            _buildFilterGroup(
              title: 'Filter by Values',
              items: _filterValues,
              selectedItems: _selectedFilterValues,
              onTap: (item) {
                if (!mounted) return;
                setState(() {
                  if (_selectedFilterValues.contains(item)) {
                    _selectedFilterValues.remove(item);
                  } else {
                    _selectedFilterValues.clear();
                    _selectedFilterValues.add(item);
                  }
                  currentPage = 1;
                });
              },
              isDark: isDark,
              colorResolver: (_) => tBlue,
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (!mounted) return;
                  setState(() {
                    _showFilterPanel = false;
                    currentPage = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: GoogleFonts.urbanist(
                    color: tWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildTitle(bool isDark) => Text(
    'Devices',
    style: GoogleFonts.urbanist(
      fontSize: 20,
      color: isDark ? tWhite : tBlack,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _filterButton(bool isDark) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: tTransparent,
      border: Border.all(color: isDark ? tWhite : tBlack, width: 1),
    ),
    child: IconButton(
      onPressed: () {
        if (!mounted) return;
        setState(() => _showFilterPanel = !_showFilterPanel);
      },
      icon: SvgPicture.asset(
        'icons/filter.svg',
        width: 18,
        height: 18,
        color: isDark ? tWhite : tBlack,
      ),
    ),
  );

  Widget _addNewDeviceButton(bool isDark) => Container(
    height: 40,
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(color: isDark ? tWhite : tBlack),
    child: TextButton(
      onPressed: () {},
      child: Row(
        children: [
          SvgPicture.asset(
            'icons/device.svg',
            width: 18,
            height: 18,
            color: isDark ? tBlack : tWhite,
          ),
          SizedBox(width: 5),
          Text(
            'New Device',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: isDark ? tBlack : tWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildFilterBySearch(bool isDark) => Container(
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
      onChanged: (query) {},
    ),
  );

  Widget _buildFilterGroup({
    required String title,
    required List<String> items,
    required List<String> selectedItems,
    required Function(String) onTap,
    required bool isDark,
    required Color Function(String) colorResolver,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark ? tWhite : tBlack,
        ),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 6,
        children:
            items.map((item) {
              final selected = selectedItems.contains(item);
              return FilterChip(
                label: Text(item),
                selected: selected,
                onSelected: (_) => onTap(item),
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                selectedColor: colorResolver(item),
                checkmarkColor: tWhite,
                labelStyle: GoogleFonts.urbanist(
                  color: selected ? tWhite : (isDark ? tWhite : tBlack),
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
      ),
    ],
  );

  Widget _mapControlButton({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? tBlack : tWhite,
        border: Border.all(color: isDark ? tWhite : tBlack, width: 1),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: SvgPicture.asset(
          iconPath,
          width: 18,
          height: 18,
          color: isDark ? tWhite : tBlack,
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
      decoration: BoxDecoration(
        color: isDark ? tBlack : tWhite,
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            color: isDark ? tWhite.withOpacity(0.1) : tBlack.withOpacity(0.1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMEI + Vehicle + Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns status on top
            children: [
              /// IMEI + Vehicle box (fixed width)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250, // fixed width (adjust as you like)
                    decoration: BoxDecoration(
                      border: Border.all(color: statusColor, width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            // color: statusColor,
                            gradient: SweepGradient(
                              colors: [
                                statusColor,
                                statusColor.withOpacity(0.6),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            imei,
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? tBlack : tWhite,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'VEHICLE  - $vehicleNumber',
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? tWhite : tBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Tooltip(
                    message: 'Edit',
                    textStyle: GoogleFonts.urbanist(
                      color: isDark ? tBlack : tWhite,
                      fontSize: 11,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'icons/edit.svg',
                        width: 25,
                        height: 25,
                        color: tBlue,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 15),

              /// 🔹 Status container (top-aligned)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  // color: statusColor,
                  gradient: SweepGradient(
                    colors: [statusColor, statusColor.withOpacity(0.6)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? tBlack : tWhite,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(isDark, title: 'ODO', value: odo),
              _buildStatColumn(
                isDark,
                title: 'Fuel',
                value: fuel,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(isDark, title: 'Trips', value: trips),
              _buildStatColumn(
                isDark,
                title: 'ALERTS',
                value: alerts,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Divider(
            color: isDark ? tWhite.withOpacity(0.4) : tBlack.withOpacity(0.4),
            thickness: 0.3,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SvgPicture.asset(
                'icons/geofence.svg',
                width: 16,
                height: 16,
                color: tGreen,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Live Location : $location',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: isDark ? tWhite : tBlack,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    bool isDark, {
    required String title,
    required String value,
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? tWhite.withOpacity(0.6) : tBlack.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? tWhite : tBlack,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const Center(child: Text("Mobile / Tablet layout coming soon")),
      tablet: const Center(child: Text("Mobile / Tablet layout coming soon")),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTitle(isDark),
                Row(
                  children: [
                    _buildFilterBySearch(isDark),
                    const SizedBox(width: 6),
                    _filterButton(isDark),
                    const SizedBox(width: 6),
                    _addNewDeviceButton(isDark),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Column(
                            children:
                                paginatedDevices
                                    .map(
                                      (device) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 6,
                                        ),
                                        child: GestureDetector(
                                          // onTap: () {
                                          //   context.pushNamed(
                                          //     'deviceDetail',
                                          //     pathParameters: {
                                          //       'imei': device['imei'],
                                          //     },
                                          //     extra: device,
                                          //   );
                                          // },
                                          onTap:
                                              () => openDeviceOverview(
                                                context,
                                                device,
                                              ),
                                          child: buildDeviceCard(
                                            isDark: isDark,
                                            imei: device['imei'],
                                            vehicleNumber:
                                                device['vehicleNumber'],
                                            status: device['status'],
                                            fuel: device['fuel'],
                                            odo: device['odo'],
                                            trips: device['trips'],
                                            alerts: device['alerts'],
                                            location: device['location'],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        if (totalPages > 1)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              alignment: Alignment.center,
                              color: isDark ? tBlack : tWhite,
                              child: _buildPaginationControls(isDark),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(flex: 9, child: _buildClusterMap()),
                ],
              ),
            ),
          ],
        ),
        if (_showFilterPanel) _buildFilterPanel(isDark),
      ],
    );
  }
}
