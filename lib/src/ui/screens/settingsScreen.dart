import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/appColors.dart';
import '../../utils/appResponsive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'My Profile',
    'Users CRUD',
    'API Key CRUD',
    'Device Commands CRUD',
  ];

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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Side Tab Menu ----
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Settings Menu',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? tWhite : tBlack,
                  ),
                ),
                const SizedBox(height: 10),
                ..._tabs.asMap().entries.map((entry) {
                  int index = entry.key;
                  String label = entry.value;
                  bool selected = _selectedTabIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => setState(() => _selectedTabIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selected
                                  ? (isDark
                                      ? tBlue.withOpacity(0.2)
                                      : tBlue.withOpacity(0.1))
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: selected ? tBlue : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getIconForTab(index),
                              color:
                                  selected
                                      ? tBlue
                                      : (isDark
                                          ? tWhite
                                          : tBlack.withOpacity(0.7)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              label,
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                fontWeight:
                                    selected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    selected
                                        ? tBlue
                                        : (isDark ? tWhite : tBlack),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),

          const SizedBox(width: 30),

          // ---- Content Area ----
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
              child: _buildTabContent(_selectedTabIndex, isDark),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Icon Picker ----
  IconData _getIconForTab(int index) {
    switch (index) {
      case 0:
        return Icons.person_outline;
      case 1:
        return Icons.group_outlined;
      case 2:
        return Icons.vpn_key_outlined;
      case 3:
        return Icons.developer_board_outlined;
      default:
        return Icons.settings;
    }
  }

  // ---- Content for each tab ----
  Widget _buildTabContent(int index, bool isDark) {
    switch (index) {
      case 0:
        return _buildProfileContent(isDark);
      case 1:
        return _buildUsersCrud(isDark);
      case 2:
        return _buildApiKeyCrud(isDark);
      case 3:
        return _buildDeviceCommands(isDark);
      default:
        return Container();
    }
  }

  Widget _buildProfileContent(bool isDark) {
    return _buildCardContent(
      title: "My Profile",
      subtitle: "Manage your personal details, password, and preferences.",
      color: tBlue,
      isDark: isDark,
    );
  }

  Widget _buildUsersCrud(bool isDark) {
    final List<Map<String, String>> users = [
      {"name": "Madhan Mohan", "email": "madhan@example.com", "role": "Admin"},
      {"name": "Aarav Patel", "email": "aarav@example.com", "role": "User"},
      {"name": "Ishita Rao", "email": "ishita@example.com", "role": "Manager"},
    ];

    return Container(
      key: const ValueKey("Users CRUD"),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Users Management",
                style: GoogleFonts.urbanist(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: tGreen,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddUserDialog(context, isDark),
                icon: const Icon(Icons.add),
                label: const Text("Add User"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search user...",
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Data Table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  isDark ? Colors.grey[800] : Colors.grey[200],
                ),
                columns: const [
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Role")),
                  DataColumn(label: Text("Actions")),
                ],
                rows:
                    users.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user["name"]!)),
                          DataCell(Text(user["email"]!)),
                          DataCell(Text(user["role"]!)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed:
                                      () => _showEditUserDialog(
                                        context,
                                        isDark,
                                        user["name"]!,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed:
                                      () => _showDeleteDialog(
                                        context,
                                        isDark,
                                        user["name"]!,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, bool isDark) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("Add New User"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Name", nameController, isDark),
                const SizedBox(height: 10),
                _buildTextField("Email", emailController, isDark),
                const SizedBox(height: 10),
                _buildTextField("Role", roleController, isDark),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: tGreen),
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void _showEditUserDialog(BuildContext context, bool isDark, String name) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text("Edit User: $name"),
            content: const Text("Editing functionality coming soon."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(BuildContext context, bool isDark, String name) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text("Delete $name?"),
            content: const Text("Are you sure you want to delete this user?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isDark,
  ) {
    return TextField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildApiKeyCrud(bool isDark) {
    final List<Map<String, String>> apiKeys = [
      {"name": "Primary Key", "key": "abcd1234efgh5678", "status": "Active"},
      {"name": "Testing Key", "key": "test9876demo5432", "status": "Inactive"},
      {"name": "Backup Key", "key": "backup1122safe9988", "status": "Active"},
    ];

    return Container(
      key: const ValueKey("API Key CRUD"),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "API Keys Management",
                style: GoogleFonts.urbanist(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: tOrange1,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddApiKeyDialog(context, isDark),
                icon: const Icon(Icons.add),
                label: const Text("Add API Key"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tOrange1,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search API Key...",
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Data Table
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  isDark ? Colors.grey[800] : Colors.grey[200],
                ),
                columns: const [
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("API Key")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Actions")),
                ],
                rows:
                    apiKeys.map((key) {
                      return DataRow(
                        cells: [
                          DataCell(Text(key["name"]!)),
                          DataCell(Text(key["key"]!)),
                          DataCell(
                            Text(
                              key["status"]!,
                              style: TextStyle(
                                color:
                                    key["status"] == "Active"
                                        ? Colors.green
                                        : Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed:
                                      () => _showEditApiKeyDialog(
                                        context,
                                        isDark,
                                        key["name"]!,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed:
                                      () => _showDeleteApiKeyDialog(
                                        context,
                                        isDark,
                                        key["name"]!,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddApiKeyDialog(BuildContext context, bool isDark) {
    final nameController = TextEditingController();
    final keyController = TextEditingController();
    final statusController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("Add API Key"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Name", nameController, isDark),
                const SizedBox(height: 10),
                _buildTextField("API Key", keyController, isDark),
                const SizedBox(height: 10),
                _buildTextField(
                  "Status (Active/Inactive)",
                  statusController,
                  isDark,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: tOrange1),
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void _showEditApiKeyDialog(BuildContext context, bool isDark, String name) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text("Edit API Key: $name"),
            content: const Text("Editing functionality coming soon."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  void _showDeleteApiKeyDialog(BuildContext context, bool isDark, String name) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text("Delete $name?"),
            content: const Text(
              "Are you sure you want to delete this API key?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  Widget _buildDeviceCommands(bool isDark) {
    final List<Map<String, String>> commands = [
      {"command": "Start Engine", "type": "Control", "status": "Success"},
      {"command": "Stop Engine", "type": "Control", "status": "Pending"},
      {"command": "Fetch Data", "type": "Request", "status": "Failed"},
    ];

    return Container(
      key: const ValueKey("Device Commands CRUD"),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Device Commands Management",
                style: GoogleFonts.urbanist(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: tRed,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddDeviceCommandDialog(context, isDark),
                icon: const Icon(Icons.add),
                label: const Text("Add Command"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search command...",
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Data Table
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  isDark ? Colors.grey[800] : Colors.grey[200],
                ),
                columns: const [
                  DataColumn(label: Text("Command")),
                  DataColumn(label: Text("Type")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Actions")),
                ],
                rows:
                    commands.map((cmd) {
                      return DataRow(
                        cells: [
                          DataCell(Text(cmd["command"]!)),
                          DataCell(Text(cmd["type"]!)),
                          DataCell(
                            Text(
                              cmd["status"]!,
                              style: TextStyle(
                                color:
                                    cmd["status"] == "Success"
                                        ? Colors.green
                                        : (cmd["status"] == "Pending"
                                            ? Colors.orange
                                            : Colors.redAccent),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed:
                                      () => _showEditCommandDialog(
                                        context,
                                        isDark,
                                        cmd["command"]!,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed:
                                      () => _showDeleteCommandDialog(
                                        context,
                                        isDark,
                                        cmd["command"]!,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDeviceCommandDialog(BuildContext context, bool isDark) {
    final commandController = TextEditingController();
    final typeController = TextEditingController();
    final statusController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("Add New Command"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Command", commandController, isDark),
                const SizedBox(height: 10),
                _buildTextField(
                  "Type (Control/Request)",
                  typeController,
                  isDark,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  "Status (Success/Pending/Failed)",
                  statusController,
                  isDark,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: tRed),
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void _showEditCommandDialog(
    BuildContext context,
    bool isDark,
    String command,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text("Edit Command: $command"),
            content: const Text("Editing functionality coming soon."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  void _showDeleteCommandDialog(
    BuildContext context,
    bool isDark,
    String command,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text("Delete $command?"),
            content: const Text(
              "Are you sure you want to delete this command?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  Widget _buildCardContent({
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      key: ValueKey(title),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Icon(
              Icons.settings_outlined,
              color: color.withOpacity(0.8),
              size: 100,
            ),
          ),
        ],
      ),
    );
  }
}
