import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class PatientHistorialScreen extends StatefulWidget {
  const PatientHistorialScreen({super.key});

  @override
  State<PatientHistorialScreen> createState() => _PatientHistorialScreenState();
}

class _PatientHistorialScreenState extends State<PatientHistorialScreen> {
  int _tab = 0;

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
                        'Mi historial',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Consulta tu información clínica y resultados.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                SoftIconButton(
                  icon: Icons.file_download_outlined,
                  size: 38,
                  tooltip: 'Descargar historial',
                  onTap: () => showAppSnack(
                    context,
                    'Historial clínico listo para descargar.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _VitalsCard(),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.softSlate,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SegmentButton(
                      label: 'Consultas',
                      icon: Icons.medical_information_outlined,
                      selected: _tab == 0,
                      onTap: () => setState(() => _tab = 0),
                    ),
                  ),
                  Expanded(
                    child: _SegmentButton(
                      label: 'Exámenes',
                      icon: Icons.science_outlined,
                      selected: _tab == 1,
                      onTap: () => setState(() => _tab = 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _tab == 0
                  ? Column(
                      key: const ValueKey('consultas'),
                      children: [
                        for (final consultation in MockData.consultations) ...[
                          _ConsultationCard(consultation: consultation),
                          if (consultation != MockData.consultations.last)
                            const SizedBox(height: 12),
                        ],
                      ],
                    )
                  : Column(
                      key: const ValueKey('examenes'),
                      children: [
                        for (final exam in MockData.exams) ...[
                          _ExamCard(
                            name: exam.$1,
                            date: exam.$2,
                            status: exam.$3,
                          ),
                          if (exam != MockData.exams.last)
                            const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 4),
                        MediCard(
                          color: AppColors.softTeal,
                          borderColor: const Color(0xFFCCFBF1),
                          shadow: false,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const IconBox(
                                icon: Icons.info_outline_rounded,
                                color: AppColors.teal,
                                size: 38,
                              ),
                              const SizedBox(width: 11),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '¿Necesitas otro examen?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F766E),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Solicita una orden médica desde tu próxima consulta.',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        height: 1.4,
                                        color: const Color(0xFF0F766E)
                                            .withValues(alpha: 0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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

class _VitalsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBox(
                icon: Icons.monitor_heart_outlined,
                size: 36,
                color: AppColors.red,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Signos vitales',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      'Actualizado el 18 oct 2026',
                      style: TextStyle(fontSize: 9.5, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: 'Normal', compact: true),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 8.0;
              final width = (constraints.maxWidth - spacing) / 2;
              const vitals = [
                ('Presión', '120/80', 'mmHg', AppColors.red),
                ('Temperatura', '36.6', '°C', AppColors.amber),
                ('Peso', '62', 'kg', AppColors.teal),
                ('Frecuencia', '72', 'lpm', AppColors.blue),
              ];
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final vital in vitals)
                    SizedBox(
                      width: width,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F4EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: 24,
                              decoration: BoxDecoration(
                                color: vital.$4,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vital.$1,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        vital.$2,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.text,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        vital.$3,
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: AppColors.muted,
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
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: selected ? AppShadows.card : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: selected ? AppColors.blue : AppColors.muted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.navy : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsultationCard extends StatelessWidget {
  const _ConsultationCard({required this.consultation});

  final MobileConsultation consultation;

  @override
  Widget build(BuildContext context) {
    return MediCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: InfoChip(
                  icon: Icons.event_outlined,
                  label: consultation.date,
                  color: AppColors.blue,
                  background: AppColors.softBlue,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 2,
                child: StatusBadge(status: consultation.status, compact: true),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            consultation.diagnosis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${consultation.doctor} · ${consultation.specialty}',
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.teal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            consultation.notes,
            style: const TextStyle(
              fontSize: 11,
              height: 1.45,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 10),
          const DividerLine(),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.attach_file_rounded,
                size: 13,
                color: AppColors.muted,
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  '1 documento adjunto',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 9.5, color: AppColors.muted),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => showAppSnack(
                  context,
                  'Detalle de la consulta del ${consultation.date}.',
                ),
                child: const Row(
                  children: [
                    Text(
                      'Ver detalle',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 15,
                      color: AppColors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({
    required this.name,
    required this.date,
    required this.status,
  });

  final String name;
  final String date;
  final String status;

  @override
  Widget build(BuildContext context) {
    return MediCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const IconBox(
            icon: Icons.description_outlined,
            size: 42,
            color: AppColors.teal,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(fontSize: 10, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge(status: status, compact: true),
              const SizedBox(height: 5),
              InkWell(
                onTap: () =>
                    showAppSnack(context, 'Descargando resultado de $name.'),
                child: const Icon(
                  Icons.download_rounded,
                  size: 18,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
