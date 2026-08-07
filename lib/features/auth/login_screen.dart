import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _DemoAccount {
  const _DemoAccount({
    required this.role,
    required this.email,
    required this.password,
    required this.icon,
  });

  final UserRole role;
  final String email;
  final String password;
  final IconData icon;
}

const _demoAccounts = [
  _DemoAccount(
    role: UserRole.admin,
    email: 'admin@eta.com',
    password: 'admin123',
    icon: Icons.admin_panel_settings_outlined,
  ),
  _DemoAccount(
    role: UserRole.coach,
    email: 'elif.aktus@eta.com',
    password: 'coach123',
    icon: Icons.sports,
  ),
  _DemoAccount(
    role: UserRole.athlete,
    email: 'can@eta.com',
    password: 'sporcu123',
    icon: Icons.person_outline,
  ),
  _DemoAccount(
    role: UserRole.parent,
    email: 'mehmet@eta.com',
    password: 'veli123',
    icon: Icons.family_restroom,
  ),
];

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@eta.com');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _loading = false;
  String? _error;
  String? _selectedDemoEmail;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoAccount(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
      _selectedDemoEmail = email;
      _error = null;
    });
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final error = await ref.read(authProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/eta_logo.png',
                  height: 88,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Text(
                  'CRM Giriş',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() => _selectedDemoEmail = null),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  onSubmitted: (_) => _login(),
                  onChanged: (_) => setState(() => _selectedDemoEmail = null),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Giriş Yap'),
                ),
                const SizedBox(height: 24),
                _DemoAccounts(
                  selectedEmail: _selectedDemoEmail,
                  onSelect: _fillDemoAccount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoAccounts extends StatelessWidget {
  const _DemoAccounts({
    required this.onSelect,
    this.selectedEmail,
  });

  final void Function(String email, String password) onSelect;
  final String? selectedEmail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Hızlı Giriş (geliştirme)',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Rol seçin — e-posta ve şifre otomatik dolar',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ),
            const SizedBox(height: 4),
            ..._demoAccounts.map((account) {
              final selected = selectedEmail == account.email;
              return ListTile(
                dense: true,
                leading: Icon(
                  account.icon,
                  color: selected ? Theme.of(context).colorScheme.primary : null,
                ),
                title: Text(
                  account.role.label,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${account.email} · ${account.password}',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: selected
                    ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 20)
                    : const Icon(Icons.touch_app_outlined, size: 18),
                selected: selected,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onTap: () => onSelect(account.email, account.password),
              );
            }),
          ],
        ),
      ),
    );
  }
}
