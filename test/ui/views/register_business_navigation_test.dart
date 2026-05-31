import 'package:cimareviews/ui/views/register_business_view.dart';
import 'package:cimareviews/ui/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyBusinessesView navigation', () {
    testWidgets(
      'opens register business screen without typed route cast errors',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            routes: {
              '/register-business': (context) => const RegisterBusinessView(),
            },
            home: const MyBusinessesView(),
          ),
        );

        final registerButton = find.widgetWithText(
          FilledButton,
          'Registrar Negocio',
        );

        await tester.ensureVisible(registerButton);
        await tester.tap(registerButton);
        await tester.pumpAndSettle();

        expect(find.text('Registrar Negocio'), findsOneWidget);
        expect(find.text('Nombre del negocio'), findsOneWidget);
      },
    );
  });
}
