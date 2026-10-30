import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../navigation.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';
import 'desktop/agenda_screen.dart';
import 'desktop/dashboard_screen.dart';
import 'desktop/historia_screen.dart';
import 'desktop/medicos_screen.dart';
import 'desktop/pacientes_screen.dart';
import 'desktop/pagos_screen.dart';
import 'desktop/recetas_screen.dart';
import 'desktop/reportes_screen.dart';
import 'desktop/usuarios_screen.dart';

class DesktopShell extends StatefulWidget {
  const DesktopShell({super.key, required this.role, required this.onLogout});

  final UserRole role;
  final VoidCallback onLogout;

  @override
  State<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends State<DesktopShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DesktopSection _selected = DesktopSection.panel;

  List<DesktopSection> get _allowed => DesktopSection.values
      .where((section) => section.allowedFor(widget.role))
      .toList();

  DesktopSection get _current =>
      _allowed.contains(_selected) ? _selected : _allowed.first;

  void _select(DesktopSection section) {
    if (!_allowed.contains(section)) return;
    setState(() => _selected = section);
  }

  Widget _content(BuildContext context) {
    return IndexedStack(
      index: _allowed.indexOf(_current),
      children: [
        for (final section in _allowed)
          switch (section) {
            DesktopSection.panel => DashboardScreen(onNavigate: _select),
            DesktopSection.citas => const AgendaScreen(),
            DesktopSection.pacientes => PacientesScreen(
              onRegister: () => showAppSnack(
                context,
                'Formulario de registro de paciente listo para conectar.',
              ),
            ),
            DesktopSection.medicos => const MedicosScreen(),
            DesktopSection.historias => HistoriaScreen(
              onNewConsultation: () => showAppSnack(
                context,
                'Nueva consulta registrada en la historia clínica.',
              ),
            ),
            DesktopSection.recetas => RecetasScreen(
              onNewPrescription: () =>
                  showAppSnack(context, 'Nueva receta enviada a farmacia.'),
            ),
            DesktopSection.pagos => PagosScreen(
              onNewPayment: () =>
                  showAppSnack(context, 'Cobro registrado correctamente.'),
            ),
            DesktopSection.reportes => const ReportesScreen(),
            DesktopSection.usuarios => UsuariosScreen(
              onInvite: () =>
                  showAppSnack(context, 'Invitación enviada al nuevo usuario.'),
            ),
          },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 960;
        final compactSidebar = constraints.maxWidth < 1240;

        if (wide) {
          return Scaffold(
            body: Row(
              children: [
                _Sidebar(
                  role: widget.role,
                  selected: _current,
                  onSelect: _select,
                  compact: compactSidebar,
                  onLogout: widget.onLogout,
                ),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(
                        section: _current,
                        role: widget.role,
                        onLogout: widget.onLogout,
                        onNavigate: _select,
                      ),
                      Expanded(child: ClipRect(child: _content(context))),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            width: 282,
            backgroundColor: Colors.transparent,
            child: _Sidebar(
              role: widget.role,
              selected: _current,
              onSelect: (section) {
                _scaffoldKey.currentState?.closeDrawer();
                _select(section);
              },
              compact: false,
              onLogout: widget.onLogout,
            ),
          ),
          body: Column(
            children: [
              _TopBar(
                section: _current,
                role: widget.role,
                onLogout: widget.onLogout,
                onNavigate: _select,
                onMenu: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              Expanded(child: ClipRect(child: _content(context))),
            ],
          ),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.role,
    required this.selected,
    required this.onSelect,
    required this.compact,
    required this.onLogout,
  });

  final UserRole role;
  final DesktopSection selected;
  final ValueChanged<DesktopSection> onSelect;
  final bool compact;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final sections = DesktopSection.values
        .where((section) => section.allowedFor(role))
        .toList();
    final groups = <String, List<DesktopSection>>{};
    for (final section in sections) {
      groups.putIfAbsent(section.group, () => []).add(section);
    }

    return Container(
      width: compact ? 88 : 258,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyDeep],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 20 : 22,
                22,
                compact ? 20 : 22,
                18,
              ),
              child: compact
                  ? const BrandMark(size: 42, light: true, showSubtitle: false)
                  : const BrandMark(size: 42, light: true),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  compact ? 14 : 14,
                  18,
                  compact ? 14 : 14,
                  12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in groups.entries) ...[
                      if (!compact)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 9),
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: Colors.white.withValues(alpha: 0.44),
                            ),
                          ),
                        ),
                      for (final section in entry.value)
                        _SidebarItem(
                          section: section,
                          selected: section == selected,
                          compact: compact,
                          onTap: () => onSelect(section),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
            if (!compact)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.support_agent_rounded,
                        color: Color(0xFF5EEAD4),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Soporte MediSalud',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Disponible 24/7',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withValues(alpha: 0.52),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(compact ? 14 : 16),
              child: compact
                  ? Column(
                      children: [
                        AppAvatar(
                          initials: role.initials,
                          size: 40,
                          color: AppColors.teal,
                          background: Colors.white.withValues(alpha: 0.12),
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Tooltip(
                          message: 'Cerrar sesión',
                          child: IconButton(
                            onPressed: onLogout,
                            icon: Icon(
                              Icons.logout_rounded,
                              color: Colors.white.withValues(alpha: 0.65),
                              size: 19,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        AppAvatar(
                          initials: role.initials,
                          size: 40,
                          color: AppColors.teal,
                          background: Colors.white.withValues(alpha: 0.12),
                          textColor: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                role.userName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                role.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tooltip(
                          message: 'Cerrar sesión',
                          child: InkWell(
                            onTap: onLogout,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Icon(
                                Icons.logout_rounded,
                                color: Colors.white.withValues(alpha: 0.6),
                                size: 18,
                              ),
                            ),
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

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.section,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  final DesktopSection section;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final item = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 170),
          margin: const EdgeInsets.only(bottom: 4),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 0 : 12,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: compact
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (selected)
                Container(
                  width: 3,
                  height: 20,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              Icon(
                section.icon,
                size: 20,
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.6),
              ),
              if (!compact) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.68),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (!compact) return item;
    return Tooltip(message: section.label, child: item);
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.section,
    required this.role,
    required this.onLogout,
    required this.onNavigate,
    this.onMenu,
  });

  final DesktopSection section;
  final UserRole role;
  final VoidCallback onLogout;
  final ValueChanged<DesktopSection> onNavigate;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showSearch = constraints.maxWidth > 880;
          final showDate = constraints.maxWidth > 680;
          final showUser = constraints.maxWidth > 760;

          return Row(
            children: [
              if (onMenu != null) ...[
                SoftIconButton(
                  icon: Icons.menu_rounded,
                  onTap: onMenu,
                  size: 38,
                  border: Colors.transparent,
                  background: const Color(0xFFF7F4EE),
                ),
                const SizedBox(width: 12),
              ],
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    section.subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (showSearch) ...[
                SizedBox(
                  width: 290,
                  child: SearchField(
                    hint: 'Buscar en MediSalud...',
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 14),
              ] else ...[
                SoftIconButton(
                  icon: Icons.search_rounded,
                  onTap: () => _showSearch(context),
                  size: 38,
                  border: Colors.transparent,
                  background: const Color(0xFFF7F4EE),
                  tooltip: 'Buscar',
                ),
                const SizedBox(width: 10),
              ],
              if (showDate) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F4EE),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.muted,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Vie, 30 oct 2026',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
              _NotificationButton(),
              const SizedBox(width: 12),
              Container(width: 1, height: 32, color: AppColors.border),
              const SizedBox(width: 12),
              PopupMenuButton<String>(
                tooltip: 'Cuenta',
                offset: const Offset(0, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onSelected: (value) {
                  if (value == 'logout') onLogout();
                  if (value == 'profile') {
                    showAppSnack(context, 'Perfil de ${role.userName}');
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          size: 18,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 10),
                        Text('Mi perfil · ${role.label}'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 18,
                          color: AppColors.red,
                        ),
                        SizedBox(width: 10),
                        Text('Cerrar sesión'),
                      ],
                    ),
                  ),
                ],
                child: Row(
                  children: [
                    AppAvatar(
                      initials: role.initials,
                      size: 36,
                      color: AppColors.blue,
                    ),
                    if (showUser) ...[
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.userName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            role.label,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.muted,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSearch(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buscar en MediSalud'),
        content: SizedBox(
          width: 430,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Paciente, cita, receta o médico...',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 16),
              _SearchResult(
                icon: Icons.person_outline_rounded,
                title: 'María Fernández',
                subtitle: 'Paciente · DNI 4587 ****',
                onTap: () {
                  Navigator.pop(context);
                  onNavigate(DesktopSection.pacientes);
                },
              ),
              _SearchResult(
                icon: Icons.medication_outlined,
                title: 'RX-2041 · Amoxicilina 500 mg',
                subtitle: 'Receta en preparación',
                onTap: () {
                  Navigator.pop(context);
                  onNavigate(DesktopSection.recetas);
                },
              ),
              _SearchResult(
                icon: Icons.badge_outlined,
                title: 'Dr. Carlos Ruiz',
                subtitle: 'Medicina general · Disponible',
                onTap: () {
                  Navigator.pop(context);
                  onNavigate(DesktopSection.medicos);
                },
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(controller.dispose);
  }
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              IconBox(icon: icon, size: 34),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.muted,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SoftIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: () => _showNotifications(context),
          size: 38,
          border: Colors.transparent,
          background: const Color(0xFFF7F4EE),
          tooltip: 'Notificaciones',
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.notifications_none_rounded, color: AppColors.blue),
            SizedBox(width: 10),
            Text('Notificaciones'),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _NotificationTile(
                icon: Icons.calendar_month_outlined,
                color: AppColors.blue,
                title: 'Nueva cita confirmada',
                message: 'María Fernández · Hoy 08:30 · Dr. Ruiz',
                time: 'Hace 5 min',
              ),
              _NotificationTile(
                icon: Icons.medication_outlined,
                color: AppColors.amber,
                title: 'Receta pendiente de stock',
                message: 'RX-2038 · Jarabe pediátrico',
                time: 'Hace 22 min',
              ),
              _NotificationTile(
                icon: Icons.payments_outlined,
                color: AppColors.green,
                title: 'Pago recibido',
                message: 'S/ 150.00 · José Ramírez',
                time: 'Hace 1 h',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.time,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox(icon: icon, size: 36, color: color),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
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
