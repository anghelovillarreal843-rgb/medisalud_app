import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class PatientRecetasScreen extends StatefulWidget {
  const PatientRecetasScreen({super.key});

  @override
  State<PatientRecetasScreen> createState() => _PatientRecetasScreenState();
}

class _PatientRecetasScreenState extends State<PatientRecetasScreen> {
  String _filter = 'Activas';

  static const _prescriptions = [
    Prescription(
      id: 'RX-2041',
      patient: 'María Fernández',
      medication: 'Amoxicilina 500 mg',
      dose: '1 cápsula cada 8 horas · 7 días',
      status: 'En preparación',
      date: 'Hoy, 08:20',
      quantity: '21 cápsulas',
    ),
    Prescription(
      id: 'RX-1988',
      patient: 'María Fernández',
      medication: 'Ibuprofeno 400 mg',
      dose: '1 tableta cada 8 horas · 5 días',
      status: 'Entregada',
      date: '14 sep 2026',
      quantity: '15 tabletas',
    ),
    Prescription(
      id: 'RX-1875',
      patient: 'María Fernández',
      medication: 'Vitamina C 500 mg',
      dose: '1 tableta al día · 30 días',
      status: 'Entregada',
      date: '02 ago 2026',
      quantity: '30 tabletas',
    ),
  ];

  List<Prescription> get _visible {
    if (_filter == 'Todas') return _prescriptions;
    if (_filter == 'Activas') {
      return _prescriptions
          .where((item) => item.status != 'Entregada')
          .toList();
    }
    return _prescriptions.where((item) => item.status == 'Entregada').toList();
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
                        'Mis recetas',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Sigue el estado de tus medicamentos.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SoftIconButton(
                      icon: Icons.notifications_none_rounded,
                      size: 38,
                      onTap: () => showAppSnack(
                        context,
                        'Tienes 1 receta en preparación.',
                      ),
                    ),
                    Positioned(
                      right: 9,
                      top: 9,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _TrackingCard(),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final filter in ['Activas', 'Entregadas', 'Todas'])
                  FilterPill(
                    label: filter,
                    count: filter == 'Activas'
                        ? 1
                        : filter == 'Entregadas'
                        ? 2
                        : 3,
                    selected: _filter == filter,
                    onTap: () => setState(() => _filter = filter),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            for (final prescription in _visible) ...[
              _PrescriptionCard(prescription: prescription),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            MediCard(
              color: AppColors.softTeal,
              borderColor: const Color(0xFFCCFBF1),
              shadow: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const IconBox(
                    icon: Icons.location_on_outlined,
                    color: AppColors.teal,
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Farmacia sede Central',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F766E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Av. Los Álamos 245, Lima · Lunes a sábado de 08:00 a 20:00',
                          style: TextStyle(
                            fontSize: 10.5,
                            height: 1.4,
                            color: const Color(0xFF0F766E)
                                .withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => showAppSnack(
                            context,
                            'Abriendo la ubicación de la farmacia.',
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.teal,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 24),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(Icons.map_outlined, size: 15),
                          label: const Text('Ver ubicación'),
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

class _TrackingCard extends StatelessWidget {
  const _TrackingCard();

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
                icon: Icons.medication_outlined,
                color: AppColors.blue,
                size: 40,
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RX-2041',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.muted,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Amoxicilina 500 mg',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      '1 cápsula cada 8 horas · 7 días',
                      style: TextStyle(fontSize: 10, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const StatusBadge(status: 'En preparación', compact: true),
            ],
          ),
          const SizedBox(height: 16),
          const DividerLine(),
          const SizedBox(height: 14),
          const _TrackerStep(
            title: 'Receta recibida',
            subtitle: 'Hoy · 08:20 a. m.',
            state: _TrackerState.done,
            isLast: false,
          ),
          const _TrackerStep(
            title: 'En preparación',
            subtitle: 'Farmacia está preparando tu pedido',
            state: _TrackerState.active,
            isLast: false,
          ),
          const _TrackerStep(
            title: 'Lista para recoger',
            subtitle: 'Te avisaremos cuando esté lista',
            state: _TrackerState.pending,
            isLast: false,
          ),
          const _TrackerStep(
            title: 'Entregada',
            subtitle: 'Presenta tu DNI al recoger',
            state: _TrackerState.pending,
            isLast: true,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: AppColors.softAmber,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  size: 16,
                  color: Color(0xFFB45309),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tiempo estimado de preparación: 15 minutos.',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF92400E),
                    ),
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

enum _TrackerState { done, active, pending }

class _TrackerStep extends StatelessWidget {
  const _TrackerStep({
    required this.title,
    required this.subtitle,
    required this.state,
    required this.isLast,
  });

  final String title;
  final String subtitle;
  final _TrackerState state;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final background = switch (state) {
      _TrackerState.done => AppColors.green,
      _TrackerState.active => AppColors.blue,
      _TrackerState.pending => Colors.white,
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: state == _TrackerState.pending
                        ? AppColors.border
                        : background,
                    width: 1.5,
                  ),
                  boxShadow: state == _TrackerState.active
                      ? [
                          BoxShadow(
                            color: AppColors.blue.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: state == _TrackerState.done
                    ? const Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      )
                    : state == _TrackerState.active
                    ? const Icon(
                        Icons.medication_outlined,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    color: state == _TrackerState.done
                        ? AppColors.green.withValues(alpha: 0.4)
                        : AppColors.line,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: state == _TrackerState.active
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: state == _TrackerState.pending
                          ? AppColors.muted
                          : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (state == _TrackerState.active)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Ahora',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard({required this.prescription});

  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    final style = statusStyleFor(prescription.status);
    final active = prescription.status != 'Entregada';
    return MediCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: style.background,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.medication_outlined,
                  size: 20,
                  color: style.foreground,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      prescription.dose,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: prescription.status, compact: true),
            ],
          ),
          const SizedBox(height: 11),
          Wrap(
            spacing: 7,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              InfoChip(
                icon: Icons.tag_rounded,
                label: prescription.id,
                color: AppColors.muted,
                background: AppColors.softSlate,
              ),
              InfoChip(
                icon: Icons.inventory_2_outlined,
                label: prescription.quantity,
                color: AppColors.muted,
                background: AppColors.softSlate,
              ),
              Text(
                prescription.date,
                style: const TextStyle(fontSize: 9.5, color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const DividerLine(),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                active
                    ? Icons.hourglass_top_rounded
                    : Icons.check_circle_outline_rounded,
                size: 13,
                color: active ? AppColors.amber : AppColors.green,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  active
                      ? 'Disponible en farmacia sede Central'
                      : 'Entregada en farmacia sede Central',
                  style: const TextStyle(fontSize: 9.5, color: AppColors.muted),
                ),
              ),
              InkWell(
                onTap: () => showAppSnack(
                  context,
                  'Detalle de la receta ${prescription.id}.',
                ),
                child: const Row(
                  children: [
                    Text(
                      'Ver detalle',
                      style: TextStyle(
                        fontSize: 9.5,
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
            ],
          ),
        ],
      ),
    );
  }
}
