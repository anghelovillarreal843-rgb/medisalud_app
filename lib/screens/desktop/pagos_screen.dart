import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts.dart';
import '../../widgets/ui.dart';

class PagosScreen extends StatelessWidget {
  const PagosScreen({super.key, this.onNewPayment});

  final VoidCallback? onNewPayment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Pagos y facturación',
            subtitle: 'Controla cobros, comprobantes y el estado de facturación del día.',
            actions: [
              OutlinedButton.icon(
                onPressed: () =>
                    showAppSnack(context, 'Reporte de caja exportado en PDF.'),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Exportar caja'),
              ),
              ElevatedButton.icon(
                onPressed: onNewPayment,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Registrar pago'),
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
                      label: 'Ingresos del día',
                      value: 'S/ 4,860',
                      icon: Icons.account_balance_wallet_outlined,
                      color: AppColors.green,
                      trend: '+8.2%',
                      footnote: '42 transacciones',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Por cobrar',
                      value: 'S/ 1,240',
                      icon: Icons.pending_actions_outlined,
                      color: AppColors.amber,
                      trend: '-4.1%',
                      trendPositive: true,
                      footnote: '8 comprobantes pendientes',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Facturas emitidas',
                      value: '42',
                      icon: Icons.receipt_long_outlined,
                      color: AppColors.blue,
                      trend: '+6',
                      footnote: 'Hoy, hasta las 11:00',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Ticket promedio',
                      value: 'S/ 115',
                      icon: Icons.trending_up_rounded,
                      color: AppColors.teal,
                      trend: '+3.4%',
                      footnote: 'Consulta + procedimientos',
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
              final table = const _PaymentsTable();
              final side = const _PaymentsSide();
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: table),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: side),
                  ],
                );
              }
              return Column(
                children: [table, const SizedBox(height: 16), side],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PaymentsTable extends StatelessWidget {
  const _PaymentsTable();

  @override
  Widget build(BuildContext context) {
    return MediCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 18, 16),
            child: SectionTitle(
              title: 'Movimientos recientes',
              subtitle: 'Pagos y comprobantes del día',
              action: TextButton.icon(
                onPressed: () =>
                    showAppSnack(context, 'Historial completo de pagos.'),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Ver todo'),
              ),
            ),
          ),
          const DividerLine(),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 720) {
                return Column(
                  children: [
                    for (final payment in MockData.payments)
                      _CompactPaymentRow(payment: payment),
                  ],
                );
              }
              return Column(
                children: [
                  const _PaymentHeader(),
                  for (final payment in MockData.payments)
                    _PaymentTableRow(payment: payment),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PaymentHeader extends StatelessWidget {
  const _PaymentHeader();

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
          SizedBox(width: 86, child: Text('COMPROBANTE', style: style)),
          Expanded(flex: 3, child: Text('PACIENTE', style: style)),
          SizedBox(width: 86, child: Text('MONTO', style: style)),
          SizedBox(width: 116, child: Text('ESTADO', style: style)),
          SizedBox(width: 26),
        ],
      ),
    );
  }
}

class _PaymentTableRow extends StatelessWidget {
  const _PaymentTableRow({required this.payment});

  final PaymentRow payment;

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
            width: 86,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.id,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  payment.method,
                  style: const TextStyle(fontSize: 9.5, color: AppColors.muted),
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
                  payment.patient,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  payment.concept,
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
            width: 86,
            child: Text(
              formatCurrency(payment.amount),
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
          SizedBox(
            width: 116,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(status: payment.status, compact: true),
            ),
          ),
          SizedBox(
            width: 26,
            child: InkWell(
              onTap: () =>
                  showAppSnack(context, 'Comprobante ${payment.id} abierto.'),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 16,
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

class _CompactPaymentRow extends StatelessWidget {
  const _CompactPaymentRow({required this.payment});

  final PaymentRow payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.patient,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      '${payment.id} · ${payment.concept}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatCurrency(payment.amount),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              StatusBadge(status: payment.status, compact: true),
              const Spacer(),
              Text(
                '${payment.method} · ${payment.date}',
                style: const TextStyle(fontSize: 9.5, color: AppColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentsSide extends StatelessWidget {
  const _PaymentsSide();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MediCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Métodos de pago',
                subtitle: 'Distribución de los ingresos de hoy',
                compact: true,
              ),
              const SizedBox(height: 18),
              const SpecialtyDonut(
                data: [
                  SpecialtyShare('Tarjeta', 45, AppColors.blue),
                  SpecialtyShare('Efectivo', 25, AppColors.teal),
                  SpecialtyShare('Yape', 20, AppColors.green),
                  SpecialtyShare('Transferencia', 10, AppColors.amber),
                ],
                centerLabel: 'pagos',
                size: 132,
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
                title: 'Estado de facturación',
                subtitle: 'Cierre de caja de hoy',
                compact: true,
              ),
              const SizedBox(height: 16),
              const _PaymentSummaryRow(
                label: 'Pagado',
                value: 'S/ 4,860',
                color: AppColors.green,
              ),
              const _PaymentSummaryRow(
                label: 'Pendiente',
                value: 'S/ 1,240',
                color: AppColors.amber,
              ),
              const _PaymentSummaryRow(
                label: 'Reembolsado',
                value: 'S/ 130',
                color: AppColors.red,
              ),
              const SizedBox(height: 10),
              const DividerLine(),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Cobrado del día',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  const Text(
                    '86%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const SoftProgressBar(value: 0.86, color: AppColors.green),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showAppSnack(
                    context,
                    'Cierre de caja generado correctamente.',
                  ),
                  icon: const Icon(Icons.lock_clock_outlined, size: 17),
                  label: const Text('Cerrar caja'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MediCard(
          color: AppColors.softBlue,
          borderColor: const Color(0xFFD7E4FD),
          shadow: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBox(
                icon: Icons.info_outline_rounded,
                color: AppColors.blue,
                size: 38,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '8 comprobantes por cobrar',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Recuerda enviar el recordatorio de pago antes del cierre del día.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: const Color(0xFF1D4ED8).withValues(alpha: 0.85),
                      ),
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

class _PaymentSummaryRow extends StatelessWidget {
  const _PaymentSummaryRow({
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
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
