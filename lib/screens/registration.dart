import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const Icon(Icons.arrow_back),
        title: const Text('Uzhavar'),
        actions: [
          const Icon(Icons.people),
          const SizedBox(width: 16),
          const Text('தமிழ்'), // Tamil
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/ocean_background.png',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.green[100],
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'ONETIME REGISTRATION',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    enabled: false, // Pre-filled
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'District',
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('SELECT'),
                    items: const [], // Add real districts here, e.g., DropdownMenuItem(value: 'Chennai', child: Text('Chennai'))
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Block',
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('SELECT'),
                    items: const [],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Village',
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('SELECT'),
                    items: const [],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/menu');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('SUBMIT'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}