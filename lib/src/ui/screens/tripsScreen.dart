import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tm_fleet_management/src/utils/appColors.dart';
import 'package:tm_fleet_management/src/utils/appResponsive.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  bool showTripDetails = false;
  bool showRouteMap = false;
  int? selectedTripIndex;

  final List<Map<String, dynamic>> trips = [
    {
      "tripName": "Trip 1",
      "vehicleId": "DLOC47747",
      "deviceId": "TRK-001",
      "tripState": "Completed",
      "imei": "123456789012345",
      "reportData": [
        {"label": "Start Time", "value": "4:52 am", "date": "22 Oct 2025"},
        {"label": "End Time", "value": "5:55 am", "date": "22 Oct 2025"},
        {"label": "Trip Time", "value": "63 mins"},
        {"label": "Start ODO ", "value": "178.6"},
        {"label": "End ODO ", "value": "194.4"},
        {"label": "Trip distance", "value": "15.8 Km"},
        {"label": "Average Speed", "value": "40 Km/hr"},
        {"label": "Maximum Speed", "value": "70 Km/hr"},
        {"label": "Mileage", "value": "19 km/l"},
        {"label": "Harsh Braking", "value": "1"},
        {"label": "Idle Time", "value": "5 mins"},
        {"label": "Fuel Consumed", "value": "1.2 L"},
      ],
      "startAddress":
          "MSI Road, RPM4+4GM, Badona, Madhya Pradesh 470001, India",
      "endAddress":
          "Bhopal road, RPM4+9G4, Badona, Madhya Pradesh 470001, India",
    },
    {
      "tripName": "Trip 2",
      "vehicleId": "DLOC47748",
      "deviceId": "TRK-002",
      "tripState": "Ongoing",
      "imei": "987654321012345",
      "reportData": [
        {"label": "Start Time", "value": "6:10 am", "date": "23 Oct 2025"},
        {"label": "End Time", "value": "—"},
        {"label": "Trip Time", "value": "35 mins"},
        {"label": "Start ODO ", "value": "194.4"},
        {"label": "End ODO ", "value": "—"},
        {"label": "Trip distance", "value": "8.5 Km"},
        {"label": "Average Speed", "value": "30 Km/hr"},
        {"label": "Maximum Speed", "value": "55 Km/hr"},
      ],
      "startAddress": "Basapura Road, Bangalore, Karnataka 560100, India",
      "endAddress": "—",
    },
    {
      "tripName": "Trip 3",
      "vehicleId": "DLOC47749",
      "deviceId": "TRK-003",
      "tripState": "Completed",
      "imei": "192837465091827",
      "reportData": [
        {"label": "Start Time", "value": "7:00 am", "date": "24 Oct 2025"},
        {"label": "End Time", "value": "7:45 am", "date": "24 Oct 2025"},
        {"label": "Trip Time", "value": "45 mins"},
        {"label": "Trip distance", "value": "10.3 Km"},
        {"label": "Average Speed", "value": "35 Km/hr"},
        {"label": "Maximum Speed", "value": "65 Km/hr"},
      ],
      "startAddress": "BTM Layout, Bangalore, Karnataka 560076, India",
      "endAddress": "JP Nagar, Bangalore, Karnataka 560078, India",
    },
    {
      "tripName": "Trip 4",
      "vehicleId": "DLOC47750",
      "deviceId": "TRK-004",
      "tripState": "Completed",
      "imei": "987654321013542",
      "reportData": [
        {"label": "Start Time", "value": "2:10 am", "date": "23 Oct 2025"},
        {"label": "End Time", "value": "4:10 am", "date": "23 Oct 2025"},
        {"label": "Trip Time", "value": "120 mins"},
        {"label": "Start ODO ", "value": "194.4"},
        {"label": "End ODO ", "value": "294.4"},
        {"label": "Trip distance", "value": "100 Km"},
        {"label": "Average Speed", "value": "30 Km/hr"},
        {"label": "Maximum Speed", "value": "55 Km/hr"},
        {"label": "Mileage", "value": "19 km/l"},
        {"label": "Harsh Braking", "value": "5"},
        {"label": "Idle Time", "value": "15 mins"},
        {"label": "Fuel Consumed", "value": "1.2 L"},
      ],
      "startAddress": "Basapura Road, Bangalore, Karnataka 560100, India",
      "endAddress": "JP Nagar, Bangalore, Karnataka 560078, India",
    },
  ];
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
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Add this heading here (before trips.map)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Trips",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),

            // 🔹 Your trips list
            ...trips.map((trip) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? tBlack : tWhite,
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Trip name + state
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            trip["tripName"],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? tWhite : tBlack1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  trip["tripState"] == "Completed"
                                      ? tGreenLight
                                      : tOrangeLight,
                            ),
                            child: Text(
                              trip["tripState"],
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color:
                                    trip["tripState"] == "Completed"
                                        ? tGreenDark
                                        : tOrange1,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // 🔹 Vehicle ID
                      Text(
                        "Vehicle ID: ${trip["vehicleId"]}",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDark ? tWhite : tBlack1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // 🔹 Summary chips (only 3)
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children:
                            trip["reportData"]
                                .take(3)
                                .map<Widget>(
                                  (item) => Chip(
                                    label: Text(
                                      "${item["label"]}: ${item["value"]}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    backgroundColor: isDark ? tBlack : tWhite,
                                  ),
                                )
                                .toList(),
                      ),

                      const SizedBox(height: 8),
                      Divider(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.6)
                                : Colors.black.withOpacity(0.6),
                      ),
                      const SizedBox(height: 8),

                      // 🔹 Addresses
                      Text(
                        "Start Address: ${trip["startAddress"]}",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDark ? tWhite : tBlack1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "End Address: ${trip["endAddress"]}",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDark ? tWhite : tBlack1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // 🔹 View Details button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: isDark ? tBlack : tWhite,
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  expand: false,
                                  minChildSize: 0.5,
                                  maxChildSize: 0.95,
                                  initialChildSize: 0.9,
                                  builder: (context, scrollController) {
                                    return SingleChildScrollView(
                                      controller: scrollController,
                                      child: TripDetailsSection(
                                        trip: trip,
                                        isDark: isDark,
                                        onClose: () => Navigator.pop(context),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: const Text("View Details"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() => Container();
  Widget _buildDesktopLayout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedTrip =
        selectedTripIndex != null ? trips[selectedTripIndex!] : null;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          // LEFT SIDE — Trip list
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Trips",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  ...trips.map((trip) {
                    int index = trips.indexOf(trip);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black87 : Colors.white70,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row (Vehicle ID + Status)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showTripDetails = true;
                                      selectedTripIndex = index;
                                    });
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Text(
                                      "${trip["tripName"]} • Vehicle ID: ${trip["vehicleId"]}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: isDark ? tWhite : tBlack1,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        trip["tripState"] == "Completed"
                                            ? tGreenLight
                                            : tOrangeLight,
                                  ),
                                  child: Text(
                                    trip["tripState"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          trip["tripState"] == "Completed"
                                              ? tGreenDark
                                              : tOrange1,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            Divider(
                              color:
                                  isDark
                                      ? tWhite.withOpacity(0.6)
                                      : tBlack.withOpacity(0.6),
                              thickness: 1,
                              height: 1,
                            ),
                            const SizedBox(height: 8),

                            // Short summary grid
                            GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              shrinkWrap: true,
                              childAspectRatio: 4,
                              physics: const NeverScrollableScrollPhysics(),
                              children:
                                  trip["reportData"]
                                      .take(8)
                                      .map<Widget>(
                                        (item) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              item["label"],
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    isDark ? tWhite : tBlack1,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  item["value"],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        isDark
                                                            ? tWhite
                                                            : tBlack1,
                                                  ),
                                                ),
                                                if (item["date"] != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 6,
                                                        ),
                                                    child: Text(
                                                      item["date"],
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            isDark
                                                                ? tWhite
                                                                    .withOpacity(
                                                                      0.6,
                                                                    )
                                                                : tBlack1
                                                                    .withOpacity(
                                                                      0.6,
                                                                    ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                            ),

                            const SizedBox(height: 8),
                            Divider(
                              color:
                                  isDark
                                      ? tWhite.withOpacity(0.6)
                                      : tBlack.withOpacity(0.6),
                              thickness: 1,
                              height: 1,
                            ),
                            const SizedBox(height: 8),

                            // Start and End addresses
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Start Address",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: isDark ? tWhite : tBlack1,
                                        ),
                                      ),
                                      Text(
                                        trip["startAddress"],
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: isDark ? tWhite : tBlack1,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "End Address",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: isDark ? tWhite : tBlack1,
                                        ),
                                      ),
                                      Text(
                                        trip["endAddress"],
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: isDark ? tWhite : tBlack1,
                                        ),
                                        textAlign: TextAlign.right,
                                        softWrap: true,
                                      ),
                                    ],
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
              ),
            ),
          ),

          // RIGHT SIDE — Trip details
          Expanded(
            flex: 3,
            child:
                showTripDetails && selectedTrip != null
                    ? TripDetailsSection(
                      trip: selectedTrip,
                      isDark: isDark,
                      onClose: () {
                        setState(() {
                          showTripDetails = false;
                          selectedTripIndex = null;
                        });
                      },
                    )
                    : const Center(
                      child: Text("Select a trip to view details"),
                    ),
          ),
        ],
      ),
    );
  }
}

