import 'dart:convert';

import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/data/models/user_model.dart';
import 'package:enterprise_resource_planning/data/repositories/user_service.dart';
import 'package:enterprise_resource_planning/presentation/screens/login/login_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class SideNav extends StatefulWidget {
  final Function(String) onMenuSelect;

  const SideNav({super.key, required this.onMenuSelect});

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  // Track which tile is expanded
  String? _expandedTile;
  UserModel? currentUser;
  bool isLoading = true;
  List<String> roles = [];

  void _onExpansionChanged(String tileKey, bool isExpanded) {
    setState(() {
      if (isExpanded) {
        _expandedTile = tileKey;
      } else {
        if (_expandedTile == tileKey) {
          _expandedTile = null;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final userJson =
    await TokenService.getUser();

    if(userJson != null){

      currentUser =
          UserModel.fromJson(
            jsonDecode(userJson),
          );
    }
    final savedRoles = await TokenService.getRoles();

    setState(() {
      currentUser;
      roles = savedRoles;
      isLoading = false;
    });
  }

  bool isAdmin() => roles.contains("ADMIN");

  bool isEmployee() => roles.contains("EMPLOYEE");

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // 🔷 MINIMAL USER HEADER
          _buildHeader(),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),

              children: [
                if (isAdmin()) ...[
                _buildMenuItem(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  title: "Dashboard",
                  onTap: () => widget.onMenuSelect("dashboard"),
                ),

                const SizedBox(height: 20),
                _buildSectionLabel("MAIN MENU"),


                  _buildExpansionTile(
                    tileKey: "inventory",
                    icon: Icons.inventory_2_outlined,
                    title: "Inventory",
                    children: [
                      _buildSubMenuItem(
                        "Product List",
                        () => widget.onMenuSelect("products"),
                      ),
                      _buildSubMenuItem(
                        "Categories",
                        () => widget.onMenuSelect("category"),
                      ),
                    ],
                  ),

                _buildExpansionTile(
                  tileKey: "purchase",
                  icon: Icons.shopping_bag_outlined,
                  title: "Purchase",
                  children: [
                    _buildSubMenuItem(
                      "Suppliers",
                      () => widget.onMenuSelect("suppliers"),
                    ),
                    _buildSubMenuItem(
                      "Purchase Orders",
                      () => widget.onMenuSelect("purchase"),
                    ),
                  ],
                ),

                // employee management
                const SizedBox(height: 20),
                _buildSectionLabel("EMPLOYEE MANAGEMENT"),

                _buildExpansionTile(
                  tileKey: "employee_management",
                  icon: Icons.people_outline,
                  title: "Employee Management",
                  children: [
                    _buildSubMenuItem(
                      "Department",
                      () => widget.onMenuSelect("department"),
                    ),

                    _buildSubMenuItem(
                      "Designation",
                      () => widget.onMenuSelect("designation"),
                    ),

                    _buildSubMenuItem(
                      "Employee",
                      () => widget.onMenuSelect("employee"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                _buildSectionLabel("FINANCE"),

                _buildExpansionTile(
                  tileKey: "accounts",
                  icon: Icons.account_balance_wallet_outlined,
                  title: "Accounts",
                  children: [
                    _buildSubMenuItem("Approve Payments", () {}),
                    _buildSubMenuItem("Supplier Ledger", () {}),
                    _buildSubMenuItem("Customer Ledger", () {}),
                  ],
                ),
                ],


                //employee
                if(isEmployee())...[
                _buildExpansionTile(
                  tileKey: "sales",
                  icon: Icons.point_of_sale_outlined,
                  title: "Sales",
                  children: [
                    _buildSubMenuItem(
                      "New Sale Entry",
                          () => widget.onMenuSelect("new_sale"),
                    ),
                    _buildSubMenuItem(
                      "Sales History",
                          () => widget.onMenuSelect("sales_history"),
                    ),
                    _buildSubMenuItem(
                      "Submit Payment",
                          () => widget.onMenuSelect("submit_payment"),
                    ),
                  ],
                ),
                ],

                if(isEmployee() || isAdmin())...[
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: "My Profile",
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const ProfileScreen(),
                      ),
                    );
                  },
                ),
                ],



                const Divider(height: 40, thickness: 0.5),

                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () {},
                ),

                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  title: "Logout",
                  onTap: () => _handleLogout(context),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFF1F5F9),
              backgroundImage: currentUser?.imageBase64 != null
                  ? MemoryImage(base64Decode(currentUser!.imageBase64!))
                  : null,
              child: currentUser?.imageBase64 == null
                  ? const Icon(
                      Icons.person_outline_rounded,
                      size: 28,
                      color: Color(0xFF6366F1),
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.name ?? "Unknown User",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: const Color(0xFF1E293B),
                        ),
                      ),

                      Text(
                        currentUser?.email ?? "",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: const Color(0xFF94A3B8),
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    IconData? activeIcon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Icon(icon, color: color ?? const Color(0xFF475569), size: 22),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: color ?? const Color(0xFF1E293B),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSubMenuItem(String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      visualDensity: const VisualDensity(vertical: -3),
      contentPadding: const EdgeInsets.only(left: 48),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: const Color(0xFF64748B),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required String tileKey,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    final bool isExpanded = _expandedTile == tileKey;
    final Color color = isExpanded
        ? const Color(0xFF6366F1)
        : const Color(0xFF475569);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: Key(tileKey + isExpanded.toString()),
        // Force rebuild to update expansion state
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) =>
            _onExpansionChanged(tileKey, expanded),
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 14,
            fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: Icon(
          isExpanded
              ? Icons.keyboard_arrow_down_rounded
              : Icons.keyboard_arrow_right_rounded,
          size: 18,
          color: color,
        ),
        children: children,
      ),
    );
  }
}

void _handleLogout(BuildContext context) async {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    title: "Logout",
    text: "Are you sure you want to logout?",
    confirmBtnText: "Logout",
    cancelBtnText: "Cancel",
    onConfirmBtnTap: () async {
      await TokenService.clearAll();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    },
  );
}
