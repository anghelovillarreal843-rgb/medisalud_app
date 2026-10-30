import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class HistoriaScreen extends StatelessWidget {
  const HistoriaScreen({super.key, this.onNewConsultation});

  final VoidCallback? onNewConsultation;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Historia clínica',
            subtitle: 'Ficha completa del paciente y evolución de su atención médica.',
            actions: [
              OutlinedButton.icon(
                onPressed: () => showAppSnack(
                  context,
                  'Historia clínica enviada a la cola de impresión.',
                ),
                icon: const Icon(Icons.print_outlined, size: 18),
                label: const Text('Imprimir'),
              ),
              ElevatedButton.icon(
                onPressed: onNewConsultation,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nueva consulta'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const _PatientHeader(),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1180
                  ? 5
                  : constraints.maxWidth >= 820
                  ? 3
                  : 2;
              const spacing = 12.0;
              final width =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;
              const vitals = [
                (
                  'Presión arterial',
                  '120/80',
                  'mmHg',
                  Icons.monitor_heart_outlined,
                  AppColors.red,
                ),
                (
                  'Temperatura',
                  '36.6',
                  '°C',
                  Icons.thermostat_outlined,
                  AppColors.amber,
                ),
                (
                  'Peso',
                  '62',
                  'kg',
                  Icons.monitor_weight_outlined,
                  AppColors.teal,
                ),
                (
                  'Frecuencia cardiaca',
                  '72',
                  'lpm',
                  Icons.favorite_border_rounded,
                  AppColors.blue,
                ),
                (
                  'Talla',
                  '1.64',
                  'm',
                  Icons.straighten_rounded,
                  AppColors.green,
                ),
              ];
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final vital in vitals)
                    SizedBox(
                      width: width,
                      child: _VitalCard(
                        label: vital.$1,
                        value: vital.$2,
                        unit: vital.$3,
                        icon: vital.$4,
                        color: vital.$5,
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1000;
              final timeline = const _TimelineCard();
              final side = const _ClinicalSide();
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: timeline),
                    const SizedBox(width: 16),
                    Expanded(flex: 1, child: side),
                  ],
                );
              }
              return Column(
                children: [timeline, const SizedBox(height: 16), side],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PatientHeader extends StatelessWidget {
  const _PatientHeader();

  @override
  Widget build(BuildContext context) {
    return MediCard(
      padding: const EdgeInsets.all(22),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final profile = Row(
            children: [
              AppAvatar(
                initials: MockData.patientInitials,
                size: 64,
                color: AppColors.blue,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            MockData.patientName,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const StatusBadge(status: 'Activo', compact: true),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Paciente desde marzo 2023 · Seguro Salud Total',
                      style: TextStyle(fontSize: 11.5, color: AppColors.muted),
                    ),
                    const SizedBox(height: 11),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: const [
                        InfoChip(
                          icon: Icons.badge_outlined,
                          label: 'DNI 4587 ****',
                        ),
                        InfoChip(icon: Icons.cake_outlined, label: '34 años'),
                        InfoChip(
                          icon: Icons.bloodtype_outlined,
                          label: 'O+',
                          color: AppColors.red,
                          background: AppColors.softRed,
                        ),
                        InfoChip(
                          icon: Icons.phone_outlined,
                          label: '+51 987 654 321',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

          final actions = Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () => showAppSnack(
                  context,
                  'Edición de ficha habilitada para el personal autorizado.',
                ),
                icon: const Icon(Icons.edit_outlined, size: 17),
                label: const Text('Editar ficha'),
              ),
              ElevatedButton.icon(
                onPressed: () => showAppSnack(
                  context,
                  'Nueva consulta agregada a la historia clínica.',
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nueva consulta'),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [profile, const SizedBox(height: 16), actions],
            );
          }

          return Row(
            children: [
              Expanded(child: profile),
              const SizedBox(width: 16),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class _VitalCard extends StatelessWidget {
  const _VitalCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MediCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBox(icon: icon, color: color, size: 32),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 16,
                color: AppColors.muted.withValues(alpha: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(width: 3),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10.5, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard();

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
              title: 'Historial de consultas',
              subtitle: 'Evolución clínica y documentos del paciente',
              action: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.softTeal,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: const Text(
                  '4 registros',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.teal,
                  ),
                ),
              ),
            ),
          ),
          const DividerLine(),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            child: Column(
              children: [
                for (var i = 0; i < MockData.timeline.length; i++)
                  _TimelineEntry(
                    event: MockData.timeline[i],
                    isLast: i == MockData.timeline.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.event, required this.isLast});

  final TimelineEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                event.date,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: AppColors.muted,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.withValues(alpha: 0.18),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(event.icon, size: 14, color: AppColors.blue),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    color: AppColors.line,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFD),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      event.doctor,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.5,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tag in event.tags)
                          InfoChip(
                            icon: Icons.sell_outlined,
                            label: tag,
                            color: AppColors.teal,
                            background: AppColors.softTeal,
                          ),
                        InkWell(
                          onTap: () => showAppSnack(
                            context,
                            'Detalle de "${event.title}" abierto.',
                          ),
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Ver detalle',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blue,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 14,
                                  color: AppColors.blue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClinicalSide extends StatelessWidget {
  const _ClinicalSide();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MediCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Alergias',
                subtitle: 'Información crítica del paciente',
                compact: true,
                action: Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.amber,
                  size: 20,
                ),
              ),
              const SizedBox(height: 14),
              const Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  InfoChip(
                    icon: Icons.medication_outlined,
                    label: 'Penicilina',
                    color: AppColors.red,
                    background: AppColors.softRed,
                  ),
                  InfoChip(
                    icon: Icons.grass_outlined,
                    label: 'Polen',
                    color: Color(0xFFB45309),
                    background: AppColors.softAmber,
                  ),
                  InfoChip(
                    icon: Icons.restaurant_outlined,
                    label: 'Mariscos',
                    color: Color(0xFFB45309),
                    background: AppColors.softAmber,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.softRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: Color(0xFFB91C1C),
                    ),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Verificar alergias antes de prescribir.',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB91C1C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MediCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Médico tratante', compact: true),
              const SizedBox(height: 14),
              Row(
                children: [
                  const AppAvatar(
                    initials: 'CR',
                    size: 44,
                    color: AppColors.blue,
                  ),
                  const SizedBox(width: 11),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Carlos Ruiz',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          'Medicina general · CMP 45821',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showAppSnack(
                    context,
                    'Abriendo la agenda del Dr. Carlos Ruiz.',
                  ),
                  icon: const Icon(Icons.calendar_month_outlined, size: 16),
                  label: const Text('Ver agenda'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MediCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Antecedentes', compact: true),
              const SizedBox(height: 14),
              const _BulletLine('Hipertensión arterial (2019)'),
              const _BulletLine('Apendicectomía (2015)'),
              const _BulletLine('No fumador'),
              const _BulletLine('Actividad física 3 veces por semana'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MediCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'Últimos exámenes',
                compact: true,
                action: InkWell(
                  onTap: () => showAppSnack(
                    context,
                    'Listado completo de exámenes del paciente.',
                  ),
                  child: const Text(
                    'Ver todos',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < MockData.exams.length; i++) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: AppColors.teal,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            MockData.exams[i].$1,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            MockData.exams[i].$2,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: MockData.exams[i].$3, compact: true),
                  ],
                ),
                if (i != MockData.exams.length - 1) ...[
                  const SizedBox(height: 10),
                  const DividerLine(),
                  const SizedBox(height: 10),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
              color: AppColors.teal,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                height: 1.4,
                color: AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
