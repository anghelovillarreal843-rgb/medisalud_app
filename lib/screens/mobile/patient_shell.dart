import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'agendar_cita_screen.dart';
import 'patient_historial_screen.dart';
import 'patient_home_screen.dart';
import 'patient_perfil_screen.dart';
import 'patient_recetas_screen.dart';

class PatientShell extends StatefulWidget {
  const PatientShell({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends State<PatientShell> {
  int _index = 0;

  void _select(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      PatientHomeScreen(onNavigate: _select),
      const AgendarCitaScreen(),
      const PatientHistorialScreen(),
      const PatientRecetasScreen(),
      PatientPerfilScreen(onLogout: widget.onLogout),
    ];

    final app = Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _PatientBottomNav(index: _index, onSelect: _select),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 640) return app;

        final height = math.min(constraints.maxHeight - 40, 900.0);
        return Container(
          color: const Color(0xFFE8EEF8),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppShadows.card,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone_iphone_rounded,
                      size: 14,
                      color: AppColors.blue,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Vista móvil del paciente',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 420,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(38),
                  border: Border.all(color: Colors.white, width: 7),
                  boxShadow: AppShadows.floating,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(31),
                  child: app,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PatientBottomNav extends StatelessWidget {
  const _PatientBottomNav({required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Inicio'),
    (Icons.calendar_month_outlined, Icons.calendar_month_rounded, 'Citas'),
    (Icons.folder_shared_outlined, Icons.folder_shared_rounded, 'Historial'),
    (Icons.medication_outlined, Icons.medication_rounded, 'Recetas'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: _items[i].$1,
                    activeIcon: _items[i].$2,
                    label: _items[i].$3,
                    selected: i == index,
                    badge: i == 3 ? 2 : null,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 42,
                  height: 28,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.softBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    selected ? activeIcon : icon,
                    size: 21,
                    color: selected ? AppColors.blue : AppColors.muted,
                  ),
                ),
                if (badge != null)
                  Positioned(
                    right: 6,
                    top: -2,
                    child: Container(
                      width: 15,
                      height: 15,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.blue : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
