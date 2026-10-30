import 'package:flutter/material.dart';

import 'data/mock_data.dart';

enum DesktopSection {
  panel(
    'Panel de control',
    'Resumen general',
    Icons.grid_view_rounded,
    'PRINCIPAL',
  ),
  citas(
    'Agenda de citas',
    'Programación diaria',
    Icons.calendar_month_outlined,
    'PRINCIPAL',
  ),
  pacientes(
    'Pacientes',
    'Registro y seguimiento',
    Icons.people_alt_outlined,
    'GESTIÓN CLÍNICA',
  ),
  medicos(
    'Médicos',
    'Equipo y especialidades',
    Icons.badge_outlined,
    'GESTIÓN CLÍNICA',
  ),
  historias(
    'Historias clínicas',
    'Ficha del paciente',
    Icons.folder_shared_outlined,
    'GESTIÓN CLÍNICA',
  ),
  recetas(
    'Recetas y farmacia',
    'Dispensación e inventario',
    Icons.medication_outlined,
    'GESTIÓN CLÍNICA',
  ),
  pagos(
    'Pagos y facturación',
    'Cobros y comprobantes',
    Icons.payments_outlined,
    'ADMINISTRACIÓN',
  ),
  reportes(
    'Reportes',
    'Indicadores del negocio',
    Icons.insights_outlined,
    'ADMINISTRACIÓN',
  ),
  usuarios(
    'Usuarios y roles',
    'Accesos y permisos',
    Icons.manage_accounts_outlined,
    'ADMINISTRACIÓN',
  );

  const DesktopSection(this.label, this.subtitle, this.icon, this.group);

  final String label;
  final String subtitle;
  final IconData icon;
  final String group;

  bool allowedFor(UserRole role) {
    return switch (role) {
      UserRole.administrador => true,
      UserRole.medico => const {
        DesktopSection.panel,
        DesktopSection.citas,
        DesktopSection.pacientes,
        DesktopSection.historias,
        DesktopSection.recetas,
      }.contains(this),
      UserRole.recepcionista => const {
        DesktopSection.panel,
        DesktopSection.citas,
        DesktopSection.pacientes,
        DesktopSection.pagos,
      }.contains(this),
      UserRole.farmacia => const {
        DesktopSection.panel,
        DesktopSection.recetas,
        DesktopSection.reportes,
      }.contains(this),
      UserRole.paciente => false,
    };
  }
}
