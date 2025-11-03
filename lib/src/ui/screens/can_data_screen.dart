import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';
import 'package:tm_fleet_management/src/ui/screens/devicesScreen.dart';
import '../../utils/appColors.dart';

class CanDataScreen extends StatelessWidget {
  const CanDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dataList = [
      {'label': 'Fuel Capacity', 'value': '45 L'},
      {'label': 'Fuel Consumption', 'value': '5.4 L/100km'},
      {'label': 'Distance Travelled', 'value': '18,245 km'},
      {'label': 'Engine Temp', 'value': '92°C'},
      {'label': 'Engine Alerts', 'value': '2 Active'},
      {'label': 'Engine Number', 'value': 'ENGX9F3A1234567'},
      {'label': 'Chassis Number', 'value': 'MA3EYD32S00765432'},
    ];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔹 Left side: Title
              Text(
                'CAN Data',
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: isDark ? tWhite : tBlack,
                ),
              ),

              // 🔹 Right side: Device icon + Back button
              Row(
                children: [
                  // Device Icon
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DevicesScreen(),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      'icons/device.svg',
                      width: 24,
                      height: 24,
                      color: isDark ? tWhite : tBlack,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: isDark ? tWhite : tBlack,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Back',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? tWhite : tBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 🔹 Row with flex: 3:7 after heading
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔸 Left Section (flex: 3)
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? tWhite.withOpacity(0.03)
                              : tGrey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.separated(
                      itemCount: dataList.length,
                      separatorBuilder:
                          (_, __) => Divider(
                            color:
                                isDark
                                    ? tWhite.withOpacity(0.4)
                                    : tBlack.withOpacity(0.3),
                            thickness: 0.5,
                          ),
                      itemBuilder: (context, index) {
                        final item = dataList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Label
                              Text(
                                item['label']!,
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: isDark ? tWhite : tBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              // Value
                              Text(
                                item['value']!,
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: isDark ? tWhite : tBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 🔸 Right Section (flex: 7)
                Expanded(
                  flex: 7,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? tWhite.withOpacity(0.05)
                              : tBlack.withOpacity(0.05),
                    ),
                    child: const Center(
                      child: Text(
                        'Additional Details or Chart Placeholder',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
