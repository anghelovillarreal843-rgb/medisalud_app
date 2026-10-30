import 'dart:async';

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin});

  final ValueChanged<UserRole> onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@medisalud.pe');
  final _passwordController = TextEditingController(text: 'medisalud');
  UserRole _role = UserRole.administrador;
  bool _obscure = true;
  bool _remember = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() => _submitting = false);
    widget.onLogin(_role);
  }

  void _forgotPassword() {
    final controller = TextEditingController(text: _emailController.text);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Te enviaremos un enlace seguro para restablecer tu acceso.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Correo electrónico',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.muted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showAppSnack(context, 'Enlace enviado a ${controller.text}');
            },
            child: const Text('Enviar enlace'),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }

  void _createAccount() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear cuenta de paciente'),
        content: Text(
          'El registro de pacientes se habilita desde la recepción de MediSalud. '
          'Comunícate al (01) 555 0120 o acércate a nuestra sede para crear tu acceso.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 980;
          if (wide) {
            return Row(
              children: [
                const Expanded(flex: 11, child: _BrandPanel()),
                Expanded(
                  flex: 9,
                  child: _FormPanel(
                    formKey: _formKey,
                    role: _role,
                    onRoleChanged: (role) => setState(() => _role = role),
                    emailController: _emailController,
                    passwordController: _passwordController,
                    obscure: _obscure,
                    remember: _remember,
                    submitting: _submitting,
                    onToggleObscure: () => setState(() => _obscure = !_obscure),
                    onRemember: (value) =>
                        setState(() => _remember = value ?? false),
                    onSubmit: _submit,
                    onForgot: _forgotPassword,
                    onCreateAccount: _createAccount,
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const _MobileBrandHeader(),
                Transform.translate(
                  offset: const Offset(0, -26),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: _FormPanel(
                      formKey: _formKey,
                      role: _role,
                      onRoleChanged: (role) => setState(() => _role = role),
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscure: _obscure,
                      remember: _remember,
                      submitting: _submitting,
                      onToggleObscure: () =>
                          setState(() => _obscure = !_obscure),
                      onRemember: (value) =>
                          setState(() => _remember = value ?? false),
                      onSubmit: _submit,
                      onForgot: _forgotPassword,
                      onCreateAccount: _createAccount,
                      compact: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyDeep],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: _Orb(size: 360, color: AppColors.blue, opacity: 0.18),
          ),
          Positioned(
            bottom: -140,
            left: -100,
            child: _Orb(size: 380, color: AppColors.teal, opacity: 0.15),
          ),
          Positioned(
            top: 180,
            right: 60,
            child: _Orb(size: 120, color: Colors.white, opacity: 0.05),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(56, 48, 56, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandMark(light: true, size: 46),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: Color(0xFF5EEAD4),
                        size: 14,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'SISTEMA CLÍNICO Y ADMINISTRATIVO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'La salud de tus pacientes,\nen un solo lugar.',
                  style: TextStyle(
                    fontSize: 33,
                    height: 1.16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Coordina citas, historias clínicas, recetas, pagos y reportes '
                  'con una experiencia clara, segura y conectada.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 30),
                const _TrustItem('Acceso seguro por roles y permisos'),
                const _TrustItem('Historias clínicas protegidas'),
                const _TrustItem('Información disponible en todo momento'),
                const Spacer(),
                Divider(color: Colors.white.withValues(alpha: 0.12)),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: _PanelStat(value: '12k+', label: 'Pacientes'),
                    ),
                    _PanelDivider(),
                    Expanded(
                      child: _PanelStat(value: '48', label: 'Médicos'),
                    ),
                    _PanelDivider(),
                    Expanded(
                      child: _PanelStat(
                        value: '99.9%',
                        label: 'Disponibilidad',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileBrandHeader extends StatelessWidget {
  const _MobileBrandHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 52),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyDeep],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandMark(light: true, size: 40),
            const SizedBox(height: 28),
            const Text(
              'Tu salud, organizada\ny siempre disponible.',
              style: TextStyle(
                fontSize: 24,
                height: 1.22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Citas, historial, recetas y pagos en una sola aplicación.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color, required this.opacity});

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF5EEAD4),
              size: 14,
            ),
          ),
          const SizedBox(width: 11),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelStat extends StatelessWidget {
  const _PanelStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.58),
          ),
        ),
      ],
    );
  }
}

