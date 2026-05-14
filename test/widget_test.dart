import 'package:flutter_test/flutter_test.dart';

import 'package:cimareviews/app/app.dart';

void main() {
  testWidgets('shows login and navigates to home', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('CimaReviews'), findsOneWidget);
    expect(find.text('Bienvenido'), findsOneWidget);

    await tester.ensureVisible(find.text('Log in'));
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('D’Volada'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}
