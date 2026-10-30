import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../navigation.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts.dart';
import '../../widgets/ui.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onNavigate});

  final ValueChanged<DesktopSection> onNavigate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Panel de control',
            subtitle: 'Resumen de la actividad clínica de hoy, viernes 30 de octubre.',
            actions: [
              OutlinedButton.icon(
                onPressed: () => showAppSnack(
                  context,
                  'Mostrando indicadores del día de hoy.',
                ),
                icon: const Icon(Icons.today_outlined, size: 18),
                label: const Text('Hoy'),
              ),
              ElevatedButton.icon(
                onPressed: () => onNavigate(DesktopSection.citas),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nueva cita'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1150
                  ? 4
                  : constraints.maxWidth >= 680
                  ? 2
                  : 1;
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
                      label: 'Citas de hoy',
                      value: '24',
                      icon: Icons.calendar_month_outlined,
                      color: AppColors.blue,
                      trend: '+12%',
                      footnote: '6 en espera de atención',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Pacientes activos',
                      value: '1,248',
                      icon: Icons.people_alt_outlined,
                      color: AppColors.teal,
                      trend: '+4.6%',
                      footnote: '32 nuevos este mes',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Recetas pendientes',
                      value: '18',
                      icon: Icons.medication_outlined,
                      color: AppColors.amber,
                      trend: 'Estable',
                      trendNeutral: true,
                      footnote: '8 en preparación en farmacia',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Ingresos del día',
                      value: 'S/ 4,860',
                      icon: Icons.payments_outlined,
                      color: AppColors.green,
                      trend: '+8.2%',
                      footnote: '42 pagos registrados',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 980;
              final chart = MediCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(
                      title: 'Citas de la semana',
                      subtitle: 'Atenciones registradas por día',
                      action: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softBlue,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const Text(
                          'Esta semana',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const WeeklyBarChart(points: MockData.weekPoints),
                  ],
                ),
              );
              final donut = MediCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Por especialidad',
                      subtitle: 'Distribución de citas atendidas',
                    ),
                    const SizedBox(height: 20),
                    const SpecialtyDonut(data: MockData.specialties),
                  ],
                ),
              );

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: chart),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: donut),
                  ],
                );
              }
              return Column(
                children: [chart, const SizedBox(height: 16), donut],
              );
            },
          ),
          const SizedBox(height: 20),
          _AppointmentsCard(onNavigate: onNavigate),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.sync_rounded, size: 13, color: AppColors.muted),
              const SizedBox(width: 6),
              Text(
                'Datos actualizados hace 2 minutos · Fuente: API MediSalud',
                style: TextStyle(
                  fontSize: 10.5,
                  color: AppColors.muted.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppointmentsCard extends StatelessWidget {
  const _AppointmentsCard({required this.onNavigate});

  final ValueChanged<DesktopSection> onNavigate;

  @override
  Widget build(BuildContext context) {
    final items = MockData.appointments.take(5).toList();
    return MediCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 18, 16),
            child: SectionTitle(
              title: 'Próximas citas',
              subtitle: 'Agenda del día · 6 citas programadas',
              action: TextButton.icon(
                onPressed: () => onNavigate(DesktopSection.citas),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Ver agenda'),
              ),
            ),
          ),
          const DividerLine(),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 720) {
                return Column(
                  children: [
                    for (final appointment in items)
                      _CompactAppointmentRow(appointment: appointment),
                  ],
                );
              }
              return Column(
                children: [
                  const _AppointmentHeader(),
                  for (final appointment in items)
                    _AppointmentRow(appointment: appointment),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AppointmentHeader extends StatelessWidget {
  const _AppointmentHeader();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.7,
      color: AppColors.muted,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
      color: const Color(0xFFF7F4EE),
      child: const Row(
        children: [
          SizedBox(width: 70, child: Text('HORA', style: style)),
          Expanded(flex: 3, child: Text('PACIENTE', style: style)),
          Expanded(flex: 3, child: Text('MÉDICO', style: style)),
          SizedBox(width: 132, child: Text('ESTADO', style: style)),
          SizedBox(width: 24),
        ],
      ),
    );
  }
}

class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              appointment.time,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                AppAvatar(
                  initials: appointment.initials,
                  size: 34,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patient,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.room,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctor,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  appointment.specialty,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 132,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(status: appointment.status),
            ),
          ),
          const SizedBox(
            width: 24,
            child: Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactAppointmentRow extends StatelessWidget {
  const _CompactAppointmentRow({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AppAvatar(
                initials: appointment.initials,
                size: 38,
                color: AppColors.blue,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patient,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${appointment.doctor} · ${appointment.specialty}',
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: appointment.status, compact: true),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 14,
                color: AppColors.muted,
              ),
              const SizedBox(width: 5),
              Text(
                appointment.time,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.meeting_room_outlined,
                size: 14,
                color: AppColors.muted,
              ),
              const SizedBox(width: 5),
              Text(
                appointment.room,
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