class _PanelDivider extends StatelessWidget {
  const _PanelDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      color: Colors.white.withValues(alpha: 0.12),
    );
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({
    required this.formKey,
    required this.role,
    required this.onRoleChanged,
    required this.emailController,
    required this.passwordController,
    required this.obscure,
    required this.remember,
    required this.submitting,
    required this.onToggleObscure,
    required this.onRemember,
    required this.onSubmit,
    required this.onForgot,
    required this.onCreateAccount,
    this.compact = false,
  });

  final GlobalKey<FormState> formKey;
  final UserRole role;
  final ValueChanged<UserRole> onRoleChanged;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool remember;
  final bool submitting;
  final VoidCallback onToggleObscure;
  final ValueChanged<bool?> onRemember;
  final VoidCallback onSubmit;
  final VoidCallback onForgot;
  final VoidCallback onCreateAccount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final content = Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido de nuevo',
            style: compact
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 7),
          Text(
            'Ingresa con tu cuenta institucional para continuar.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 26),
          const FieldLabel(label: 'Ingresar como', required: true),
          _RoleSelector(role: role, onChanged: onRoleChanged),
          const SizedBox(height: 18),
          const FieldLabel(label: 'Correo electrónico', required: true),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              hintText: 'nombre@medisalud.pe',
              prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
            ),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) return 'Ingresa tu correo electrónico.';
              if (!email.contains('@') || !email.contains('.')) {
                return 'Ingresa un correo válido.';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          const FieldLabel(label: 'Contraseña', required: true),
          TextFormField(
            controller: passwordController,
            obscureText: obscure,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: (_) => onSubmit(),
            decoration: InputDecoration(
              hintText: 'Ingresa tu contraseña',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
              suffixIcon: IconButton(
                onPressed: onToggleObscure,
                tooltip: obscure ? 'Mostrar contraseña' : 'Ocultar contraseña',
                icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu contraseña.';
              }
              if (value.length < 4) {
                return 'La contraseña debe tener al menos 4 caracteres.';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: remember,
                  onChanged: onRemember,
                  activeColor: AppColors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Recordarme',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onForgot,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: const Size(0, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submitting ? null : onSubmit,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (submitting) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(submitting ? 'Ingresando...' : 'Ingresar al sistema'),
                  if (!submitting) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.softBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.blue,
                  size: 17,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Demo: elige un rol y presiona Ingresar. No se requiere conexión.',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      color: Color(0xFF1D4ED8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(child: DividerLine()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'o',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const Expanded(child: DividerLine()),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCreateAccount,
              icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
              label: const Text('Crear cuenta de paciente'),
            ),
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              text: 'Al continuar aceptas los ',
              style: const TextStyle(fontSize: 11, color: AppColors.muted),
              children: [
                TextSpan(
                  text: 'Términos de uso',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue.withValues(alpha: 0.9),
                  ),
                ),
                const TextSpan(text: ' y la '),
                TextSpan(
                  text: 'Política de privacidad',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue.withValues(alpha: 0.9),
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    if (compact) {
      return MediCard(padding: const EdgeInsets.all(22), child: content);
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: MediCard(padding: const EdgeInsets.all(34), child: content),
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({required this.role, required this.onChanged});

  final UserRole role;
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4EE),
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          IconBox(icon: role.icon, size: 34, color: AppColors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UserRole>(
                value: role,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.muted,
                ),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
                borderRadius: BorderRadius.circular(14),
                items: [
                  for (final item in UserRole.values)
                    DropdownMenuItem(
                      value: item,
                      child: Row(
                        children: [
                          Icon(item.icon, size: 17, color: AppColors.muted),
                          const SizedBox(width: 9),
                          Text(item.label),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
