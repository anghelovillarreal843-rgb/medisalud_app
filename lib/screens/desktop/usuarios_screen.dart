import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class UsuariosScreen extends StatelessWidget {
  const UsuariosScreen({super.key, this.onInvite});

  final VoidCallback? onInvite;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Usuarios y roles',
            subtitle: 'Gestiona accesos, permisos y la actividad del personal del sistema.',
            actions: [
              OutlinedButton.icon(
                onPressed: () =>
                    showAppSnack(context, 'Listado de usuarios exportado.'),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Exportar'),
              ),
              ElevatedButton.icon(
                onPressed: onInvite,
                icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
                label: const Text('Invitar usuario'),
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
                      label: 'Usuarios activos',
                      value: '24',
                      icon: Icons.verified_user_outlined,
                      color: AppColors.blue,
                      trend: '+2',
                      footnote: 'Incorporados este mes',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Roles configurados',
                      value: '5',
                      icon: Icons.admin_panel_settings_outlined,
                      color: AppColors.teal,
                      trend: 'Completo',
                      trendNeutral: true,
                      footnote: 'Permisos por módulo',
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: const StatCard(
                      label: 'Invitaciones pendientes',
                      value: '2',
                      icon: Icons.mark_email_unread_outlined,
                      color: AppColors.amber,
                      trend: 'Revisar',
                      trendNeutral: true,
                      footnote: 'Enviadas en las últimas 24 h',
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
              final table = const _UsersTable();
              final roles = const _RolesCard();
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: table),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: roles),
                  ],
                );
              }
              return Column(
                children: [table, const SizedBox(height: 16), roles],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UsersTable extends StatelessWidget {
  const _UsersTable();

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
              title: 'Equipo del sistema',
              subtitle: 'Usuarios con acceso a MediSalud',
              action: TextButton.icon(
                onPressed: () =>
                    showAppSnack(context, 'Filtro de usuarios por rol.'),
                icon: const Icon(Icons.filter_list_rounded, size: 16),
                label: const Text('Filtrar'),
              ),
            ),
          ),
          const DividerLine(),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 720) {
                return Column(
                  children: [
                    for (final user in MockData.users)
                      _CompactUserRow(user: user),
                  ],
                );
              }
              return Column(
                children: [
                  const _UserHeader(),
                  for (final user in MockData.users) _UserTableRow(user: user),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader();

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
          Expanded(flex: 3, child: Text('USUARIO', style: style)),
          Expanded(flex: 2, child: Text('ROL', style: style)),
          SizedBox(width: 120, child: Text('ESTADO', style: style)),
          SizedBox(width: 100, child: Text('ÚLTIMO ACCESO', style: style)),
          SizedBox(width: 30),
        ],
      ),
    );
  }
}

class _UserTableRow extends StatelessWidget {
  const _UserTableRow({required this.user});

  final UserRow user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
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
                  initials: user.initials,
                  size: 36,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        user.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _RoleBadge(role: user.role),
            ),
          ),
          SizedBox(
            width: 120,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(status: user.status, compact: true),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              user.lastAccess,
              style: const TextStyle(fontSize: 10.5, color: AppColors.muted),
            ),
          ),
          SizedBox(
            width: 30,
            child: InkWell(
              onTap: () =>
                  showAppSnack(context, 'Editar permisos de ${user.name}.'),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.more_vert_rounded,
                  size: 17,
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

class _CompactUserRow extends StatelessWidget {
  const _CompactUserRow({required this.user});

  final UserRow user;

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
              AppAvatar(
                initials: user.initials,
                size: 38,
                color: AppColors.blue,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: user.status, compact: true),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _RoleBadge(role: user.role),
              const Spacer(),
              Text(
                'Acceso: ${user.lastAccess}',
                style: const TextStyle(fontSize: 9.5, color: AppColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (role) {
      'Administrador' => (AppColors.softBlue, AppColors.blue),
      'Médico' => (AppColors.softTeal, AppColors.teal),
      'Recepcionista' => (AppColors.softAmber, const Color(0xFFB45309)),
      'Farmacia' => (AppColors.softGreen, const Color(0xFF15803D)),
      _ => (AppColors.softSlate, AppColors.muted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}

class _RolesCard extends StatelessWidget {
  const _RolesCard();

  @override
  Widget build(BuildContext context) {
    const roles = [
      (
        'Administrador',
        'Acceso total a módulos y configuración',
        '1 usuario',
        AppColors.blue,
        Icons.shield_outlined,
      ),
      (
        'Médico',
        'Agenda, pacientes e historias clínicas',
        '18 usuarios',
        AppColors.teal,
        Icons.medical_services_outlined,
      ),
      (
        'Recepcionista',
        'Citas, registro de pacientes y pagos',
        '3 usuarios',
        AppColors.amber,
        Icons.support_agent,
      ),
      (
        'Farmacia',
        'Recetas, dispensación e inventario',
        '2 usuarios',
        AppColors.green,
        Icons.medication_outlined,
      ),
      (
        'Paciente',
        'Citas, historial y recetas propias',
        'Acceso móvil',
        AppColors.muted,
        Icons.person_outline,
      ),
    ];

    return MediCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Roles y permisos',
            subtitle: 'Acceso por módulo según el rol',
            compact: true,
          ),
          const SizedBox(height: 16),
          for (final role in roles) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBox(icon: role.$5, size: 36, color: role.$4),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              role.$1,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          Text(
                            role.$3,
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role.$2,
                        style: const TextStyle(
                          fontSize: 10.5,
                          height: 1.35,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (role != roles.last) ...[
              const SizedBox(height: 11),
              const DividerLine(),
              const SizedBox(height: 11),
            ],
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => showAppSnack(
                context,
                'Matriz de permisos por módulo y acción.',
              ),
              icon: const Icon(Icons.grid_view_rounded, size: 16),
              label: const Text('Ver matriz de permisos'),
            ),
          ),
        ],
      ),
    );
  }
}
