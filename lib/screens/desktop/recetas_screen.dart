import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class RecetasScreen extends StatefulWidget {
  const RecetasScreen({super.key, this.onNewPrescription});

  final VoidCallback? onNewPrescription;

  @override
  State<RecetasScreen> createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  String _filter = 'Todas';

  static const _filters = [
    ('Todas', 24),
    ('Pendientes', 8),
    ('En preparación', 5),
    ('Entregadas', 9),
    ('Sin stock', 2),
  ];

  List<Prescription> get _visible {
    if (_filter == 'Todas') return MockData.prescriptions;
    if (_filter == 'Pendientes') {
      return MockData.prescriptions
          .where((item) => item.status == 'Pendiente')
          .toList();
    }
    return MockData.prescriptions
        .where((item) => item.status == _filter)
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
            title: 'Recetas y farmacia',
            subtitle: 'Controla la dispensación de medicamentos y el inventario crítico.',
            actions: [
              OutlinedButton.icon(
                onPressed: () => showAppSnack(
                  context,
                  'Inventario completo de farmacia disponible.',
                ),
                icon: const Icon(Icons.inventory_2_outlined, size: 18),
                label: const Text('Inventario'),
              ),
              ElevatedButton.icon(
                onPressed: widget.onNewPrescription,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nueva receta'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900 ? 4 : 2;
              const spacing = 12.0;
              final width =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(
                    width: width,
                    child: const _PharmacyStat(
                      label: 'Por preparar',
                      value: '8',
                      icon: Icons.pending_actions_outlined,
                      color: AppColors.amber,
                      footnote: '2 con prioridad alta',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const _PharmacyStat(
                      label: 'En preparación',
                      value: '5',
                      icon: Icons.medication_liquid_outlined,
                      color: AppColors.blue,
                      footnote: 'En proceso ahora',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const _PharmacyStat(
                      label: 'Entregadas hoy',
                      value: '9',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.green,
                      footnote: 'Tiempo promedio 12 min',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const _PharmacyStat(
                      label: 'Sin stock',
                      value: '2',
                      icon: Icons.error_outline_rounded,
                      color: AppColors.red,
                      footnote: 'Requieren reposición',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final filter in _filters)
                FilterPill(
                  label: filter.$1,
                  count: filter.$2,
                  selected: _filter == filter.$1,
                  onTap: () => setState(() => _filter = filter.$1),
                ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1000;
              final list = _PrescriptionList(prescriptions: _visible);
              final side = const _PharmacySide();
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: list),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: side),
                  ],
                );
              }
              return Column(children: [list, const SizedBox(height: 16), side]);
            },
          ),
        ],
      ),
    );
  }
}

class _PharmacyStat extends StatelessWidget {
  const _PharmacyStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.footnote,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String footnote;

  @override
  Widget build(BuildContext context) {
    return MediCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconBox(icon: icon, color: color, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  footnote,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.5,
                    color: AppColors.muted.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionList extends StatelessWidget {
  const _PrescriptionList({required this.prescriptions});

  final List<Prescription> prescriptions;

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
              title: 'Recetas recientes',
              subtitle: '${prescriptions.length} recetas en esta vista',
              action: const SoftIconButton(
                icon: Icons.filter_list_rounded,
                size: 34,
              ),
            ),
          ),
          const DividerLine(),
          if (prescriptions.isEmpty)
            const EmptyState(
              icon: Icons.medication_outlined,
              title: 'Sin recetas en este estado',
              message: 'Cambia el filtro para ver otras recetas.',
            )
          else
            for (var i = 0; i < prescriptions.length; i++)
              _PrescriptionRow(
                prescription: prescriptions[i],
                isLast: i == prescriptions.length - 1,
              ),
        ],
      ),
    );
  }
}

class _PrescriptionRow extends StatelessWidget {
  const _PrescriptionRow({required this.prescription, required this.isLast});

  final Prescription prescription;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final style = statusStyleFor(prescription.status);
    final actionLabel = switch (prescription.status) {
      'Pendiente' => 'Preparar',
      'En preparación' => 'Marcar lista',
      'Sin stock' => 'Reponer',
      'Entregada' => 'Ver detalle',
      _ => 'Ver detalle',
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 18, 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final info = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: style.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.medication_outlined,
                  size: 19,
                  color: style.foreground,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          prescription.id,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge(status: prescription.status, compact: true),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      prescription.medication,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${prescription.patient} · ${prescription.dose}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 12,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          prescription.quantity,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          prescription.date,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

          final action = OutlinedButton(
            onPressed: () =>
                showAppSnack(context, '$actionLabel · ${prescription.id}'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: Text(actionLabel),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                info,
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerRight, child: action),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: info),
              const SizedBox(width: 12),
              action,
            ],
          );
        },
      ),
    );
  }
}

class _PharmacySide extends StatelessWidget {
  const _PharmacySide();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MediCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'Inventario crítico',
                subtitle: 'Medicamentos por debajo del mínimo',
                compact: true,
                action: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softRed,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    '4 alertas',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB91C1C),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (final item in MockData.inventory) ...[
                _InventoryRow(item: item),
                if (item != MockData.inventory.last)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 11),
                    child: DividerLine(),
                  ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showAppSnack(
                    context,
                    'Solicitud de reposición enviada al proveedor.',
                  ),
                  icon: const Icon(Icons.local_shipping_outlined, size: 17),
                  label: const Text('Solicitar reposición'),
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
              const SectionTitle(
                title: 'Resumen de farmacia',
                subtitle: 'Actividad de hoy',
                compact: true,
              ),
              const SizedBox(height: 16),
              const _PharmacySummaryRow(
                label: 'Recetas pendientes',
                value: '8',
                color: AppColors.amber,
              ),
              const _PharmacySummaryRow(
                label: 'Listas para entrega',
                value: '5',
                color: AppColors.blue,
              ),
              const _PharmacySummaryRow(
                label: 'Entregadas hoy',
                value: '9',
                color: AppColors.green,
              ),
              const _PharmacySummaryRow(
                label: 'Sin stock',
                value: '2',
                color: AppColors.red,
              ),
              const SizedBox(height: 10),
              const DividerLine(),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Meta de entrega',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  const Text(
                    '82%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const SoftProgressBar(value: 0.82, color: AppColors.green),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MediCard(
          color: AppColors.softRed,
          borderColor: const Color(0xFFFECACA),
          shadow: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBox(
                icon: Icons.warning_amber_rounded,
                color: AppColors.red,
                size: 38,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '2 medicamentos sin stock',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF991B1B),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Jarabe pediátrico y Amoxicilina 500 mg requieren atención inmediata.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: const Color(0xFF991B1B).withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 9),
                    TextButton.icon(
                      onPressed: () => showAppSnack(
                        context,
                        'Alerta enviada al área de compras.',
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF991B1B),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.send_outlined, size: 15),
                      label: const Text('Gestionar alerta'),
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

class _InventoryRow extends StatelessWidget {
  const _InventoryRow({required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final critical = item.stock <= item.minimum;
    final color = critical ? AppColors.red : AppColors.amber;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    item.presentation,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${item.stock} / ${item.minimum}',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        SoftProgressBar(
          value: item.level,
          color: color,
          height: 5,
          background: color.withValues(alpha: 0.12),
        ),
      ],
    );
  }
}

class _PharmacySummaryRow extends StatelessWidget {
  const _PharmacySummaryRow({
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
      padding: const EdgeInsets.only(bottom: 10),
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
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.muted,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
