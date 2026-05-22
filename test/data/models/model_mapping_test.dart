import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/event.dart';
import 'package:cimareviews/data/models/permission.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/session.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UML models', () {
    test('User maps API roles and creation date', () {
      final user = User.fromJson({
        'id': 'user_1',
        'name': 'Ana Garcia',
        'email': 'ana@example.com',
        'roles': ['SELLER'],
        'created_at': '2026-05-21T10:30:00Z',
      });

      expect(user.id, 'user_1');
      expect(user.name, 'Ana Garcia');
      expect(user.role, isA<Seller>());
      expect(roleToApiName(user.role), 'SELLER');
      expect(roleDisplayName(user.role), 'Vendedor');
      expect(user.createdAt, isNotNull);
    });

    test('Session validates token and expiration', () {
      final user = User(
        id: 'user_1',
        name: 'Ana',
        email: 'ana@example.com',
        role: UserRole(),
      );

      final activeSession = Session(
        token: 'token',
        user: user,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      final expiredSession = Session(
        token: 'token',
        user: user,
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
      );

      expect(activeSession.isValid(), isTrue);
      expect(expiredSession.isValid(), isFalse);
    });

    test('Role permissions follow UML responsibilities', () {
      expect(Seller().hasPermission(Permission.createBusiness), isTrue);
      expect(UserRole().hasPermission(Permission.createBusiness), isFalse);
      expect(Admin().hasPermission(Permission.deleteAnyReview), isTrue);
    });

    test('Business maps API detail response', () {
      final business = Business.fromJson({
        'id': 'biz_1',
        'name': 'Taqueria El Buen Sazon',
        'owner_id': 'user_2',
        'location': {'lat': 32.52, 'lng': -116.98},
        'avg_rating': 4.8,
        'categories': ['TACOS', 'MEXICANA'],
        'description': 'Tacos y aguas frescas',
        'products': [
          {'name': 'Taco al pastor', 'price': 25, 'description': 'Con pina'},
        ],
        'reviews': [
          {
            'id': 'rev_1',
            'business_id': 'biz_1',
            'user_id': 'user_3',
            'rating': 5,
            'comment': 'Excelente',
            'images': ['https://example.com/review.jpg'],
            'created_at': '2026-05-21T18:45:00Z',
            'user': {
              'id': 'user_3',
              'name': 'Maria',
              'email': 'maria@example.com',
              'roles': ['CUSTOMER'],
              'created_at': '2026-05-01T09:00:00Z',
            },
          },
        ],
      });

      expect(business.id, 'biz_1');
      expect(business.location.latitude, 32.52);
      expect(business.categories, [Category.tacos, Category.mexicana]);
      expect(business.products.single.description, 'Con pina');
      expect(business.reviews.single.author.name, 'Maria');
      expect(business.reviews.single.images.single, contains('review.jpg'));
    });

    test('Event maps API response', () {
      final event = Event.fromJson({
        'id': 'evt_1',
        'title': 'Noche de Tacos',
        'description': 'Descuentos en tacos',
        'date': '2026-06-01T20:00:00Z',
        'business_ids': ['biz_1', 'biz_2'],
        'image_url': 'https://example.com/event.jpg',
      });

      expect(event.id, 'evt_1');
      expect(event.title, 'Noche de Tacos');
      expect(event.businessIds, ['biz_1', 'biz_2']);
      expect(event.imageUrl, contains('event.jpg'));
    });
  });
}
