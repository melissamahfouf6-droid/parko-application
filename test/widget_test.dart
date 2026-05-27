import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:parko/app/app.dart';

void main() {
  testWidgets('Parko shows brand on splash', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ParkoApp()));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Parko'), findsOneWidget);
  });
}
