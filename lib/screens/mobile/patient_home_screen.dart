import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  bool _medicationTaken = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const BrandMark(size: 34, showSubtitle: false),
                const Spacer(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SoftIconButton(
                      icon: Icons.notifications_none_rounded,
                      size: 38,
                      border: AppColors.border,
                      onTap: () => showAppSnack(
                        context,
                        'Tienes 2 notificaciones nuevas.',
                      ),
                    ),
                    Positioned(
                      right: 9,
                      top: 9,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 9),
                const AppAvatar(
                  initials: MockData.patientInitials,
                  size: 38,
                  color: AppColors.teal,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, ${MockData.patientFirstName}',
                        style: const TextStyle(
                          fontSize: 24,
                          height: 1.12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Tu salud, organizada y al día.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softBlue,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: AppColors.blue,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Vie 30 oct',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _NextAppointmentCard(onDetails: () => widget.onNavigate(1)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.add_circle_outline_rounded,
                    label: 'Agendar cita',
                    color: AppColors.blue,
                    onTap: () => widget.onNavigate(1),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.folder_shared_outlined,
                    label: 'Historial',
                    color: AppColors.teal,
                    onTap: () => widget.onNavigate(2),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.medication_outlined,
                    label: 'Recetas',
                    color: AppColors.green,
                    onTap: () => widget.onNavigate(3),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.payments_outlined,
                    label: 'Pagos',
                    color: AppColors.amber,
                    onTap: () => showAppSnack(
                      context,
                      'Próximamente podrás pagar tus consultas desde la app.',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _MedicationCard(
              taken: _medicationTaken,
              onToggle: () =>
                  setState(() => _medicationTaken = !_medicationTaken),
            ),
            const SizedBox(height: 22),
            SectionTitle(
              title: 'Especialidades',
              subtitle: 'Encuentra la atención que necesitas',
              action: TextButton(
                onPressed: () => widget.onNavigate(1),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Ver todas'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 128,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: MockData.mobileSpecialties.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final specialty = MockData.mobileSpecialties[index];
                  return SizedBox(
                    width: 164,
                    child: _SpecialtyCard(
                      specialty: specialty,
                      onTap: () => widget.onNavigate(1),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),
            const SectionTitle(
              title: 'Actividad reciente',
              subtitle: 'Novedades de tu atención',
            ),
            const SizedBox(height: 12),
            MediCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _ActivityRow(
                    icon: Icons.medication_outlined,
                    color: AppColors.green,
                    title: 'Receta lista para recoger',
                    subtitle: 'RX-2041 · Amoxicilina 500 mg',
                    time: 'Hoy · Farmacia sede Central',
                    onTap: () => widget.onNavigate(3),
                  ),
                  const DividerLine(),
                  _ActivityRow(
                    icon: Icons.science_outlined,
                    color: AppColors.teal,
                    title: 'Resultado de laboratorio',
                    subtitle: 'Hemograma completo · 14 sep',
                    time: 'Disponible para revisar',
                    onTap: () => widget.onNavigate(2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextAppointmentCard extends StatelessWidget {
  const _NextAppointmentCard({required this.onDetails});

  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.blue],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: -34,
              top: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              right: 26,
              bottom: -50,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.teal.withValues(alpha: 0.24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'PRÓXIMA CITA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Colors.white.withValues(alpha: 0.76),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 12,
                              color: Color(0xFF86EFAC),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Confirmada',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF86EFAC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Viernes, 30 de octubre',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: Color(0xFFA7C4FF),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '08:30 a. m. · Consultorio 2',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      const AppAvatar(
                        initials: 'CR',
                        size: 38,
                        color: Colors.white,
                        background: Colors.white,
                        textColor: AppColors.blue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dr. Carlos Ruiz',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Medicina general',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withValues(alpha: 0.62),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: onDetails,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Ver detalles',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            children: [
              IconBox(icon: icon, size: 34, color: color, radius: 10),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  const _MedicationCard({required this.taken, required this.onToggle});

  final bool taken;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return MediCard(
      color: taken ? AppColors.softGreen : AppColors.softAmber,
      borderColor: taken ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A),
      shadow: false,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          IconBox(
            icon: Icons.medication_outlined,
            size: 40,
            color: taken ? AppColors.green : const Color(0xFFB45309),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taken ? 'Medicamento tomado' : 'Recordatorio de medicación',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: taken ? AppColors.green : const Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Amoxicilina 500 mg · 1 cápsula',
                  style: TextStyle(
                    fontSize: 10.5,
                    color:
                        (taken
                                ? const Color(0xFF15803D)
                                : const Color(0xFF92400E))
                            .withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  'Programado para las 08:00 a. m.',
                  style: TextStyle(
                    fontSize: 9.5,
                    color:
                        (taken
                                ? const Color(0xFF15803D)
                                : const Color(0xFF92400E))
                            .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: taken ? AppColors.green : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: taken ? AppColors.green : const Color(0xFFF59E0B),
                ),
              ),
              child: Icon(
                taken ? Icons.check_rounded : Icons.check_outlined,
                size: 18,
                color: taken ? Colors.white : const Color(0xFFB45309),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialtyCard extends StatelessWidget {
  const _SpecialtyCard({required this.specialty, required this.onTap});

  final MobileSpecialty specialty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBox(
                    icon: specialty.icon,
                    size: 32,
                    color: specialty.color,
                    radius: 9,
                  ),
                  const Spacer(),
                  Text(
                    specialty.cost,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: specialty.color,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                specialty.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                specialty.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9.5,
                  height: 1.3,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              IconBox(icon: icon, size: 38, color: color),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 9.5,
                        color: AppColors.muted.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
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
