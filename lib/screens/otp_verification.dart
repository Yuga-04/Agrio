import 'package:flutter/material.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/farmer_spraying.png',
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
                    'We have sent a 4 digit OTP to +91*******10',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => const SizedBox(
                        width: 50,
                        child: TextField(
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Resend OTP in 29'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Mock resend
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Resend'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/registration');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('NEXT'),
                      ),
                    ],
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