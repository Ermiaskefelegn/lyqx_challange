import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyqx_challange/core/di/injection.dart';
import 'package:lyqx_challange/core/services/secure_storage_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    final storage = getIt<SecureStorageService>();
    final token = await storage.read(key: 'access_token');

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (token != null && token.isNotEmpty) {
        context.go('/products');
      } else {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
