import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Create an instance of the local authentication plugin
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Function to handle biometric authentication
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      // Check if the device can check biometrics
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        _showSnackBar('Biometric authentication is not available.');
        return;
      }

      // Trigger the authentication dialog
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint or face to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true, // Keep the dialog open on app backgrounding
          biometricOnly: true, // Only allow biometric auth, not PIN/Pattern
        ),
      );
    } on PlatformException catch (e) {
      print(e);
      _showSnackBar('An error occurred: ${e.message}');
      return;
    }

    if (!mounted) return;

    if (authenticated) {
      _showSnackBar('Authentication Successful!');
      context.pushNamed('/products');
    } else {
      _showSnackBar('Authentication Failed.');
    }
  }

  // Helper function to show a SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.grey[800]));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight,
            width: double.infinity,
            child: Image.asset('assets/images/background_image.png', fit: BoxFit.fill),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Top Image Section
              SizedBox(height: screenHeight * 0.3),

              // 2. Logo - Now a tappable button for biometrics
              GestureDetector(
                onTap: _authenticate, // Call the authentication function on tap
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEEB1),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF9D46C), width: 2),
                  ),
                  child: const Icon(
                    Icons.fingerprint, // Changed icon to fingerprint
                    color: Color(0xFFEAA900),
                    size: 32,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 3. Store Name
              const Text(
                'Fake Store',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
              ),

              // 4. Login Button
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.05),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF212121),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
