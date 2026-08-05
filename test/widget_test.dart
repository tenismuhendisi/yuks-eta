import 'package:crm_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Giris ekrani goruntulenir', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: EtaCrmApp()));

    expect(find.text('CRM Giriş'), findsOneWidget);
    expect(find.text('ETA Tenis Akademisi'), findsOneWidget);
  });
}
