import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts.dart';
import '../../widgets/ui.dart';

class MedicosScreen extends StatelessWidget {
  const MedicosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Médicos',
            subtitle:
                'Consulta el equipo médico, especialidades y disponibilidad.',
            actions: [
              OutlinedButton.icon(
                onPressed: () =>
                    showAppSnack(context, 'Filtro de especialidades aplicado.'),
                icon: const Icon(Icons.filter_list_rounded, size: 18),
                label: const Text('Filtrar'),
              ),
              ElevatedButton.icon(
                onPressed: () => showAppSnack(
                  context,
                  'Formulario para registrar un nuevo médico.',
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nuevo médico'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900 ? 3 : 1;
              const spacing = 16.0;
              final width =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Médicos activos',
                      value: '48',
                      icon: Icons.badge_outlined,
                      color: AppColors.blue,
                      trend: '+3',
                      footnote: 'Incorporados este trimestre',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Especialidades',
                      value: '12',
                      icon: Icons.medical_services_outlined,
                      color: AppColors.teal,
                      trend: 'Completo',
                      trendNeutral: true,
                      footnote: 'Cobertura en todas las sedes',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Satisfacción',
                      value: '4.8 / 5',
                      icon: Icons.star_outline_rounded,
                      color: AppColors.amber,
                      trend: '+0.2',
                      footnote: 'Basado en 1,240 encuestas',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const SectionTitle(
            title: 'Equipo médico',
            subtitle: 'Disponibilidad y carga de pacientes por profesional',
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1180
                  ? 3
                  : constraints.maxWidth >= 720
                  ? 2
                  : 1;
              const spacing = 16.0;
              final width =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final doctor in MockData.doctors)
                    SizedBox(
                      width: width,
                      child: _DoctorCard(doctor: doctor),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              final coverage = MediCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Cobertura por especialidad',
                      subtitle: 'Pacientes atendidos en los últimos 30 días',
                      compact: true,
                    ),
                    const SizedBox(height: 18),
                    const HorizontalBars(
                      items: [
                        (
                          label: 'Medicina general',
                          value: 320,
                          color: AppColors.blue,
                        ),
                        (label: 'Pediatría', value: 240, color: AppColors.teal),
                        (
                          label: 'Cardiología',
                          value: 180,
                          color: AppColors.green,
                        ),
                        (
                          label: 'Dermatología',
                          value: 140,
                          color: AppColors.amber,
                        ),
                        (
                          label: 'Ginecología',
                          value: 110,
                          color: Color(0xFF7C3AED),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              final schedule = MediCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Disponibilidad de hoy',
                      subtitle: 'Turnos y consultorios asignados',
                      compact: true,
                    ),
                    const SizedBox(height: 16),
                    for (final doctor in MockData.doctors.take(4)) ...[
                      Row(
                        children: [
                          AppAvatar(
                            initials: doctor.initials,
                            size: 34,
                            color: doctor.color,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.name,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.text,
                                  ),
                                ),
                                Text(
                                  doctor.availability,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StatusBadge(status: doctor.status, compact: true),
                        ],
                      ),
                      if (doctor != MockData.doctors.take(4).last) ...[
                        const SizedBox(height: 10),
                        const DividerLine(),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ],
                ),
              );

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: coverage),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: schedule),
                  ],
                );
              }
              return Column(
                children: [coverage, const SizedBox(height: 16), schedule],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor});

  final DoctorRow doctor;

  @override
  Widget build(BuildContext context) {
    return MediCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                initials: doctor.initials,
                size: 48,
                color: doctor.color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: doctor.status, compact: true),
            ],
          ),
          const SizedBox(height: 16),
          const DividerLine(),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _DoctorMetric(
                  icon: Icons.people_alt_outlined,
                  value: '${doctor.patients}',
                  label: 'Pacientes',
                ),
              ),
              Container(width: 1, height: 28, color: AppColors.line),
              Expanded(
                child: _DoctorMetric(
                  icon: Icons.star_outline_rounded,
                  value: doctor.rating,
                  label: 'Valoración',
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F4EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    doctor.availability,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  showAppSnack(context, 'Agenda de ${doctor.name} abierta.'),
              icon: const Icon(Icons.calendar_month_outlined, size: 16),
              label: const Text('Ver agenda'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorMetric extends StatelessWidget {
  const _DoctorMetric({
    required this.icon,
    required this.value,
    required this.label,
    this.color = AppColors.blue,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.muted),
        ),
      ],
    );
  }
}
