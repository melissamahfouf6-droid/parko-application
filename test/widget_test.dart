import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:parko/app/app.dart';
import 'package:parko/core/storage/preferences_bootstrap.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesBootstrap.init();
  });

  testWidgets('Parko shows brand on splash', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ParkoApp()));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Parko'), findsOneWidget);
  });
}
