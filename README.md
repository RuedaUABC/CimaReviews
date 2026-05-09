# CimaReviews

Aplicación móvil Android desarrollada en Flutter para reseñas de negocios alimenticios. Permite a los usuarios descubrir, calificar y reseñar restaurantes, cafeterías y establecimientos de comida.

## Requisitos Previos

- **Flutter**: >=3.16.0 <4.0.0
- **Dart**: >=3.2.0 <4.0.0
- **Android Studio** con plugins de Flutter
- **Dispositivo o emulador Android** (API 21+)
- **JDK 11+** para compilación Android

## Ejecución del Proyecto

```bash
# Clonar el repositorio
git clone [url-del-repositorio]

# Instalar dependencias
flutter pub get

# Ejecutar la app (modo debug)
flutter run

# Limpiar caché (si hay problemas)
flutter clean && flutter pub get

# Generar código (json_serializable, etc.)
flutter pub run build_runner build

# Ejecutar con logs detallados
flutter run --verbose
```

## Estructura del Proyecto

El proyecto sigue una arquitectura **MVVM** (Model-View-ViewModel) con separación clara de responsabilidades:

```
lib/
├── main.dart                    # Punto de entrada de la app
│
├── app/                         # Configuración principal
│   ├── app.dart                # Widget principal (MaterialApp)
│   ├── routes.dart             # Definición de rutas (go_router)
│   └── theme.dart              # Temas, colores, estilos globales
│
├── data/                        # Capa de datos
│   ├── models/                 # Modelos de dominio
│   │   ├── user.dart
│   │   ├── business.dart
│   │   ├── review.dart
│   │   ├── report.dart
│   │   ├── event.dart
│   │   ├── session.dart
│   │   └── enums/              # Enumeraciones (Role, Category, Permission)
│   │
│   ├── services/               # Servicios específicos (API, DB, Cache)
│   │   ├── api_service.dart    # Comunicación HTTP con backend
│   │   ├── database_service.dart # Operaciones SQLite local
│   │   ├── cache_service.dart   # SharedPreferences (tokens, preferencias)
│   │   ├── location_service.dart # Geolocalización y mapas
│   │   └── auth_service.dart    # Autenticación específica
│   │
│   └── repositories/           # Orquestadores entre servicios
│       ├── user_repository.dart
│       ├── business_repository.dart
│       ├── review_repository.dart
│       ├── report_repository.dart
│       └── event_repository.dart
│
├── ui/                          # Capa de presentación
│   ├── viewmodels/             # Lógica de negocio de UI
│   │   ├── auth/
│   │   │   ├── login_viewmodel.dart
│   │   │   └── register_viewmodel.dart
│   │   ├── business/
│   │   │   ├── business_list_viewmodel.dart
│   │   │   ├── business_details_viewmodel.dart
│   │   │   └── register_business_viewmodel.dart
│   │   ├── review/
│   │   │   ├── write_review_viewmodel.dart
│   │   │   └── reviews_list_viewmodel.dart
│   │   ├── map/
│   │   │   └── map_viewmodel.dart
│   │   └── dashboard_viewmodel.dart
│   │
│   ├── views/                  # Pantallas (Widgets)
│   │   ├── auth/
│   │   │   ├── login_view.dart
│   │   │   └── register_view.dart
│   │   ├── business/
│   │   │   ├── business_list_view.dart
│   │   │   ├── business_details_view.dart
│   │   │   └── register_business_view.dart
│   │   ├── review/
│   │   │   ├── write_review_view.dart
│   │   │   └── reviews_list_view.dart
│   │   ├── map_view.dart
│   │   └── dashboard_view.dart
│   │
│   └── widgets/                # Widgets reutilizables
│       ├── custom_app_bar.dart
│       ├── rating_stars.dart
│       ├── loading_indicator.dart
│       ├── error_widget.dart
│       ├── business_card.dart
│       └── custom_bottom_navbar.dart
│
└── utils/                      # Utilidades transversales
    ├── constants.dart          # Constantes globales (API keys, etc.)
    ├── helpers.dart            # Funciones auxiliares
    ├── validators.dart         # Validadores de formularios
    ├── extensions.dart         # Extensiones de Dart
    └── logger.dart             # Configuración de logging
```

