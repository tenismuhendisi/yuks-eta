import 'package:crm_app/core/providers/preview_layout_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/theme/app_theme.dart';
import 'package:crm_app/features/auth/login_screen.dart';
import 'package:crm_app/features/shell/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: EtaCrmApp()));
}

class EtaCrmApp extends ConsumerWidget {
  const EtaCrmApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ETA Tenis Akademisi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => _PreviewShell(child: child),
      home: const _AuthGate(),
    );
  }
}

class _PreviewShell extends ConsumerWidget {
  const _PreviewShell({required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(previewLayoutProvider);
    final isMobile = layout == PreviewLayout.mobile;
    final content = child ?? const SizedBox.shrink();

    return Stack(
      fit: StackFit.expand,
      children: [
        if (isMobile)
          ColoredBox(
            color: const Color(0xFF1A1A1A),
            child: Center(
              child: Container(
                width: kMobilePreviewWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade700, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: Size(
                      kMobilePreviewWidth,
                      MediaQuery.sizeOf(context).height,
                    ),
                  ),
                  child: content,
                ),
              ),
            ),
          )
        else
          content,
        Positioned(
          top: 12,
          right: 12,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 18,
                    color: isMobile
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  Switch(
                    value: !isMobile,
                    onChanged: (toWeb) {
                      ref.read(previewLayoutProvider.notifier).state =
                          toWeb ? PreviewLayout.web : PreviewLayout.mobile;
                    },
                  ),
                  Icon(
                    Icons.desktop_windows_outlined,
                    size: 18,
                    color: !isMobile
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    if (auth.isLoggedIn) {
      return const AppShell();
    }
    return const LoginScreen();
  }
}
