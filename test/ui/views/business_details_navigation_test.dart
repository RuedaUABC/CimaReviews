import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/ui/views/business_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('BusinessDetailsView navigation', () {
    testWidgets('opens write review screen from the primary action', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: BusinessDetailsView(business: _business())),
      );

      await tester.tap(find.text('Escribir Resena'));
      await tester.pumpAndSettle();

      expect(find.text('Escribir resena'), findsOneWidget);
      expect(find.text('Cafe Cima'), findsOneWidget);
      expect(find.text('Comentario'), findsOneWidget);
    });
  });
}

Business _business() {
  return Business(
    id: '',
    name: 'Cafe Cima',
    owner: User(id: 'owner_1', name: 'Owner', email: '', role: Seller()),
    location: const LatLng(32.52, -116.98),
    avgRating: 4.5,
    products: [],
    reviews: [],
    categories: [Category.cafeteria],
  );
}