## Arquitectura MVVM

### Diagrama de Clases 
[Diagrama de Clases](C:\Proyectos\CimaReviews\cimareviews\UML.md)


### Flujo de Datos MVVM

```
┌─────────┐ Evento     ┌────────────┐ Llama      ┌────────────┐
│  View   │ ────────→  │ ViewModel  │ ────────→  │ Repository │
│ (Widget)│            │ (State)    │            │(Orquesta)  │
└─────────┘            └────────────┘            └────────────┘
     ↑                        │                         │
     │                        │                         ↓
     │                   Notifica                  ┌────────────┐
     │                   cambios                   │  Service   │
     │                        │                    │ (API/DB)   │
     │                        ↓                    └────────────┘
     │                   ┌────────────┐                  │
     └────────────────── │  Modelo    │ ←────────────────┘
                         │ (Datos)    │
                         └────────────┘
```

## Dependencias

### Paquetes Principales (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Estado y navegación
  riverpod: ^2.4.0
  go_router: ^13.0.0
  
  # Mapa y ubicación (Android optimizado)
  flutter_osm_plugin: ^0.70.0    # Mapa OSM nativo Android
  geolocator: ^12.0.0             # GPS y ubicación
  latlong2: ^0.9.0                # Manejo de coordenadas
  
  # UI
  flutter_rating_bar: ^4.0.1      # Estrellas de calificación
  image_picker: ^1.0.4            # Cámara y galería
  cached_network_image: ^3.3.0    # Caché de imágenes
  
  # Almacenamiento y datos
  sqflite: ^2.3.0                 # SQLite local
  shared_preferences: ^2.2.2     # Preferencias simples
  path_provider: ^2.1.1          # Rutas de archivos
  http: ^1.1.0                    # Cliente HTTP
  
  # Utilidades
  equatable: ^2.0.5              # Comparación de objetos
  json_annotation: ^4.8.1        # Serialización JSON
  permission_handler: ^11.0.0    # Manejo de permisos Android
  
  # Logging y debugging
  logger: ^2.0.2                  # Logs bonitos
  flutter_native_splash: ^2.3.8  # Pantalla de bienvenida

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.6           # Generación de código
  json_serializable: ^6.7.1      # Serializador JSON
  mocktail: ^1.0.0               # Mocks para pruebas
  flutter_lints: ^3.0.0          # Linter
```

## Convenciones de Código

### Nombrado

| Tipo | Convención | Ejemplo |
|------|-----------|---------|
| Archivos | `snake_case` | `business_repository.dart` |
| Carpetas | `snake_case` | `/view_models/` |
| Clases | `PascalCase` | `LoginViewModel` |
| Variables/Métodos | `camelCase` | `getBusinessById()` |
| Constantes | `lowerCamelCase` | `apiBaseUrl` |
| Enums | `PascalCase` | `Category.restaurant` |
| Widgets privados | `_PascalCase` | `_BusinessCard` |

### Organización de Imports

```dart
// 1. SDK de Dart
import 'dart:async';
import 'dart:convert';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. Paquetes externos
import 'package:riverpod/riverpod.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

// 4. Servicios
import 'package:cimareviews/data/services/api_service.dart';

// 5. Repositorios
import 'package:cimareviews/data/repositories/business_repository.dart';

// 6. Modelos
import 'package:cimareviews/data/models/business.dart';

// 7. ViewModels
import 'package:cimareviews/ui/viewmodels/business/business_details_viewmodel.dart';

// 8. Widgets
import 'package:cimareviews/ui/widgets/rating_stars.dart';

