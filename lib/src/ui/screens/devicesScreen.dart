import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

import '../../utils/appColors.dart';
import '../../utils/appResponsive.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  String selectedFilter = "All Devices";
  // Map<String, dynamic>? selectedTrip;

  // Sample device data
  final List<Map<String, dynamic>> allDevices = List.generate(50, (index) {
    final statuses = ['Moving', 'Idle', 'Stopped', 'Disconnected'];
    final status = statuses[index % 4];
    // bool isOngoing = index.isEven;

    return {
      'vehicleNumber': 'VHN${1000 + index}',
      'status': status,
      'imei': '${125864725 + index * 5}',
      'iccid': '${156857246 + index * 3}',
      'odo': '${70 + index * 2}',
      'trips': '${55 + index}',
      'alerts': '${5 + index}',
      'location': '123 Main St, City ${index + 1}',
    };
  });
  List<Map<String, dynamic>> get filteredDevices {
    switch (selectedFilter) {
      case "Moving":
        return allDevices.where((t) => t['status'] == 'Moving').toList();
      case "Idle":
        return allDevices.where((t) => t['status'] == 'Idle').toList();
      case "Stopped":
        return allDevices.where((t) => t['status'] == 'Stopped').toList();
      case "Disconnected":
        return allDevices.where((t) => t['status'] == 'Disconnected').toList();
      default:
        return allDevices;
    }
  }

  // Add these state variables at the top of your State class:
  int currentPage = 1;
  int itemsPerPage = 12; // you can tweak this
  int get totalPages => (filteredDevices.length / itemsPerPage).ceil();

  List<Map<String, dynamic>> get paginatedDevices {
    final start = (currentPage - 1) * itemsPerPage;
    final end = start + itemsPerPage;
    return filteredDevices.sublist(
      start,
      end > filteredDevices.length ? filteredDevices.length : end,
    );
  }

  void _nextPage() {
    if (currentPage < totalPages) setState(() => currentPage++);
  }

  void _previousPage() {
    if (currentPage > 1) setState(() => currentPage--);
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
          const SizedBox(height: 10),
          _buildFilterBySearch(isDark),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? tWhite.withOpacity(0.1) : tGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSwapButton("All Devices", isDark),
                _buildSwapButton("Moving", isDark),
                _buildSwapButton("Idle", isDark),
                _buildSwapButton("Stopped", isDark),
                _buildSwapButton("Disconnected", isDark),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:
                    filteredDevices.map((device) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 5,
                        ),
                        child: buildDeviceCard(
                          isDark: isDark,
                          imei: device['imei'],
                          vehicleNumber: device['vehicleNumber'],
                          status: device['status'],
                          iccid: device['iccid'],
                          odo: device['odo'],
                          trips: device['trips'],
                          alerts: device['alerts'],
                          location: device['location'],
                        ),
                      );
                    }).toList(),
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
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildTitle(isDark), _buildFilterBySearch(isDark)],
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? tWhite.withOpacity(0.1) : tGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSwapButton("All Devices", isDark),
                _buildSwapButton("Moving", isDark),
                _buildSwapButton("Idle", isDark),
                _buildSwapButton("Stopped", isDark),
                _buildSwapButton("Disconnected", isDark),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:
                    filteredDevices
                        .map(
                          (device) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 5,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (device['status'] == 'Completed') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => DevicesDetailScreen(
                                            device: device,
                                          ),
                                    ),
                                  );
                                }
                              },
                              child: buildDeviceCard(
                                isDark: isDark,
                                imei: device['imei'],
                                vehicleNumber: device['vehicleNumber'],
                                status: device['status'],
                                iccid: device['iccid'],
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
          ),
        ],
      ),
    );
  }

  // Widget _buildDesktopLayout() {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [_buildTitle(isDark), _buildFilterBySearch(isDark)],
  //       ),
  //       const SizedBox(height: 10),
  //       Expanded(
  //         child: Row(
  //           children: [
  //             Expanded(
  //               flex: 4,
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //                 child: Column(
  //                   children: [
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 6,
  //                         vertical: 6,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color:
  //                             isDark
  //                                 ? tWhite.withOpacity(0.1)
  //                                 : tGrey.withOpacity(0.1),
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           _buildSwapButton("All Trips", isDark),
  //                           _buildSwapButton("Ongoing", isDark),
  //                           _buildSwapButton("Completed", isDark),
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     Expanded(
  //                       child: SingleChildScrollView(
  //                         child: Column(
  //                           children:
  //                               filteredTrips
  //                                   .map(
  //                                     (trip) => Padding(
  //                                       padding: const EdgeInsets.symmetric(
  //                                         horizontal: 10.0,
  //                                         vertical: 5,
  //                                       ),
  //                                       child: GestureDetector(
  //                                         onTap: () {
  //                                           if (trip['status'] == 'Completed') {
  //                                             setState(() {
  //                                               selectedTrip = trip;
  //                                             });
  //                                           }
  //                                         },
  //                                         child: buildTripCard(
  //                                           isDark: isDark,
  //                                           tripNumber: trip['tripNumber'],
  //                                           truckNumber: trip['truckNumber'],
  //                                           status: trip['status'],
  //                                           startTime: trip['startTime'],
  //                                           endTime: trip['endTime'],
  //                                           durationMins: trip['durationMins'],
  //                                           distanceKm: trip['distanceKm'],
  //                                           maxSpeed: trip['maxSpeed'],
  //                                           avgSpeed: trip['avgSpeed'],
  //                                           source: trip['source'],
  //                                           destination: trip['destination'],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   )
  //                                   .toList(),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Expanded(
  //               flex: 7,
  //               child: Container(
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   color:
  //                       isDark
  //                           ? tWhite.withOpacity(0.05)
  //                           : tGrey.withOpacity(0.05),
  //                 ),
  //                 child:
  //                     selectedTrip == null
  //                         ? Center(
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               SvgPicture.asset(
  //                                 'images/no_details.svg',
  //                                 width: 200,
  //                                 height: 200,
  //                               ),
  //                               const SizedBox(height: 10),
  //                               Text(
  //                                 "Select a Completed Trip to view details",
  //                                 style: GoogleFonts.urbanist(
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: isDark ? tWhite : tBlack,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         )
  //                         : _buildTripDetailsView(selectedTrip!, isDark),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildDesktopLayout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildTitle(isDark), _buildFilterBySearch(isDark)],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            children: [
              // LEFT PANEL (Device Grid)
              Expanded(
                flex: 3, // shrink grid when trip selected
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      // Filter buttons
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? tWhite.withOpacity(0.1)
                                  : tGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSwapButton("All Devices", isDark),
                            _buildSwapButton("Moving", isDark),
                            _buildSwapButton("Idle", isDark),
                            _buildSwapButton("Stopped", isDark),
                            _buildSwapButton("Disconnected", isDark),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Trips Grid
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                // crossAxisCount:
                                //     selectedTrip == null
                                //         ? 4
                                //         : 2,
                                // // 4 → no selection, 2 → detail open
                                crossAxisCount: 1,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 2.3,
                              ),
                          itemCount: paginatedDevices.length,
                          itemBuilder: (context, index) {
                            final device = paginatedDevices[index];
                            return GestureDetector(
                              onTap: () {
                                // if (trip['status'] == 'Completed') {
                                //   setState(() {
                                //     selectedTrip = trip;
                                //   });
                                // }
                              },
                              child: buildDeviceCard(
                                isDark: isDark,
                                imei: device['imei'],
                                vehicleNumber: device['vehicleNumber'],
                                status: device['status'],
                                iccid: device['iccid'],
                                odo: device['odo'],
                                trips: device['trips'],
                                alerts: device['alerts'],
                                location: device['location'],
                              ),
                            );
                          },
                        ),
                      ),

                      // Pagination controls
                      if (totalPages > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 18,
                                ),
                                onPressed: _previousPage,
                              ),
                              Text(
                                "Page $currentPage of $totalPages",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: isDark ? tWhite : tBlack,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                ),
                                onPressed: _nextPage,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // RIGHT PANEL (Trip Details)
              // if (selectedTrip != null)
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? tWhite.withOpacity(0.05)
                            : tGrey.withOpacity(0.05),
                  ),
                  // child: _buildTripDetailsView(selectedTrip!, isDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(bool isDark) => Text(
    'Devices',
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
        Row(
          children: [
            // 🔍 Search box
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

            const SizedBox(width: 10),

            // 🎚️ Filter Icon
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // TODO: Add filter logic here
                print("Filter icon clicked");
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tTransparent,
                  border: Border.all(color: isDark ? tWhite : tBlack, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.filter_list,
                  size: 18,
                  color: isDark ? tWhite : tBlack,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        // Note text
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

  // Widget _buildSwapButton(String label, bool isDark) {
  //   final bool isSelected = selectedFilter == label;
  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: () {
  //         setState(() {
  //           selectedFilter = label;
  //         });
  //       },
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 4),
  //         padding: const EdgeInsets.symmetric(vertical: 8),
  //         decoration: BoxDecoration(
  //           color: isSelected ? (isDark ? tWhite : tBlack) : tTransparent,
  //           borderRadius: BorderRadius.circular(10),
  //           border: Border.all(color: isDark ? tWhite : tBlack, width: 1),
  //         ),
  //         alignment: Alignment.center,
  //         child: Text(
  //           label,
  //           style: GoogleFonts.urbanist(
  //             fontSize: 13,
  //             fontWeight: FontWeight.w600,
  //             color:
  //                 isSelected
  //                     ? (isDark ? tBlack : tWhite)
  //                     : (isDark ? tWhite : tBlack),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSwapButton(String label, bool isDark) {
    // 🎨 Define color based on label
    Color getFilterColor(String label) {
      switch (label.toLowerCase()) {
        case 'moving':
          return tGreen;
        case 'idle':
          return tOrange1;
        case 'stopped':
          return tBlue;
        case 'disconnected':
          return tRed;
        default:
          return isDark ? tWhite : tBlack; // default: All Devices
      }
    }

    final bool isSelected = selectedFilter == label;
    final Color filterColor = getFilterColor(label);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? filterColor : tTransparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: filterColor, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? (isDark ? tBlack : tWhite) : filterColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeviceCard({
    required bool isDark,
    required String vehicleNumber,
    required String status,
    required String imei,
    required String iccid,
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
        statusColor = tBlue;
        break;
      case 'disconnected':
        statusColor = tRed;
        break;
      default:
        statusColor = isDark ? tWhite : tBlack;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black12,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // ✅ Clickable IMEI + Vehicle Number box
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.push('/home/devices/device_detail');
                  },
                  child: Container(
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
                            color: statusColor,
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
                            'VEHICLE - $vehicleNumber',
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
                ),
              ),

              const SizedBox(width: 15),

              // ✅ Status box
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
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
                  const SizedBox(height: 5),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ✅ ICCID & ODO Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(isDark, title: 'ICCID', value: iccid),
              _buildStatColumn(
                isDark,
                title: 'ODO',
                value: odo,
                alignEnd: true,
              ),
            ],
          ),

          const SizedBox(height: 5),

          // ✅ Trips & Alerts Row
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

          // ✅ Live Location
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/geofence.svg',
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

  Widget _buildDevicesDetailsView(Map<String, dynamic> device, bool isDark) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? tWhite.withOpacity(0.05) : tWhite,
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.4)
                    : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Title + Close)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Device ${device['vehicleNumber']} Details",
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? tWhite : tBlack,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    // selectedTrip = null;
                  });
                },
                icon: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: isDark ? tRed : Colors.redAccent,
                  size: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(
            color: isDark ? tWhite.withOpacity(0.2) : tBlack.withOpacity(0.1),
            thickness: 0.5,
          ),
          const SizedBox(height: 12),

          // Trip Info Grid
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isDark ? tWhite.withOpacity(0.05) : tGrey.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 8,
                childAspectRatio: 4.5,
                children: [
                  _buildDetailTile(
                    "Vehicle Number",
                    device['vehicleNumber'],
                    isDark,
                  ),
                  _buildDetailTile("Status", device['status'], isDark),
                  _buildDetailTile("Live Location", device['location'], isDark),
                  _buildDetailTile("IMEI", device['imei'], isDark),
                  _buildDetailTile("ICCID", device['iccid'], isDark),
                  _buildDetailTile("ODO", device['odo'], isDark),
                  _buildDetailTile("Trips", device['trips'], isDark),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildStyledDetailButton(
                "Download Trip",
                CupertinoIcons.cloud_download,
                isDark,
              ),
              const SizedBox(width: 10),
              _buildStyledDetailButton(
                "Route Playback",
                CupertinoIcons.play_arrow_solid,
                isDark,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Map placeholder
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    isDark ? tWhite.withOpacity(0.08) : tGrey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isDark
                          ? tWhite.withOpacity(0.1)
                          : tBlack.withOpacity(0.1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "Map View Here",
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? tWhite.withOpacity(0.9) : tBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Improved info tile for grid layout
  Widget _buildDetailTile(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? tWhite.withOpacity(0.7) : tBlack.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? tWhite : tBlack,
          ),
        ),
      ],
    );
  }

  // Modern elevated action buttons
  Widget _buildStyledDetailButton(String text, IconData icon, bool isDark) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16, color: tBlue),
      label: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: tBlue,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? tBlack : tWhite,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: tBlue, width: 1),
        ),
        elevation: 3,
      ),
    );
  }
}

// ---------------- INLINE DETAIL SCREEN (MOBILE/TABLET) ----------------
class DevicesDetailScreen extends StatelessWidget {
  final Map<String, dynamic> device;
  const DevicesDetailScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text('Trip ${device['tripNumber']} Details')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.cloud_download, size: 16),
                  label: const Text("Download Trip"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.play_arrow_solid, size: 16),
                  label: const Text("Route Playback"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                color:
                    isDark ? tWhite.withOpacity(0.08) : tGrey.withOpacity(0.08),
                alignment: Alignment.center,
                child: Text(
                  "Map View Here",
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? tWhite : tBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