class TripDetailsSection extends StatefulWidget {
  final Map<String, dynamic> trip;
  final bool isDark;
  final VoidCallback onClose;

  const TripDetailsSection({
    super.key,
    required this.trip,
    required this.isDark,
    required this.onClose,
  });

  @override
  State<TripDetailsSection> createState() => _TripDetailsSectionState();
}

class _TripDetailsSectionState extends State<TripDetailsSection> {
  bool showMap = false;

  VoidCallback? get onClose => null; // 🔹 initially hidden
  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final reportData = trip["reportData"] as List;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? tBlack : tWhite,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Trip Summary Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trip Summary",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? tWhite : tBlack1,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Vehicle ID: ${trip["vehicleId"]}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isDark ? tWhite : tBlack1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    color: Colors.grey[700],
                    onPressed: onClose,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 🔹 Device + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Device ID: ${trip["imei"]}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? tWhite : tBlack1,
                ),
              ),
              Text(
                trip["tripState"],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: trip["tripState"] == "Completed" ? tGreen : tOrange1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 🔹 Trip Summary Details
          for (int i = 0; i < reportData.length; i += 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Row(
                children: [
                  Expanded(child: buildSummaryItem(reportData[i])),
                  if (i + 1 < reportData.length) const SizedBox(width: 16),
                  if (i + 1 < reportData.length)
                    Expanded(child: buildSummaryItem(reportData[i + 1])),
                ],
              ),
            ),

          const SizedBox(height: 18),

          // 🔹 Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Download ${trip["tripName"]}')),
                    );
                  },
                  child: const Text("Download Trip"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      showMap = !showMap; // 🔹 toggle map visibility
                    });
                  },
                  child: Text(showMap ? "Hide Route" : "Route Playback"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 🔹 Conditionally show the map
          if (showMap)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(12.9716, 77.5946),
                    zoom: 10.0,
                  ),
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildSummaryItem(Map<String, String> item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item["label"]!,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: widget.isDark ? tWhite : tBlack1,
          ),
        ),
        Row(
          children: [
            Text(
              item["value"]!,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: widget.isDark ? tWhite : tBlack1,
              ),
            ),
            if (item["date"] != null && item["date"]!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  item["date"]!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color:
                        widget.isDark
                            ? tWhite.withOpacity(0.6)
                            : tBlack1.withOpacity(0.6),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
