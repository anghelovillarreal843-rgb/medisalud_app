import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts.dart';
import '../../widgets/ui.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Reportes',
            subtitle: 'Indicadores de atención, ingresos y rendimiento del equipo médico.',
            actions: [
              OutlinedButton.icon(
                onPressed: () => showAppSnack(
                  context,
                  'Periodo seleccionado: 01 - 30 de octubre de 2026.',
                ),
                icon: const Icon(Icons.calendar_today_outlined, size: 17),
                label: const Text('01 - 30 oct 2026'),
              ),
              ElevatedButton.icon(
                onPressed: () => showAppSnack(
                  context,
                  'Reporte PDF generado y listo para descargar.',
                ),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Exportar PDF'),
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
                      label: 'Citas del mes',
                      value: '486',
                      icon: Icons.calendar_month_outlined,
                      color: AppColors.blue,
                      trend: '+11.4%',
                      footnote: 'vs. septiembre',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Ingresos del mes',
                      value: 'S/ 86,420',
                      icon: Icons.account_balance_wallet_outlined,
                      color: AppColors.green,
                      trend: '+9.8%',
                      footnote: 'vs. septiembre',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Nuevos pacientes',
                      value: '128',
                      icon: Icons.person_add_alt_1_outlined,
                      color: AppColors.teal,
                      trend: '+16',
                      footnote: 'Este mes',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Ocupación de agenda',
                      value: '82%',
                      icon: Icons.donut_small_outlined,
                      color: AppColors.amber,
                      trend: '+3.2%',
                      footnote: 'Promedio de las sedes',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1000;
              final weekly = MediCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Citas por día',
                      subtitle: 'Atenciones registradas en la última semana',
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
                      title: 'Atenciones por especialidad',
                      subtitle: 'Participación en el total del mes',
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
                    Expanded(flex: 3, child: weekly),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: donut),
                  ],
                );
              }
              return Column(
                children: [weekly, const SizedBox(height: 16), donut],
              );
            },
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1000;
              final monthly = MediCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(
                      title: 'Ingresos mensuales',
                      subtitle: 'Miles de soles facturados en el semestre',
                      action: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softGreen,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const Text(
                          '+9.8%',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const WeeklyBarChart(
                      points: [
                        WeekPoint('May', 62),
                        WeekPoint('Jun', 71),
                        WeekPoint('Jul', 68),
                        WeekPoint('Ago', 79),
                        WeekPoint('Sep', 83),
                        WeekPoint('Oct', 86),
                      ],
                      color: AppColors.teal,
                    ),
                  ],
                ),
              );
              final performance = MediCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Top especialidades',
                      subtitle: 'Ingresos generados en el mes',
                      compact: true,
                    ),
                    const SizedBox(height: 18),
                    const HorizontalBars(
                      items: [
                        (
                          label: 'Medicina general',
                          value: 28400,
                          color: AppColors.blue,
                        ),
                        (
                          label: 'Cardiología',
                          value: 19200,
                          color: AppColors.teal,
                        ),
                        (
                          label: 'Pediatría',
                          value: 15800,
                          color: AppColors.green,
                        ),
                        (
                          label: 'Dermatología',
                          value: 12400,
                          color: AppColors.amber,
                        ),
                        (
                          label: 'Ginecología',
                          value: 10620,
                          color: Color(0xFF7C3AED),
                        ),
                      ],
                      valueSuffix: '',
                    ),
                    const SizedBox(height: 18),
                    const DividerLine(),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Montos expresados en soles (S/).',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.muted.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: monthly),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: performance),
                  ],
                );
              }
              return Column(
                children: [monthly, const SizedBox(height: 16), performance],
              );
            },
          ),
        ],
      ),
    );
  }
}
