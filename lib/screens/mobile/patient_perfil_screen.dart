import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class PatientPerfilScreen extends StatefulWidget {
  const PatientPerfilScreen({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<PatientPerfilScreen> createState() => _PatientPerfilScreenState();
}

class _PatientPerfilScreenState extends State<PatientPerfilScreen> {
  bool _notifications = true;
  bool _medicationReminders = true;
  bool _emailResults = false;

  Future<void> _logout() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Cerrar sesión',
      message: '¿Deseas salir de tu cuenta de MediSalud?',
      confirmLabel: 'Cerrar sesión',
    );
    if (confirmed) widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mi perfil',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Gestiona tus datos y preferencias.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                SoftIconButton(
                  icon: Icons.settings_outlined,
                  size: 38,
                  onTap: () =>
                      showAppSnack(context, 'Configuración de la cuenta.'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _ProfileCard(),
            const SizedBox(height: 16),
            MediCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: SectionTitle(
                      title: 'Datos personales',
                      subtitle: 'Información registrada en tu ficha',
                      compact: true,
                    ),
                  ),
                  const DividerLine(),
                  const _DataRow(
                    icon: Icons.badge_outlined,
                    label: 'DNI',
                    value: '4587 ****',
                  ),
                  const _DataRow(
                    icon: Icons.cake_outlined,
                    label: 'Fecha de nacimiento',
                    value: '12 de mayo de 1992',
                  ),
                  const _DataRow(
                    icon: Icons.phone_outlined,
                    label: 'Teléfono',
                    value: MockData.patientPhone,
                  ),
                  const _DataRow(
                    icon: Icons.mail_outline_rounded,
                    label: 'Correo',
                    value: MockData.patientEmail,
                  ),
                  const _DataRow(
                    icon: Icons.home_outlined,
                    label: 'Dirección',
                    value: MockData.patientAddress,
                  ),
                  const _DataRow(
                    icon: Icons.health_and_safety_outlined,
                    label: 'Seguro',
                    value: 'Salud Total · Póliza 88421',
                    isLast: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => showAppSnack(
                          context,
                          'Solicitud de actualización de datos enviada.',
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Editar datos'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            MediCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: SectionTitle(
                      title: 'Preferencias',
                      subtitle: 'Elige cómo quieres recibir información',
                      compact: true,
                    ),
                  ),
                  _SwitchRow(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notificaciones',
                    description: 'Avisos de citas y recetas',
                    value: _notifications,
                    onChanged: (value) =>
                        setState(() => _notifications = value),
                  ),
                  _SwitchRow(
                    icon: Icons.alarm_outlined,
                    label: 'Recordatorios de medicación',
                    description: 'Alertas en el horario indicado',
                    value: _medicationReminders,
                    onChanged: (value) =>
                        setState(() => _medicationReminders = value),
                  ),
                  _SwitchRow(
                    icon: Icons.mail_outline_rounded,
                    label: 'Resultados por correo',
                    description: 'Recibe tus exámenes por email',
                    value: _emailResults,
                    onChanged: (value) => setState(() => _emailResults = value),
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            MediCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: SectionTitle(
                      title: 'Seguridad',
                      subtitle: 'Protege el acceso a tu cuenta',
                      compact: true,
                    ),
                  ),
                  _ActionRow(
                    icon: Icons.lock_outline_rounded,
                    label: 'Cambiar contraseña',
                    onTap: () => showAppSnack(
                      context,
                      'Enlace para cambiar contraseña enviado.',
                    ),
                  ),
                  _ActionRow(
                    icon: Icons.devices_outlined,
                    label: 'Sesiones activas',
                    onTap: () => showAppSnack(
                      context,
                      '1 sesión activa en este dispositivo.',
                    ),
                  ),
                  _ActionRow(
                    icon: Icons.verified_user_outlined,
                    label: 'Privacidad y datos',
                    onTap: () => showAppSnack(
                      context,
                      'Consulta la política de privacidad de MediSalud.',
                    ),
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  side: const BorderSide(color: Color(0xFFFECACA)),
                  backgroundColor: AppColors.softRed,
                ),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Cerrar sesión'),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                'MediSalud v1.0.0 · Acceso paciente',
                style: TextStyle(
                  fontSize: 9.5,
                  color: AppColors.muted.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.blue],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const AppAvatar(
              initials: MockData.patientInitials,
              size: 66,
              color: Colors.white,
              background: Colors.white,
              textColor: AppColors.blue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  MockData.patientName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  MockData.patientEmail,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            size: 11,
                            color: Color(0xFF86EFAC),
                          ),
                          const SizedBox(width: 4),
                          const Flexible(
                            child: Text(
                              'Paciente verificado',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF86EFAC),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'ID 4587',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.muted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.muted),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          IconBox(icon: icon, size: 34, color: AppColors.blue, radius: 9),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 9.5, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.blue,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : const Border(bottom: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 17, color: AppColors.muted),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