// 9. Utilidades
import 'package:cimareviews/utils/constants.dart';
```

### Estilo de Código

```dart
// ✅ Bueno: Early returns y validaciones claras
Future<void> submitReview(Review review) async {
  if (review.rating == 0) {
    throw ValidationException('Debes seleccionar una calificación');
  }
  if (review.comment.isEmpty) {
    throw ValidationException('Debes escribir un comentario');
  }
  await _reviewRepository.createReview(review);
}

// ❌ Mal: Anidamiento excesivo
Future<void> submitReview(Review review) async {
  if (review.rating != 0) {
    if (review.comment.isNotEmpty) {
      await _reviewRepository.createReview(review);
    } else {
      throw ValidationException('Debes escribir un comentario');
    }
  } else {
    throw ValidationException('Debes seleccionar una calificación');
  }
}
```

## Gestión de Estado con Riverpod

### Definición de Providers

**`lib/ui/providers/providers.dart`**
```dart
import 'package:riverpod/riverpod.dart';

// Services
final apiServiceProvider = Provider((ref) => ApiService());
final databaseServiceProvider = Provider((ref) => DatabaseService());
final cacheServiceProvider = Provider((ref) => CacheService());
final locationServiceProvider = Provider((ref) => LocationService());

// Repositories
final businessRepositoryProvider = Provider((ref) {
  return BusinessRepository(
    apiService: ref.read(apiServiceProvider),
    databaseService: ref.read(databaseServiceProvider),
    cacheService: ref.read(cacheServiceProvider),
  );
});

final userRepositoryProvider = Provider((ref) {
  return UserRepository(
    apiService: ref.read(apiServiceProvider),
    cacheService: ref.read(cacheServiceProvider),
  );
});

final reviewRepositoryProvider = Provider((ref) {
  return ReviewRepository(
    apiService: ref.read(apiServiceProvider),
    databaseService: ref.read(databaseServiceProvider),
  );
});

// ViewModels
final dashboardViewModelProvider = ChangeNotifierProvider((ref) {
  return DashboardViewModel(
    businessRepository: ref.read(businessRepositoryProvider),
    userRepository: ref.read(userRepositoryProvider),
  );
});

final businessDetailsViewModelProvider = ChangeNotifierProvider((ref) {
  return BusinessDetailsViewModel(
    businessRepository: ref.read(businessRepositoryProvider),
    reviewRepository: ref.read(reviewRepositoryProvider),
  );
});

final mapViewModelProvider = ChangeNotifierProvider((ref) {
  return MapViewModel(
    businessRepository: ref.read(businessRepositoryProvider),
    locationService: ref.read(locationServiceProvider),
  );
});

