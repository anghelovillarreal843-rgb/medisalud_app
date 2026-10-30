import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class PacientesScreen extends StatefulWidget {
  const PacientesScreen({super.key, this.onRegister});

  final VoidCallback? onRegister;

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<PatientRow> get _visible {
    if (_query.trim().isEmpty) return MockData.patients;
    final query = _query.toLowerCase();
    return MockData.patients
        .where(
          (patient) =>
              patient.name.toLowerCase().contains(query) ||
              patient.dni.contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Pacientes',
            subtitle: 'Consulta el directorio, registra nuevos pacientes y da seguimiento.',
            actions: [
              OutlinedButton.icon(
                onPressed: () => showAppSnack(
                  context,
                  'Directorio exportado en formato CSV.',
                ),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Exportar'),
              ),
              ElevatedButton.icon(
                onPressed: widget.onRegister,
                icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
                label: const Text('Registrar paciente'),
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
                      label: 'Pacientes registrados',
                      value: '1,248',
                      icon: Icons.people_alt_outlined,
                      color: AppColors.blue,
                      trend: '+4.6%',
                      footnote: '32 nuevos este mes',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'En seguimiento',
                      value: '86',
                      icon: Icons.monitor_heart_outlined,
                      color: AppColors.teal,
                      trend: '+6',
                      footnote: 'Controles programados',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Historias actualizadas',
                      value: '94%',
                      icon: Icons.folder_shared_outlined,
                      color: AppColors.green,
                      trend: '+2.1%',
                      footnote: 'Últimos 30 días',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          MediCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 700;
                      final heading = SectionTitle(
                        title: 'Directorio de pacientes',
                        subtitle:
                            '${_visible.length} pacientes en la vista actual',
                      );
                      final field = SizedBox(
                        width: compact ? constraints.maxWidth : 300,
                        child: SearchField(
                          controller: _search,
                          hint: 'Buscar por nombre o DNI...',
                          onChanged: (value) => setState(() => _query = value),
                        ),
                      );
                      if (compact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            heading,
                            const SizedBox(height: 14),
                            field,
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: heading),
                          const SizedBox(width: 16),
                          field,
                        ],
                      );
                    },
                  ),
                ),
                const DividerLine(),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 760) {
                      return Column(
                        children: [
                          for (final patient in _visible)
                            _CompactPatientRow(patient: patient),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        const _PatientHeader(),
                        for (final patient in _visible)
                          _PatientTableRow(patient: patient),
                      ],
                    );
                  },
                ),
              ],
            ),
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
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.7,
      color: AppColors.muted,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
      color: const Color(0xFFFAFBFD),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('PACIENTE', style: style)),
          SizedBox(width: 56, child: Text('EDAD', style: style)),
          Expanded(flex: 2, child: Text('TELÉFONO', style: style)),
          Expanded(flex: 2, child: Text('ÚLTIMA VISITA', style: style)),
          SizedBox(width: 120, child: Text('ESTADO', style: style)),
          SizedBox(width: 34),
        ],
      ),
    );
  }
}

class _PatientTableRow extends StatelessWidget {
  const _PatientTableRow({required this.patient});

  final PatientRow patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                AppAvatar(
                  initials: patient.initials,
                  size: 36,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        'DNI ${patient.dni}',
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
          SizedBox(
            width: 56,
            child: Text(
              '${patient.age} años',
              style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              patient.phone,
              style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              patient.lastVisit,
              style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
            ),
          ),
          SizedBox(
            width: 120,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(status: patient.status, compact: true),
            ),
          ),
          SizedBox(
            width: 34,
            child: InkWell(
              onTap: () => showAppSnack(
                context,
                'Abriendo historia de ${patient.name}.',
              ),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppColors.muted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactPatientRow extends StatelessWidget {
  const _CompactPatientRow({required this.patient});

  final PatientRow patient;

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
                initials: patient.initials,
                size: 38,
                color: AppColors.blue,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      'DNI ${patient.dni} · ${patient.age} años',
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: patient.status, compact: true),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 13,
                color: AppColors.muted,
              ),
              const SizedBox(width: 5),
              Text(
                patient.phone,
                style: const TextStyle(fontSize: 10.5, color: AppColors.muted),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.event_outlined,
                size: 13,
                color: AppColors.muted,
              ),
              const SizedBox(width: 5),
              Text(
                patient.lastVisit,
                style: const TextStyle(fontSize: 10.5, color: AppColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
