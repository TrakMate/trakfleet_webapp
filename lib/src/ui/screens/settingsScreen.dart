import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../utils/appColors.dart';
import '../../utils/appResponsive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> _tabs = [
    'My Profile',
    'Users',
    'Groups',
    'API Key',
    'Commands',
  ];

  int selectedIndex = 0; // <-- Added selected index

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(isDark),
    );
  }

  Widget _buildMobileLayout() =>
      const Center(child: Text("Mobile Layout Coming Soon"));

  Widget _buildTabletLayout() =>
      const Center(child: Text("Tablet Layout Coming Soon"));

  Widget _buildDesktopLayout(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs Row
        Container(
          height: 50,
          width: 650,
          decoration: BoxDecoration(
            color: tTransparent,
            border: Border.all(width: 0.5, color: isDark ? tWhite : tBlack),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: List.generate(
              _tabs.length,
              (index) => _buildTabButton(
                _tabs[index],
                index,
                () => setState(() => selectedIndex = index),
                isDark,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // 🔹 Tab Content
        Expanded(child: _buildTabContent(selectedIndex, isDark)),
      ],
    );
  }

  // 🔹 Returns widget for selected tab
  Widget _buildTabContent(int index, bool isDark) {
    switch (index) {
      case 0:
        return _buildMyProfile(isDark);
      case 1:
        return const Center(child: Text("Users Content"));
      case 2:
        return const Center(child: Text("Groups Content"));
      case 3:
        return const Center(child: Text("API Key Content"));
      case 4:
        return const Center(child: Text("Device Commands Content"));
      default:
        return const SizedBox();
    }
  }

  // 🔹 Tab Button Builder
  Widget _buildTabButton(
    String label,
    int index,
    VoidCallback onTap,
    bool isDark,
  ) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: TextButton(
        onPressed: onTap,
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
        ),
      ),
    );
  }

  Widget _buildMyProfile(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: isDark ? tWhite : tBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Profile Box
            Container(
              decoration: BoxDecoration(
                color: tTransparent,
                border: Border.all(width: 0.8, color: tBlue),
              ),
              padding: EdgeInsets.all(6),
              child: Container(
                width: 150,
                height: 159,
                decoration: BoxDecoration(color: tBlue),
              ),
            ),

            SizedBox(width: 10),

            // Divider
            SizedBox(
              height: 159,
              child: VerticalDivider(
                color: isDark ? tWhite : tBlack,
                thickness: 1,
              ),
            ),

            SizedBox(width: 10),

            // Profile Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("Name", "BAXY", isDark),
                SizedBox(height: 12),

                _buildDetailRow("Mail ID", "baxy.team@gmail.com", isDark),
                SizedBox(height: 12),

                _buildDetailRow("Phone Number", "+91 727626", isDark),
                SizedBox(height: 12),

                _buildDetailRow("Role", "Admin", isDark),
                SizedBox(height: 12),

                _buildDetailRow("Organization", "BAXY Corp", isDark),
              ],
            ),
          ],
        ),

        SizedBox(height: 20),

        // 🔹 Professional Note Container
        Container(
          decoration: BoxDecoration(
            color: tRedDark.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            'To update your login credentials, modify the username and password in the fields below.',
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: tRedDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(height: 15),

        // 🔹 Username Field
        _buildEditableField("Username", "baxy.admin", isDark),

        SizedBox(height: 12),

        // 🔹 Password Field
        _buildEditableField("Password", "********", isDark),

        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: isDark ? tWhite : tBlack,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? tWhite : tBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, String value, bool isDark) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? tWhite : tBlack,
            ),
          ),
        ),

        Container(
          width: 250,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isDark ? tWhite.withOpacity(0.4) : tBlack.withOpacity(0.6),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: isDark ? tWhite : tBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: open edit dialog
                },
                child: SvgPicture.asset(
                  "assets/icons/edit.svg",
                  width: 18,
                  height: 18,
                  color: isDark ? tWhite : tBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