final loginViewModelProvider = ChangeNotifierProvider((ref) {
  return LoginViewModel(
    userRepository: ref.read(userRepositoryProvider),
  );
});
```

### Consumo en Views

**`lib/ui/views/dashboard_view.dart`**
```dart
class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardVM = ref.watch(dashboardViewModelProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('CimaReviews')),
      body: _buildBody(dashboardVM, ref),
      floatingActionButton: FloatingActionButton(
        onPressed: () => dashboardVM.refresh(),
        child: Icon(Icons.refresh),
      ),
    );
  }
  
  Widget _buildBody(DashboardViewModel vm, WidgetRef ref) {
    if (vm.isLoading && vm.businesses.isEmpty) {
      return const LoadingIndicator();
    }
    
    if (vm.error != null) {
      return ErrorWidget(
        message: vm.error!,
        onRetry: () => vm.loadBusinesses(),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () => vm.refresh(),
      child: ListView.builder(
        itemCount: vm.businesses.length,
        itemBuilder: (context, index) {
          final business = vm.businesses[index];
          return BusinessCard(
            business: business,
            onTap: () => context.push('/business/${business.id}'),
          );
        },
      ),
    );
  }
}
```

## Enrutamiento

**`lib/app/routes.dart`**
```dart
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final isLoggedIn = _checkAuthStatus();
    final isLoginRoute = state.matchedLocation == '/login';
    final isRegisterRoute = state.matchedLocation == '/register';
    
    if (!isLoggedIn && !isLoginRoute && !isRegisterRoute) {
      return '/login';
    }
    if (isLoggedIn && (isLoginRoute || isRegisterRoute)) {
      return '/dashboard';
    }
    return null;
  },
  routes: [
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      name: 'register',
      path: '/register',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      name: 'dashboard',
      path: '/dashboard',
      builder: (context, state) => const DashboardView(),
      routes: [
        GoRoute(
          name: 'businessDetails',
          path: 'business/:id',
          builder: (context, state) => BusinessDetailsView(
            businessId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      name: 'map',
      path: '/map',
      builder: (context, state) => const MapView(),
    ),
    GoRoute(
      name: 'profile',
      path: '/profile/:userId',
      builder: (context, state) => UserProfileView(
        userId: state.pathParameters['userId']!,
      ),
    ),
  ],
);

bool _checkAuthStatus() {
  // Lógica para verificar si hay sesión activa
  final token = CacheService().getToken();
  return token != null;
}
```

## Configuración de API

### Variables de Entorno

Crear archivo `.env` en la raíz:

```env
API_BASE_URL_DEV=http://localhost:3000/api/v1
API_BASE_URL_PROD=https://api.cimareviews.com/v1
MAPS_USER_AGENT=CimaReviewsAndroid/1.0
```

### Servicio API Base

**`lib/data/services/api_service.dart`**
```dart
class ApiService {
  static const String _baseUrlDev = 'http://localhost:3000/api/v1';
  static const String _baseUrlProd = 'https://api.cimareviews.com/v1';
  
  static String get baseUrl => 
      kReleaseMode ? _baseUrlProd : _baseUrlDev;
  
  final http.Client _client;
  final String _token;
  
  ApiService({http.Client? client, String? token})
      : _client = client ?? http.Client(),
        _token = token ?? '';
  
  Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await _client.get(
      uri,
      headers: _buildHeaders(),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> post(String endpoint, dynamic body) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await _client.post(
      uri,
      headers: _buildHeaders(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }
  
  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
      'X-Platform': 'Android',
      'X-App-Version': '1.0.0',
    };
  }
  
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw ApiException(
      'Error ${response.statusCode}: ${response.body}',
      statusCode: response.statusCode,
    );
  }
}
```

## Mapa con OpenStreetMap (Android Optimizado)

### Configuración Android

**`android/app/src/main/AndroidManifest.xml`**
```xml
<!-- Permisos necesarios -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### ViewModel del Mapa

**`lib/ui/viewmodels/map/map_viewmodel.dart`**
```dart
class MapViewModel extends ChangeNotifier {
  final BusinessRepository _businessRepository;
  final LocationService _locationService;
  
  List<Business> _nearbyBusinesses = [];
  GeoPoint? _currentLocation;
  bool _isLoading = false;
  
  MapViewModel(this._businessRepository, this._locationService);
  
  List<Business> get nearbyBusinesses => _nearbyBusinesses;
  GeoPoint? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  
  Future<void> loadNearbyBusinesses() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final businesses = await _businessRepository.getBusinesses();
      _nearbyBusinesses = businesses;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> getCurrentLocation() async {
    final position = await _locationService.getCurrentPosition();
    _currentLocation = GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    notifyListeners();
  }
  
  Future<List<MarkerIcon>> getMarkers() async {
    return _nearbyBusinesses.map((business) {
      return MarkerIcon(
        icon: _getBusinessIcon(business),
      );
    }).toList();
  }
  
  Widget _getBusinessIcon(Business business) {
    // Personalización según categoría y rating
    Color color;
    IconData icon;
    
    if (business.avgRating >= 4.5) {
      color = Colors.green;
    } else if (business.avgRating >= 3.0) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }
    
    return Icon(Icons.restaurant, color: color, size: 30);
  }
}
```

## Base de Datos Local

### Esquema SQLite

