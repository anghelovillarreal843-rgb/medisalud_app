import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class AgendarCitaScreen extends StatefulWidget {
  const AgendarCitaScreen({super.key});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  int _step = 0;
  MobileSpecialty _specialty = MockData.mobileSpecialties.first;
  MobileDoctor _doctor = MockData.mobileDoctors.first;
  int _dateIndex = 0;
  String _time = '09:00';

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _confirm();
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _confirm() async {
    final date = MockData.mobileDates[_dateIndex];
    final month = date.$3 == 'Oct' ? 'octubre' : 'noviembre';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _ConfirmationDialog(
        specialty: _specialty.name,
        doctor: _doctor.name,
        date: '${date.$1} ${date.$2} de $month',
        time: _time,
        cost: _specialty.cost,
      ),
    );
    if (confirmed == true && mounted) {
      showAppSnack(context, 'Tu cita fue confirmada correctamente.');
      setState(() => _step = 0);
    }
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
                        'Agendar cita',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Reserva tu próxima atención en 3 pasos.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                SoftIconButton(
                  icon: Icons.help_outline_rounded,
                  size: 38,
                  onTap: () => showAppSnack(
                    context,
                    'Elige especialidad, médico y horario disponible.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MediCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: _StepIndicator(step: _step),
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: switch (_step) {
                0 => _SpecialtyStep(
                  key: const ValueKey(0),
                  selected: _specialty,
                  onSelect: (specialty) =>
                      setState(() => _specialty = specialty),
                ),
                1 => _DoctorStep(
                  key: const ValueKey(1),
                  selected: _doctor,
                  onSelect: (doctor) => setState(() => _doctor = doctor),
                ),
                _ => _DateTimeStep(
                  key: const ValueKey(2),
                  specialty: _specialty,
                  doctor: _doctor,
                  dateIndex: _dateIndex,
                  time: _time,
                  onDate: (index) => setState(() => _dateIndex = index),
                  onTime: (time) => setState(() => _time = time),
                ),
              },
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                if (_step > 0) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _back,
                      icon: const Icon(Icons.arrow_back_rounded, size: 17),
                      label: const Text('Atrás'),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _next,
                    icon: Icon(
                      _step == 2
                          ? Icons.check_circle_outline_rounded
                          : Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                    label: Text(_step == 2 ? 'Confirmar cita' : 'Continuar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'El costo se paga en recepción el día de tu cita.',
                style: TextStyle(
                  fontSize: 9.5,
                  color: AppColors.muted.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepItem(
          number: 1,
          label: 'Especialidad',
          active: step == 0,
          done: step > 0,
        ),
        _StepLine(done: step > 0),
        _StepItem(
          number: 2,
          label: 'Médico',
          active: step == 1,
          done: step > 1,
        ),
        _StepLine(done: step > 1),
        _StepItem(
          number: 3,
          label: 'Fecha y hora',
          active: step == 2,
          done: false,
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.number,
    required this.label,
    required this.active,
    required this.done,
  });

  final int number;
  final String label;
  final bool active;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final highlighted = active || done;
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: highlighted ? AppColors.blue : AppColors.softSlate,
              shape: BoxShape.circle,
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: AppColors.blue.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: done
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: highlighted ? Colors.white : AppColors.muted,
                    ),
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: highlighted ? AppColors.navy : AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Container(
          height: 2,
          color: done ? AppColors.blue : AppColors.border,
        ),
      ),
    );
  }
}

