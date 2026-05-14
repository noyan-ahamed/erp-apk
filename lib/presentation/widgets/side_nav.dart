import 'dart:convert';
import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/data/models/user_model.dart';
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
    final userJson = await TokenService.getUser();
    if (userJson != null) {
      currentUser = UserModel.fromJson(jsonDecode(userJson));
    }
    final savedRoles = await TokenService.getRoles();
    setState(() {
      roles = savedRoles;
      isLoading = false;
    });
  }

  bool isAdmin() => roles.contains("ADMIN");
  bool isEmployee() => roles.contains("EMPLOYEE");

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          _buildHeader(isDark),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                if (isAdmin()) ...[
                  _buildMenuItem(
                    icon: Icons.dashboard_outlined,
                    title: "Dashboard",
                    onTap: () => widget.onMenuSelect("dashboard"),
                    iconColor: Colors.indigoAccent,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel("MAIN MENU"),
                  _buildExpansionTile(
                    tileKey: "inventory",
                    icon: Icons.inventory_2_outlined,
                    title: "Inventory",
                    accentColor: Colors.orangeAccent,
                    children: [
                      _buildSubMenuItem("Product List", () => widget.onMenuSelect("products")),
                      _buildSubMenuItem("Categories", () => widget.onMenuSelect("category")),
                    ],
                  ),
                  _buildExpansionTile(
                    tileKey: "purchase",
                    icon: Icons.shopping_bag_outlined,
                    title: "Purchase",
                    accentColor: Colors.blueAccent,
                    children: [
                      _buildSubMenuItem("Suppliers", () => widget.onMenuSelect("suppliers")),
                      _buildSubMenuItem("Purchase Orders", () => widget.onMenuSelect("purchase")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel("EMPLOYEE MANAGEMENT"),
                  _buildExpansionTile(
                    tileKey: "employee_management",
                    icon: Icons.people_outline,
                    title: "HR Management",
                    accentColor: Colors.tealAccent,
                    children: [
                      _buildSubMenuItem("Department", () => widget.onMenuSelect("department")),
                      _buildSubMenuItem("Designation", () => widget.onMenuSelect("designation")),
                      _buildSubMenuItem("Employee", () => widget.onMenuSelect("employee")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel("FINANCE"),
                  _buildExpansionTile(
                    tileKey: "accounts",
                    icon: Icons.account_balance_wallet_outlined,
                    title: "Accounts",
                    accentColor: Colors.purpleAccent,
                    children: [
                      _buildSubMenuItem("Approve Payments", () => widget.onMenuSelect("approve_payments")),
                      _buildSubMenuItem("Supplier Ledger", () => widget.onMenuSelect("supplier_ledger")),
                      _buildSubMenuItem("Customer Ledger", () => widget.onMenuSelect("customer_ledger")),
                    ],
                  ),
                ],
                if (isEmployee()) ...[
                  _buildExpansionTile(
                    tileKey: "sales",
                    icon: Icons.point_of_sale_outlined,
                    title: "Sales",
                    accentColor: Colors.greenAccent,
                    children: [
                      _buildSubMenuItem("New Sale Entry", () => widget.onMenuSelect("new_sale")),
                      _buildSubMenuItem("Sales History", () => widget.onMenuSelect("sales_history")),
                      _buildSubMenuItem("Submit Payment", () => widget.onMenuSelect("submit_payment")),
                    ],
                  ),
                ],
                const Divider(height: 40, thickness: 0.5),
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: "My Profile",
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  iconColor: Colors.blueGrey,
                  onTap: () => widget.onMenuSelect("settings"),
                ),
                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  title: "Logout",
                  onTap: () => _handleLogout(context),
                  iconColor: Colors.redAccent,
                  textColor: Colors.redAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFF6366F1).withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: isDark ? Colors.indigo.withOpacity(0.3) : const Color(0xFFF1F5F9),
            backgroundImage: currentUser?.imageBase64 != null
                ? MemoryImage(base64Decode(currentUser!.imageBase64!))
                : null,
            child: currentUser?.imageBase64 == null
                ? Icon(Icons.person_outline_rounded, size: 30, color: isDark ? Colors.white : const Color(0xFF6366F1))
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: isLoading
                ? const LinearProgressIndicator()
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser?.name ?? "Unknown User",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  currentUser?.email ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
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
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.7), size: 22),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
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
      contentPadding: const EdgeInsets.only(left: 54),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required String tileKey,
    required IconData icon,
    required String title,
    required List<Widget> children,
    required Color accentColor,
  }) {
    final bool isExpanded = _expandedTile == tileKey;
    final primaryColor = const Color(0xFF6366F1);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: Key(tileKey + isExpanded.toString()),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) => _onExpansionChanged(tileKey, expanded),
        leading: Icon(icon, color: isExpanded ? primaryColor : accentColor.withOpacity(0.8), size: 22),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: isExpanded ? primaryColor : Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded,
          size: 18,
          color: isExpanded ? primaryColor : Colors.grey,
        ),
        children: children,
      ),
    );
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
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
          );
        }
      },
    );
  }
}