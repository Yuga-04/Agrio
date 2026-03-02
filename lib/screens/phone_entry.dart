import 'package:flutter/material.dart';

class PhoneEntryScreen extends StatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen> {
  bool _agreeToTerms = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/farmer_with_cow.png',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter your mobile number',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            // Placeholder for Indian flag icon (add Flutter SVG or image)
                            Icon(Icons.flag), // Replace with actual flag
                            SizedBox(width: 4),
                            Text('+91'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Enter your mobile number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CheckboxListTile(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                      'By continuing, you agree to our Terms & Conditions',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _agreeToTerms
                          ? () {
                              Navigator.pushNamed(context, '/otp');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('NEXT'),
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