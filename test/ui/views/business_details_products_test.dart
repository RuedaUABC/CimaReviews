import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/product.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/ui/views/business_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('BusinessDetailsView products display', () {
    testWidgets('refreshes products after returning from the business menu', (
      WidgetTester tester,
    ) async {
      final business = _business();

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/business-menu': (context) {
              final business =
                  ModalRoute.of(context)!.settings.arguments! as Business;
              return Scaffold(
                body: SafeArea(
                  child: TextButton(
                    onPressed: () {
                      business.products.add(
                        Product(
                          name: 'Latte',
                          price: 65,
                          description: 'Cafe con leche',
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Agregar Latte'),
                  ),
                ),
              );
            },
          },
          home: BusinessDetailsView(business: business),
        ),
      );

      expect(find.text('Este negocio aun no tiene productos.'), findsOneWidget);

      await tester.tap(find.text('Ver menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Agregar Latte'));
      await tester.pumpAndSettle();

      expect(find.text('Latte'), findsOneWidget);
      expect(find.text('Cafe con leche'), findsOneWidget);
      expect(find.text('\$65'), findsOneWidget);
    });
  });
}

Business _business() {
  return Business(
    id: '',
    name: 'Cafe Cima',
    owner: User(id: 'owner_1', name: 'Owner', email: '', role: Seller()),
    location: const LatLng(32.52, -116.98),
    avgRating: 0,
    products: [],
    reviews: [],
    categories: [Category.cafeteria],
  );
}
