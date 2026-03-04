import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF2E7D32)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                SizedBox(height: 10),
                Text(
                  'User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          _DrawerItem(
            icon: Icons.person_outline,
            label: 'User Profile',
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.shopping_bag_outlined,
            label: 'My Orders',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/orders');
            },
          ),
          _DrawerItem(
            icon: Icons.language_outlined,
            label: 'Change Language',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/language');
            },
          ),
          _DrawerItem(
            icon: Icons.star_outline,
            label: 'Rate Us',
            onTap: () => Navigator.pop(context),
          ),

          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
          const SizedBox(height: 4),

          // Policies expansion
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(
                Icons.policy_outlined,
                color: Color(0xFF2E7D32),
              ),
              title: const Text(
                'Policies & Support',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              iconColor: const Color(0xFF2E7D32),
              collapsedIconColor: const Color(0xFF888888),
              children: [
                _DrawerSubItem(
                  icon: Icons.shield_outlined,
                  label: 'Privacy Policy',
                ),
                _DrawerSubItem(
                  icon: Icons.local_shipping_outlined,
                  label: 'Shipping & Delivery Policy',
                ),
                _DrawerSubItem(
                  icon: Icons.cancel_outlined,
                  label: 'Cancellation Policy',
                ),
                _DrawerSubItem(
                  icon: Icons.assignment_return_outlined,
                  label: 'Return Policy',
                ),
                _DrawerSubItem(icon: Icons.help_outline, label: 'Contact Us'),
              ],
            ),
          ),

          const SizedBox(height: 4),
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
          const SizedBox(height: 4),

          _DrawerItem(
            icon: Icons.exit_to_app,
            label: 'Sign Out',
            color: Colors.redAccent,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/phone',
                (route) => false,
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF2E7D32);
    return ListTile(
      leading: Icon(icon, color: c, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color != null ? color : const Color(0xFF1A1A1A),
        ),
      ),
      onTap: onTap,
      dense: true,
      horizontalTitleGap: 8,
    );
  }
}

class _DrawerSubItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DrawerSubItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      leading: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
      title: Text(
        label,
        style: const TextStyle(fontSize: 13, color: Color(0xFF444444)),
      ),
      dense: true,
      horizontalTitleGap: 8,
      onTap: () => Navigator.pop(context),
    );
  }
}
