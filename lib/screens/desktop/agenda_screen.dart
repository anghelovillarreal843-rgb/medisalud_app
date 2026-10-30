import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  int _selectedDay = 0;
  String _doctor = 'Todos los médicos';
  String _specialty = 'Todas las especialidades';
  String _view = 'Día';

  static const _days = [
    ('Vie', '30', 'Oct'),
    ('Sáb', '31', 'Oct'),
    ('Dom', '01', 'Nov'),
    ('Lun', '02', 'Nov'),
    ('Mar', '03', 'Nov'),
    ('Mié', '04', 'Nov'),
    ('Jue', '05', 'Nov'),
  ];

  static const _doctors = [
    'Todos los médicos',
    'Dr. Carlos Ruiz',
    'Dra. Elena Paredes',
    'Dra. Sofía Vega',
    'Dr. Marco León',
  ];

  static const _specialties = [
    'Todas las especialidades',
    'Medicina general',
    'Cardiología',
    'Pediatría',
    'Dermatología',
  ];

  List<Appointment> get _visibleAppointments {
    return MockData.appointments.where((appointment) {
      final doctorMatch =
          _doctor == 'Todos los médicos' || appointment.doctor == _doctor;
      final specialtyMatch =
          _specialty == 'Todas las especialidades' ||
          appointment.specialty == _specialty;
      return doctorMatch && specialtyMatch;
    }).toList();
  }

  void _openNewAppointment() {
    showDialog<void>(
      context: context,
      builder: (context) => const _NewAppointmentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointments = _visibleAppointments;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Agenda de citas',
            subtitle: 'Organiza la programación diaria y da seguimiento a cada paciente.',
            actions: [
              OutlinedButton.icon(
                onPressed: () => setState(() => _selectedDay = 0),
                icon: const Icon(Icons.today_outlined, size: 18),
                label: const Text('Hoy'),
              ),
              ElevatedButton.icon(
                onPressed: _openNewAppointment,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nueva cita'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _FilterBar(
            doctor: _doctor,
            specialty: _specialty,
            view: _view,
            doctors: _doctors,
            specialties: _specialties,
            onDoctor: (value) => setState(() => _doctor = value),
            onSpecialty: (value) => setState(() => _specialty = value),
            onView: (value) => setState(() => _view = value),
          ),
          const SizedBox(height: 16),
          _DateStrip(
            days: _days,
            selected: _selectedDay,
            onSelect: (index) => setState(() => _selectedDay = index),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1000;
              final schedule = _ScheduleCard(
                appointments: appointments,
                dayLabel: _selectedDay == 0
                    ? 'Viernes, 30 de octubre de 2026'
                    : '${_days[_selectedDay].$1}, ${_days[_selectedDay].$2} de ${_days[_selectedDay].$3.toLowerCase()} de 2026',
              );
              final summary = _AgendaSummary(
                onNewAppointment: _openNewAppointment,
              );

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: schedule),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: summary),
                  ],
                );
              }
              return Column(
                children: [schedule, const SizedBox(height: 16), summary],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.doctor,
    required this.specialty,
    required this.view,
    required this.doctors,
    required this.specialties,
    required this.onDoctor,
    required this.onSpecialty,
    required this.onView,
  });

  final String doctor;
  final String specialty;
  final String view;
  final List<String> doctors;
  final List<String> specialties;
  final ValueChanged<String> onDoctor;
  final ValueChanged<String> onSpecialty;
  final ValueChanged<String> onView;

  @override
  Widget build(BuildContext context) {
    return MediCard(
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final filters = [
            SizedBox(
              width: compact ? constraints.maxWidth : 240,
              child: _FilterDropdown(
                icon: Icons.badge_outlined,
                value: doctor,
                items: doctors,
                onChanged: onDoctor,
              ),
            ),
            SizedBox(
              width: compact ? constraints.maxWidth : 240,
              child: _FilterDropdown(
                icon: Icons.medical_services_outlined,
                value: specialty,
                items: specialties,
                onChanged: onSpecialty,
              ),
            ),
            _ViewToggle(value: view, onChanged: onView),
          ];

          if (compact) {
            return Column(
              children: [
                for (var i = 0; i < filters.length; i++) ...[
                  filters[i],
                  if (i != filters.length - 1) const SizedBox(height: 10),
                ],
              ],
            );
          }

          return Row(
            children: [
              filters[0],
              const SizedBox(width: 10),
              filters[1],
              const Spacer(),
              filters[2],
            ],
          );
        },
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4EE),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.muted),
          const SizedBox(width: 9),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.muted,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
                borderRadius: BorderRadius.circular(12),
                items: [
                  for (final item in items)
                    DropdownMenuItem(
                      value: item,
                      child: Text(item, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.softSlate,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in ['Día', 'Semana'])
            GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: value == option ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: value == option ? AppShadows.card : null,
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: value == option ? AppColors.navy : AppColors.muted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DateStrip extends StatelessWidget {
  const _DateStrip({
    required this.days,
    required this.selected,
    required this.onSelect,
  });

  final List<(String, String, String)> days;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final day = days[index];
          final active = index == selected;
          return GestureDetector(
            onTap: () => onSelect(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 76,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.blue : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: active ? AppColors.blue : AppColors.border,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.blue.withValues(alpha: 0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.$1,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: active
                          ? Colors.white.withValues(alpha: 0.75)
                          : AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    day.$2,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: active ? Colors.white : AppColors.text,
                    ),
                  ),
                  Text(
                    day.$3,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: active
                          ? Colors.white.withValues(alpha: 0.75)
                          : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.appointments, required this.dayLabel});

  final List<Appointment> appointments;
  final String dayLabel;

  @override
  Widget build(BuildContext context) {
    return MediCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
            child: SectionTitle(
              title: dayLabel,
              subtitle: '${appointments.length} citas visibles en la agenda',
              action: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SoftIconButton(
                    icon: Icons.chevron_left_rounded,
                    size: 32,
                  ),
                  const SizedBox(width: 6),
                  const SoftIconButton(
                    icon: Icons.chevron_right_rounded,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
          const DividerLine(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: Column(
              children: [
                for (final slot in MockData.agendaSlots)
                  _TimeSlot(
                    slot: slot,
                    appointments: appointments
                        .where(
                          (appointment) =>
                              appointment.time.split(':').first ==
                              slot.split(':').first,
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSlot extends StatelessWidget {
  const _TimeSlot({required this.slot, required this.appointments});

  final String slot;
  final List<Appointment> appointments;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                slot,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                ),
              ),
            ),
          ),
          Expanded(
            child: appointments.isEmpty
                ? _EmptySlot(slot: slot)
                : Column(
                    children: [
                      for (final appointment in appointments)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _AppointmentBlock(appointment: appointment),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentBlock extends StatelessWidget {
  const _AppointmentBlock({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final style = statusStyleFor(appointment.status);
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 14, 12),
      decoration: BoxDecoration(
        color: style.background.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: style.foreground, width: 3.5),
          top: BorderSide(color: style.background),
          right: BorderSide(color: style.background),
          bottom: BorderSide(color: style.background),
        ),
      ),
      child: Row(
        children: [
          AppAvatar(
            initials: appointment.initials,
            size: 38,
            color: style.foreground,
            background: Colors.white,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      appointment.time,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: style.foreground,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.patient,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${appointment.doctor} · ${appointment.specialty}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge(status: appointment.status, compact: true),
              const SizedBox(height: 5),
              Text(
                appointment.room,
                style: const TextStyle(fontSize: 9.5, color: AppColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot({required this.slot});

  final String slot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showAppSnack(
          context,
          'Horario de $slot disponible para una nueva cita.',
        ),
        borderRadius: BorderRadius.circular(11),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFD),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: 16,
                color: AppColors.muted.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'Disponible',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgendaSummary extends StatelessWidget {
  const _AgendaSummary({required this.onNewAppointment});

  final VoidCallback onNewAppointment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MediCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Resumen del día',
                subtitle: 'Estado de la agenda',
                compact: true,
              ),
              const SizedBox(height: 18),
              const _SummaryRow(
                label: 'Citas programadas',
                value: '24',
                color: AppColors.blue,
              ),
              const _SummaryRow(
                label: 'Confirmadas',
                value: '16',
                color: AppColors.green,
              ),
              const _SummaryRow(
                label: 'En espera',
                value: '4',
                color: AppColors.amber,
              ),
              const _SummaryRow(
                label: 'Canceladas',
                value: '2',
                color: AppColors.red,
              ),
              const _SummaryRow(
                label: 'Atendidas',
                value: '8',
                color: AppColors.teal,
              ),
              const SizedBox(height: 12),
              const DividerLine(),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Ocupación de agenda',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  const Text(
                    '78%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const SoftProgressBar(value: 0.78, color: AppColors.teal),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MediCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Médicos disponibles',
                subtitle: 'Turno de la mañana',
                compact: true,
                action: Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.muted,
                  size: 20,
                ),
              ),
              const SizedBox(height: 16),
              for (final doctor in MockData.doctors.take(3)) ...[
                Row(
                  children: [
                    AppAvatar(
                      initials: doctor.initials,
                      size: 36,
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
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            doctor.specialty,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: doctor.status, compact: true),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onNewAppointment,
                  icon: const Icon(Icons.calendar_month_outlined, size: 17),
                  label: const Text('Programar cita'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MediCard(
          color: AppColors.softAmber,
          borderColor: const Color(0xFFFDE68A),
          shadow: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBox(
                icon: Icons.notifications_active_outlined,
                color: Color(0xFFB45309),
                size: 38,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '3 citas por confirmar',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Envía un recordatorio a los pacientes antes de su atención.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: const Color(0xFF92400E).withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => showAppSnack(
                        context,
                        'Recordatorios enviados a 3 pacientes.',
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF92400E),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.send_outlined, size: 15),
                      label: const Text('Enviar recordatorios'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.muted,
              ),
            ),
          ),
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
    );
  }
}

class _NewAppointmentDialog extends StatefulWidget {
  const _NewAppointmentDialog();

  @override
  State<_NewAppointmentDialog> createState() => _NewAppointmentDialogState();
}

class _NewAppointmentDialogState extends State<_NewAppointmentDialog> {
  final _patient = TextEditingController();
  String _doctor = 'Dr. Carlos Ruiz';
  String _time = '09:00';

  @override
  void dispose() {
    _patient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva cita'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FieldLabel(label: 'Paciente', required: true),
            TextField(
              controller: _patient,
              decoration: const InputDecoration(
                hintText: 'Nombre del paciente',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),
            const FieldLabel(label: 'Médico', required: true),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F4EE),
                borderRadius: BorderRadius.circular(AppRadius.input),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _doctor,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(12),
                  items: [
                    for (final doctor in _doctors)
                      DropdownMenuItem(value: doctor, child: Text(doctor)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _doctor = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel(label: 'Fecha', required: true),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F4EE),
                          borderRadius: BorderRadius.circular(AppRadius.input),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: AppColors.muted,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '30 oct 2026',
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel(label: 'Hora', required: true),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F4EE),
                          borderRadius: BorderRadius.circular(AppRadius.input),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _time,
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(12),
                            items: [
                              for (final time in [
                                '08:00',
                                '08:30',
                                '09:00',
                                '09:30',
                                '10:00',
                                '11:00',
                              ])
                                DropdownMenuItem(
                                  value: time,
                                  child: Text(time),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _time = value);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const FieldLabel(label: 'Motivo de consulta'),
            TextField(
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Describe brevemente el motivo...',
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppColors.muted),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            showAppSnack(
              context,
              'Cita registrada para ${_patient.text.trim().isEmpty ? 'el paciente' : _patient.text.trim()} a las $_time.',
            );
          },
          child: const Text('Guardar cita'),
        ),
      ],
    );
  }

  static const _doctors = [
    'Dr. Carlos Ruiz',
    'Dra. Elena Paredes',
    'Dra. Sofía Vega',
    'Dr. Marco León',
  ];
}
