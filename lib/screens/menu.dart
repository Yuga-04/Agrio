import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
        actions: [
          const Icon(Icons.favorite_border),
          const SizedBox(width: 16),
          const Icon(Icons.shopping_cart),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('User', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(leading: const Icon(Icons.person, color: Colors.green), title: const Text('User Profile')),
            ListTile(leading: const Icon(Icons.shopping_cart, color: Colors.green), title: const Text('My Orders')),
            ListTile(leading: const Icon(Icons.language, color: Colors.green), title: const Text('Change Language')),
            ListTile(leading: const Icon(Icons.star, color: Colors.green), title: const Text('Rate Us')),
            const Divider(),
            const ExpansionTile(
              leading: Icon(Icons.policy, color: Colors.green),
              title: Text('POLICIES & SUPPORT'),
              children: [
                ListTile(leading: Icon(Icons.shield, color: Colors.green), title: Text('Privacy Policy')),
                ListTile(leading: Icon(Icons.local_shipping, color: Colors.green), title: Text('Shipping & Delivery Policy')),
                ListTile(leading: Icon(Icons.cancel, color: Colors.green), title: Text('Cancellation Policy')),
                ListTile(leading: Icon(Icons.arrow_back, color: Colors.green), title: Text('Return Policy')),
                ListTile(leading: Icon(Icons.help, color: Colors.green), title: Text('Contact Us')),
              ],
            ),
            const Divider(),
            ListTile(leading: const Icon(Icons.exit_to_app, color: Colors.green), title: const Text('Sign Out')),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Kisan Vani'),
        ],
        currentIndex: 0, // Default
        selectedItemColor: Colors.green,
      ),
      body: const Center(child: Text('Main App Content Goes Here')), // Placeholder for home screen content
    );
  }
}