class _SpecialtyStep extends StatelessWidget {
  const _SpecialtyStep({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final MobileSpecialty selected;
  final ValueChanged<MobileSpecialty> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Elige una especialidad',
          subtitle: 'Selecciona el tipo de atención que necesitas',
          compact: true,
        ),
        const SizedBox(height: 12),
        for (final specialty in MockData.mobileSpecialties) ...[
          _SelectableSpecialty(
            specialty: specialty,
            selected: specialty.name == selected.name,
            onTap: () => onSelect(specialty),
          ),
          if (specialty != MockData.mobileSpecialties.last)
            const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SelectableSpecialty extends StatelessWidget {
  const _SelectableSpecialty({
    required this.specialty,
    required this.selected,
    required this.onTap,
  });

  final MobileSpecialty specialty;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AppColors.softBlue : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.blue : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected ? AppShadows.card : null,
          ),
          child: Row(
            children: [
              IconBox(icon: specialty.icon, size: 44, color: specialty.color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      specialty.name,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      specialty.description,
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
                  Text(
                    specialty.cost,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: specialty.color,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.blue : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? AppColors.blue : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorStep extends StatelessWidget {
  const _DoctorStep({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final MobileDoctor selected;
  final ValueChanged<MobileDoctor> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Elige a tu médico',
          subtitle: 'Profesionales disponibles para esta especialidad',
          compact: true,
        ),
        const SizedBox(height: 12),
        for (final doctor in MockData.mobileDoctors) ...[
          _SelectableDoctor(
            doctor: doctor,
            selected: doctor.name == selected.name,
            onTap: () => onSelect(doctor),
          ),
          if (doctor != MockData.mobileDoctors.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SelectableDoctor extends StatelessWidget {
  const _SelectableDoctor({
    required this.doctor,
    required this.selected,
    required this.onTap,
  });

  final MobileDoctor doctor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AppColors.softBlue : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.blue : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected ? AppShadows.card : null,
          ),
          child: Row(
            children: [
              AppAvatar(
                initials: doctor.initials,
                size: 46,
                color: doctor.color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${doctor.specialty} · ${doctor.experience}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: AppColors.amber,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          doctor.rating,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const InfoChip(
                          icon: Icons.videocam_outlined,
                          label: 'Presencial',
                          color: AppColors.teal,
                          background: AppColors.softTeal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: selected ? AppColors.blue : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.blue : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateTimeStep extends StatelessWidget {
  const _DateTimeStep({
    super.key,
    required this.specialty,
    required this.doctor,
    required this.dateIndex,
    required this.time,
    required this.onDate,
    required this.onTime,
  });

  final MobileSpecialty specialty;
  final MobileDoctor doctor;
  final int dateIndex;
  final String time;
  final ValueChanged<int> onDate;
  final ValueChanged<String> onTime;

  @override
  Widget build(BuildContext context) {
    final date = MockData.mobileDates[dateIndex];
    final month = date.$3 == 'Oct' ? 'octubre' : 'noviembre';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Elige fecha y hora',
          subtitle: 'Horarios disponibles para tu atención',
          compact: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < MockData.mobileDates.length; i++) ...[
              Expanded(
                child: _DateOption(
                  day: MockData.mobileDates[i],
                  selected: i == dateIndex,
                  onTap: () => onDate(i),
                ),
              ),
              if (i != MockData.mobileDates.length - 1)
                const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Horarios de la mañana',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 9),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            final width = (constraints.maxWidth - spacing * 3) / 4;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final option in MockData.mobileTimes)
                  SizedBox(
                    width: width,
                    child: _TimeOption(
                      time: option,
                      selected: option == time,
                      onTap: () => onTime(option),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.softBlue,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD7E4FD)),
          ),
          child: Column(
            children: [
              _SummaryLine(label: 'Especialidad', value: specialty.name),
              _SummaryLine(label: 'Médico', value: doctor.name),
              _SummaryLine(
                label: 'Fecha',
                value: '${date.$1} ${date.$2} de $month',
              ),
              _SummaryLine(label: 'Hora', value: '$time a. m.'),
              const SizedBox(height: 6),
              const DividerLine(color: Color(0xFFC9DBFC)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Costo de consulta',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    specialty.cost,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateOption extends StatelessWidget {
  const _DateOption({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final (String, String, String) day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.blue : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? AppColors.blue : AppColors.border,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.blue.withValues(alpha: 0.24),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              day.$1,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white.withValues(alpha: 0.75)
                    : AppColors.muted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              day.$2,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.text,
              ),
            ),
            Text(
              day.$3,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white.withValues(alpha: 0.75)
                    : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeOption extends StatelessWidget {
  const _TimeOption({
    required this.time,
    required this.selected,
    required this.onTap,
  });

  final String time;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.blue : Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected ? AppColors.blue : AppColors.border,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.muted,
          ),
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 10.5, color: AppColors.muted),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({
    required this.specialty,
    required this.doctor,
    required this.date,
    required this.time,
    required this.cost,
  });

  final String specialty;
  final String doctor;
  final String date;
  final String time;
  final String cost;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 26, 24, 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFBBF7D0), width: 3),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.green,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '¡Cita confirmada!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Te enviaremos un recordatorio antes de tu atención.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.4,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F4EE),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _SummaryLine(label: 'Especialidad', value: specialty),
                _SummaryLine(label: 'Médico', value: doctor),
                _SummaryLine(label: 'Fecha', value: date),
                _SummaryLine(label: 'Hora', value: '$time a. m.'),
                _SummaryLine(label: 'Costo', value: cost),
              ],
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Entendido'),
          ),
        ),
      ],
    );
  }
}
