import 'package:cimareviews/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginView', () {
    testWidgets('shows validation before calling API', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      expect(find.text('CimaReviews'), findsOneWidget);
      expect(find.text('Bienvenido'), findsOneWidget);

      await tester.ensureVisible(find.text('Log in'));
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();

      expect(find.text('Ingresa correo y contrasena.'), findsOneWidget);
    });
  });
}
