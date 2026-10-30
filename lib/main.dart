import 'package:flutter/material.dart';

import 'data/mock_data.dart';
import 'screens/desktop_shell.dart';
import 'screens/login_screen.dart';
import 'screens/mobile/patient_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MediSaludApp());
}

class MediSaludApp extends StatefulWidget {
  const MediSaludApp({super.key});

  @override
  State<MediSaludApp> createState() => _MediSaludAppState();
}

class _MediSaludAppState extends State<MediSaludApp> {
  UserRole? _role;

  void _login(UserRole role) {
    setState(() => _role = role);
  }

  void _logout() {
    setState(() => _role = null);
  }

  @override
  Widget build(BuildContext context) {
    final role = _role;

    return MaterialApp(
      title: 'MediSalud · Gestión clínica',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: role == null
            ? LoginScreen(key: const ValueKey('login'), onLogin: _login)
            : role == UserRole.paciente
            ? PatientShell(key: const ValueKey('patient'), onLogout: _logout)
            : DesktopShell(
                key: ValueKey('desktop-${role.name}'),
                role: role,
                onLogout: _logout,
              ),
      ),
    );
  }
}