```sql
-- Negocios
CREATE TABLE businesses (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  owner_id TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  avg_rating REAL DEFAULT 0,
  category TEXT,
  phone TEXT,
  address TEXT,
  last_updated INTEGER
);

-- Reseñas
CREATE TABLE reviews (
  id TEXT PRIMARY KEY,
  business_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  rating INTEGER NOT NULL CHECK(rating >= 1 AND rating <= 5),
  comment TEXT,
  images TEXT, -- JSON array de URLs
  created_at INTEGER,
  FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE
);

-- Índices para rendimiento
CREATE INDEX idx_businesses_location ON businesses(latitude, longitude);
CREATE INDEX idx_reviews_business ON reviews(business_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
```

## Pruebas

### Estructura de Tests

```
test/
├── unit/
│   ├── models/          # Pruebas de modelos
│   ├── services/        # Pruebas de servicios (mockeando HTTP/DB)
│   ├── repositories/    # Pruebas de repositorios
│   └── viewmodels/      # Pruebas de ViewModels
├── widget/              # Pruebas de widgets
└── integration/         # Pruebas de integración (API real)
```

### Ejemplo de Prueba

**`test/unit/viewmodels/login_viewmodel_test.dart`**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late LoginViewModel viewModel;
  late MockUserRepository mockRepo;
  
  setUp(() {
    mockRepo = MockUserRepository();
    viewModel = LoginViewModel(mockRepo);
  });
  
  group('LoginViewModel', () {
    test('login exitoso debe retornar true', () async {
      // Arrange
      when(() => mockRepo.login('test@email.com', '1234'))
          .thenAnswer((_) async => Session(token: 'fake', user: User.mock()));
      
      // Act
      final result = await viewModel.login();
      
      // Assert
      expect(result, true);
      expect(viewModel.errorMessage, isNull);
    });
    
    test('login fallido debe mostrar error', () async {
      // Arrange
      when(() => mockRepo.login('wrong@email.com', 'wrong'))
          .thenThrow(AuthException('Credenciales inválidas'));
      
      // Act
      final result = await viewModel.login();
      
      // Assert
      expect(result, false);
      expect(viewModel.errorMessage, contains('inválidas'));
    });
  });
}
```

### Ejecutar Pruebas

```bash
# Todas las pruebas
flutter test

# Pruebas específicas
flutter test test/unit/viewmodels/

# Con cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Solución de Problemas Comunes

### Error de permisos en Android

```bash
# Limpiar y reconstruir
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Problemas con OSM en Android

```gradle
// android/app/build.gradle
android {
    defaultConfig {
        minSdkVersion 21  // OSM requiere API 21+
        multiDexEnabled true
    }
}
```

### Error de conexión a API

```dart
// Verificar URL base en diferentes entornos
const bool isProduction = bool.fromEnvironment('dart.vm.product');
const apiUrl = isProduction 
    ? 'https://api.cimareviews.com/v1'
    : 'http://10.0.2.2:3000/api/v1'; // Para emulador Android
```

## Contribución

Para añadir nuevas features:

1. **Modelo**: Crear en `/data/models`
2. **Servicio**: Implementar en `/data/services` (si es nueva fuente de datos)
3. **Repositorio**: Orquestar en `/data/repositories`
4. **ViewModel**: Lógica en `/ui/viewmodels`
5. **View**: UI en `/ui/views`
6. **Widget reusable**: En `/ui/widgets`
7. **Ruta**: Registrar en `/app/routes.dart`
8. **Pruebas**: Añadir tests unitarios

## Documentación Adicional

- [Flutter Documentation](https://docs.flutter.dev)
- [Riverpod Documentation](https://riverpod.dev)
- [OpenStreetMap Flutter](https://pub.dev/packages/flutter_osm_plugin)
- [SQLite en Flutter](https://pub.dev/packages/sqflite)

---

**Versión del README**: 2.0  
**Última actualización**: 2026-05-07  
**Compatibilidad**: Flutter 3.16+ | Android API 21+ | Dart 3.2+
```
