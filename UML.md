# UML

```mermaid
classDiagram
    direction TB
    
    %% ============================
    %% ENUMERATIONS
    %% ============================
    class Role {
        <<enumeration>>
        ADMIN
        MODERATOR
        SELLER
        CUSTOMER
    }
    
    class Category {
        <<enumeration>>
        VEGANO
        CAFETERIA
        ASIATICA
        RAMEN
        MEXICANA
        DESAYUNOS
        PANADERIA
        SUSHI
        PIZZA
        HAMBURGUESAS
        TACOS
        ITALIANA
        ENSALADAS
        POSTRES
    }
    
    class ReportStatus {
        <<enumeration>>
        PENDING
        REVIEWED
        RESOLVED
        REJECTED
    }
    
    %% ============================
    %% CORE MODELS (Entidades)
    %% ============================
    class Location {
        +double lat
        +double lng
    }
    
    class User {
        +String id
        +String name
        +String email
        +List~Role~ roles
        +DateTime created_at
    }
    
    class Session {
        +String token
        +User user
        +DateTime expires_at
    }
    
    class Business {
        +String id
        +String name
        +String owner_id
        +Location location
        +double avg_rating
        +List~Category~ categories
        +String? description
        +double? distance_km
    }
    
    class BusinessDetail {
        +String id
        +String name
        +String owner_id
        +Location location
        +double avg_rating
        +List~Category~ categories
        +String? description
        +double? distance_km
        +List~Product~ products
        +List~Review~ reviews
    }
    
    class Product {
        +String name
        +double price
        +String? description
    }
    
    class Review {
        +String id
        +String business_id
        +String user_id
        +double rating
        +String comment
        +List~String~? images
        +DateTime created_at
        +User? user
    }
    
    class Report {
        +String id
        +String reason
        +String reporter_id
        +String reported_user_id
        +String? business_id
        +String? review_id
        +ReportStatus status
        +DateTime created_at
    }
    
    class Event {
        +String id
        +String title
        +String description
        +DateTime date
        +List~String~ business_ids
        +String image_url
    }
    
    %% ============================
    %% BASE SERVICE
    %% ============================
    class ApiService {
        -http.Client _client
        -String _baseUrl
        -String? _token
        +setToken(String token) void
        -Map _buildHeaders()
        -dynamic _handleResponse(Response response)
        #Future~T~ get~T~(String endpoint, Map params)
        #Future~T~ post~T~(String endpoint, dynamic body)
        #Future~T~ put~T~(String endpoint, dynamic body)
        #Future~T~ patch~T~(String endpoint, dynamic body)
        #Future~void~ delete(String endpoint)
    }
    
    %% ============================
    %% AUTH SERVICE (Métodos agrupados)
    %% ============================
    class AuthService {
        -ApiService _api
        -CacheService _cache
        
        %% Autenticación
        +Future~Session~ login(String email, String password)
        +Future~User~ register(String name, String email, String password)
        +Future~void~ logout()
        +Future~Session~ refreshToken(String refreshToken)
        
        %% Gestión de contraseña
        +Future~void~ changePassword(String oldPassword, String newPassword)
        +Future~void~ forgotPassword(String email)
        
        %% Estado de sesión
        +bool isAuthenticated()
        +Session? getCurrentSession()
        
        -Future~void~ _saveSession(Session session)
    }
    
    %% ============================
    %% USER SERVICE (Métodos agrupados)
    %% ============================
    class UserService {
        -ApiService _api
        -CacheService _cache
        -DatabaseService _db
        
        %% Perfil personal
        +Future~User~ getMyProfile()
        +Future~User~ updateMyProfile(String? name, String? email, List~Role~? roles)
        
        %% Perfiles de otros usuarios
        +Future~User~ getUserProfile(String userId)
        +Future~List~User~~ listUsers(int skip, int limit)
        
        %% Reseñas de usuario
        +Future~List~Review~~ getUserReviews(String userId)
        
        %% Utilidades
        +User? getCachedUser()
        +bool isLoggedIn()
        -Future~void~ _cacheUser(User user)
    }
    
    %% ============================
    %% BUSINESS SERVICE (Métodos agrupados)
    %% ============================
    class BusinessService {
        -ApiService _api
        -DatabaseService _db
        -CacheService _cache
        -LocationService _location
        
        %% CRUD de negocios
        +Future~List~Business~~ getBusinesses(int skip, int limit)
        +Future~BusinessDetail~ getBusiness(String id)
        +Future~BusinessDetail~ createBusiness(
            String name, 
            String ownerId, 
            Location location, 
            List~Category~ categories, 
            String? description, 
            List~Product~? products
        )
        +Future~BusinessDetail~ updateBusiness(
            String id, 
            String? name, 
            Location? location, 
            List~Category~? categories, 
            String? description, 
            List~Product~? products
        )
        +Future~void~ deleteBusiness(String id)
        
        %% Búsqueda y filtrado
        +Future~List~Business~~ searchBusinesses(String query)
        +Future~List~Business~~ getNearbyBusinesses(double lat, double lng, double radius)
        +Future~List~Business~~ getBusinessesByCategory(Category category)
        
        %% Sincronización
        -Future~void~ _syncWithServer()
        -Future~void~ _refreshInBackground()
    }
    
    %% ============================
    %% REVIEW SERVICE (Métodos agrupados)
    %% ============================
    class ReviewService {
        -ApiService _api
        -DatabaseService _db
        
        %% CRUD de reseñas
        +Future~List~Review~~ getReviews(int skip, int limit)
        +Future~Review~ getReview(String id)
        +Future~Review~ createReview(
            String businessId, 
            double rating, 
            String comment, 
            List~String~? images
        )
        +Future~Review~ updateReview(
            String id, 
            double? rating, 
            String? comment, 
            List~String~? images
        )
        +Future~void~ deleteReview(String id)
        
        %% Reseñas por negocio
        +Future~List~Review~~ getReviewsByBusiness(String businessId, int skip, int limit)
        
        %% Estadísticas
        +Future~double~ getAverageRating(String businessId)
        +Future~Map~ getRatingDistribution(String businessId)
    }
    
    %% ============================
    %% REPORT SERVICE (Métodos agrupados)
    %% ============================
    class ReportService {
        -ApiService _api
        
        %% CRUD de reportes
        +Future~List~Report~~ getReports(int skip, int limit)
        +Future~Report~ getReport(String id)
        +Future~Report~ createReport(
            String reason, 
            String reporterId, 
            String reportedUserId, 
            String? businessId, 
            String? reviewId
        )
        +Future~Report~ updateReport(String id, String? reason, ReportStatus? status)
        
        %% Filtrado de reportes
        +Future~List~Report~~ getReportsByUser(String userId)
        +Future~List~Report~~ getPendingReports()
        +Future~List~Report~~ getResolvedReports()
    }
    
    %% ============================
    %% EVENT SERVICE (Métodos agrupados)
    %% ============================
    class EventService {
        -ApiService _api
        -DatabaseService _db
        
        %% CRUD de eventos
        +Future~List~Event~~ getEvents(int skip, int limit)
        +Future~Event~ getEvent(String id)
        +Future~Event~ createEvent(
            String title, 
            String description, 
            DateTime date, 
            List~String~ businessIds, 
            String imageUrl
        )
        +Future~Event~ updateEvent(
            String id, 
            String? title, 
            String? description, 
            DateTime? date, 
            List~String~? businessIds, 
            String? imageUrl
        )
        +Future~void~ deleteEvent(String id)
        
        %% Filtrado de eventos
        +Future~List~Event~~ getUpcomingEvents()
        +Future~List~Event~~ getEventsByBusiness(String businessId)
        +Future~List~Event~~ getEventsByDateRange(DateTime start, DateTime end)
    }
    
    %% ============================
    %% DATABASE SERVICE
    %% ============================
    class DatabaseService {
        -Database _db
        
        %% Negocios
        +Future~List~Business~~ getCachedBusinesses()
        +Future~BusinessDetail?~ getCachedBusiness(String id)
        +Future~void~ cacheBusinesses(List~Business~ businesses)
        +Future~void~ cacheBusinessDetail(BusinessDetail business)
        +Future~void~ deleteCachedBusiness(String id)
        
        %% Reseñas
        +Future~List~Review~~ getCachedReviewsByBusiness(String businessId)
        +Future~void~ cacheReview(Review review)
        +Future~void~ deleteCachedReview(String id)
        
        %% Usuarios
        +Future~User?~ getCachedUser(String id)
        +Future~void~ cacheUser(User user)
        
        %% Eventos
        +Future~List~Event~~ getCachedEvents()
        +Future~void~ cacheEvent(Event event)
        +Future~void~ deleteCachedEvent(String id)
        
        %% Limpieza
        +Future~void~ clearAll()
        +Future~void~ clearExpiredCache()
        
        -Future~void~ _initDatabase()
        -Future~void~ _onCreate(Database db, int version)
    }
    
    %% ============================
    %% CACHE SERVICE
    %% ============================
    class CacheService {
        -SharedPreferences _prefs
        
        %% Tokens
        +Future~void~ setToken(String token)
        +String? getToken()
        +Future~void~ setRefreshToken(String token)
        +String? getRefreshToken()
        
        %% Usuario y sesión
        +Future~void~ setUser(User user)
        +User? getUser()
        +Future~void~ setSession(Session session)
        +Session? getSession()
        
        %% Preferencias
        +Future~void~ setLastSync(DateTime date)
        +DateTime? getLastSync()
        +Future~void~ setPreferences(String key, dynamic value)
        +dynamic getPreferences(String key)
        
        %% Limpieza
        +Future~void~ clear()
        +Future~void~ clearAuthData()
        
        -Future~void~ _init()
    }
    
    %% ============================
    %% LOCATION SERVICE
    %% ============================
    class LocationService {
        -GeolocatorPlatform _geolocator
        
        %% Posición actual
        +Future~Position~ getCurrentPosition()
        +Future~String~ getCurrentAddress()
        
        %% Búsqueda y geocodificación
        +Future~List~Address~~ searchAddress(String query)
        +Future~String~ getAddressFromCoordinates(double lat, double lon)
        
        %% Cálculos
        +double calculateDistance(double lat1, double lon1, double lat2, double lon2)
        +double calculateRadius(double lat, double lon, double radiusKm)
        
        %% Permisos
        +Future~bool~ checkPermissions()
        +Future~bool~ requestPermissions()
    }
    
    %% ============================
    %% VIEWMODELS (Simplificados)
    %% ============================
    class DashboardViewModel {
        -BusinessService _businessService
        -UserService _userService
        +List~Business~ businesses
        +bool isLoading
        +String? error
        +User? currentUser
        +loadBusinesses() Future~void~
        +refresh() Future~void~
        +loadUserData() Future~void~
        +searchBusinesses(String query) Future~void~
        +dispose() void
    }
    
    class BusinessDetailsViewModel {
        -BusinessService _businessService
        -ReviewService _reviewService
        -UserService _userService
        -ReportService _reportService
        +BusinessDetail? business
        +List~Review~ reviews
        +double averageRating
        +bool isLoading
        +bool isOwner
        +String? error
        +loadDetails(String businessId) Future~void~
        +submitReview(double rating, String comment, List~String~? images) Future~bool~
        +deleteReview(String reviewId) Future~void~
        +reportReview(String reviewId, String reason) Future~void~
        +checkIfOwner() Future~bool~
        +dispose() void
    }
    
    class MapViewModel {
        -BusinessService _businessService
        -LocationService _locationService
        +List~Business~ nearbyBusinesses
        +Location? currentLocation
        +bool isLoading
        +double? currentZoom
        +loadNearbyBusinesses(double radius) Future~void~
        +getCurrentLocation() Future~void~
        +searchLocation(String query) Future~Location?~
        +centerOnBusiness(Business business) Future~void~
        +dispose() void
    }
    
    class LoginViewModel {
        -AuthService _authService
        -UserService _userService
        +String email
        +String password
        +bool isLoading
        +bool rememberMe
        +String? errorMessage
        +login() Future~bool~
        +loginWithBiometrics() Future~bool~
        +validateForm() bool
        +clearError() void
        +dispose() void
    }
    
    class RegisterViewModel {
        -AuthService _authService
        +String name
        +String email
        +String password
        +String confirmPassword
        +bool isLoading
        +List~String~ errors
        +register() Future~bool~
        +validateForm() List~String~
        +dispose() void
    }
    
    class UserProfileViewModel {
        -UserService _userService
        -ReviewService _reviewService
        +User? user
        +List~Review~ userReviews
        +bool isLoading
        +bool isEditing
        +loadUserProfile(String userId) Future~void~
        +updateProfile(String? name, String? email, List~Role~? roles) Future~bool~
        +changePassword(String oldPass, String newPass) Future~bool~
        +loadUserReviews() Future~void~
        +toggleEditMode() void
        +dispose() void
    }
    
    class WriteReviewViewModel {
        -ReviewService _reviewService
        +String businessId
        +double rating
        +String comment
        +List~String~ images
        +bool isLoading
        +submitReview() Future~bool~
        +validateForm() bool
        +clearForm() void
        +dispose() void
    }
    
    class EventsViewModel {
        -EventService _eventService
        +List~Event~ events
        +bool isLoading
        +String? error
        +loadEvents() Future~void~
        +refresh() Future~void~
        +getEventsByDate(DateTime date) List~Event~
        +dispose() void
    }
    
    class RegisterBusinessViewModel {
        -BusinessService _businessService
        -LocationService _locationService
        +String name
        +String description
        +Location? location
        +List~Category~ selectedCategories
        +List~Product~ products
        +bool isLoading
        +registerBusiness() Future~bool~
        +searchLocation(String query) Future~void~
        +addProduct(String name, double price, String? description)
        +removeProduct(int index)
        +validateForm() bool
        +dispose() void
    }
    
    %% ============================
    %% VIEWS (UI)
    %% ============================
    class DashboardView {
        +Widget build()
        -Widget _buildBusinessList()
        -Widget _buildAppBar()
        -void _onBusinessTap(Business business)
        -Future~void~ _onRefresh()
    }
    
    class BusinessDetailsView {
        +String businessId
        +Widget build()
        -Widget _buildHeader()
        -Widget _buildRatingSection()
        -Widget _buildReviewsList()
        -Widget _buildWriteReviewButton()
        -void _onWriteReview()
    }
    
    class MapView {
        +Widget build()
        -void _onMapCreated(MapController controller)
        -void _addMarkers()
        -void _onMarkerTap(Business business)
        -void _onMyLocationTap()
        -void _showBusinessBottomSheet(Business business)
    }
    
    class LoginView {
        +Widget build()
        -Widget _buildEmailField()
        -Widget _buildPasswordField()
        -Widget _buildLoginButton()
        -void _onLoginPressed()
        -void _onRegisterPressed()
        -void _showError(String message)
    }
    
    class RegisterView {
        +Widget build()
        -Widget _buildNameField()
        -Widget _buildEmailField()
        -Widget _buildPasswordFields()
        -void _onRegisterPressed()
        -void _showErrors(List~String~ errors)
    }
    
    class UserProfileView {
        +String userId
        +Widget build()
        -Widget _buildProfileHeader()
        -Widget _buildUserReviews()
        -Widget _buildEditButton()
        -void _onEditProfile()
        -void _onChangePassword()
    }
    
    class WriteReviewView {
        +String businessId
        +Widget build()
        -Widget _buildRatingBar()
        -Widget _buildCommentField()
        -Widget _buildImagePicker()
        -void _onSubmit()
    }
    
    class EventsView {
        +Widget build()
        -Widget _buildEventList()
        -Widget _buildEventCard(Event event)
        -void _onEventTap(Event event)
    }
    
    class RegisterBusinessView {
        +Widget build()
        -Widget _buildBusinessForm()
        -Widget _buildCategorySelector()
        -Widget _buildLocationPicker()
        -Widget _buildProductsList()
        -void _onSubmit()
        -void _onLocationSelected(Location location)
        -void _onAddProduct()
    }
    
    %% ============================
    %% REUSABLE WIDGETS
    %% ============================
    class RatingStars {
        +double rating
        +double size
        +bool interactive
        +Function(double) onRatingUpdate
        +Widget build()
    }
    
    class BusinessCard {
        +Business business
        +VoidCallback onTap
        +Widget build()
    }
    
    class LoadingIndicator {
        +String? message
        +Widget build()
    }
    
    class CustomAppBar {
        +String title
        +List~Widget~ actions
        +bool showBackButton
        +Widget build()
    }
    
    class ErrorWidget {
        +String message
        +VoidCallback onRetry
        +Widget build()
    }
    
    class CustomBottomNavBar {
        +int currentIndex
        +Function(int) onTap
        +Widget build()
    }
    
    class ProductCard {
        +Product product
        +bool showRemoveButton
        +VoidCallback? onRemove
        +Widget build()
    }
    
    %% ============================
    %% RELATIONSHIPS - MODELOS
    %% ============================
    User "1" *-- "many" Role : tiene
    User "1" --> "1" Session : posee
    User "1" --> "many" Business : es dueño de
    User "1" --> "many" Review : escribe
    User "1" --> "many" Report : realiza
    User "1" --> "many" Report : es reportado en
    
    Business "1" *-- "many" Category : categorizado por
    Business "1" --> "1" User : pertenece a
    Business "1" --> "many" Review : recibe
    Business "1" --> "many" Report : es referenciado en
    
    BusinessDetail "1" *-- "many" Category : categorizado por
    BusinessDetail "1" *-- "many" Product : tiene
    BusinessDetail "1" *-- "many" Review : recibe
    BusinessDetail "1" --> "1" User : pertenece a
    
    Review "1" --> "1" User : escrito por
    Review "1" --> "1" Business : pertenece a
    Review "1" --> "many" Report : es referenciado en
    
    Report "1" --> "1" User : reportado por
    Report "1" --> "1" User : reporta a
    Report "1" --> "1" Business : referencia a
    Report "1" --> "1" Review : referencia a
    
    Event "1" *-- "many" Business : incluye
    
    Product "many" --> "1" BusinessDetail : pertenece a
    
    %% ============================
    %% RELATIONSHIPS - SERVICES
    %% ============================
    AuthService --> ApiService : usa
    AuthService --> CacheService : usa
    
    UserService --> ApiService : usa
    UserService --> CacheService : usa
    UserService --> DatabaseService : usa
    
    BusinessService --> ApiService : usa
    BusinessService --> DatabaseService : usa
    BusinessService --> CacheService : usa
    BusinessService --> LocationService : usa
    
    ReviewService --> ApiService : usa
    ReviewService --> DatabaseService : usa
    
    ReportService --> ApiService : usa
    
    EventService --> ApiService : usa
    EventService --> DatabaseService : usa
    
    ApiService <|-- AuthService : extiende
    ApiService <|-- UserService : extiende
    ApiService <|-- BusinessService : extiende
    ApiService <|-- ReviewService : extiende
    ApiService <|-- ReportService : extiende
    ApiService <|-- EventService : extiende
    
    %% ============================
    %% RELATIONSHIPS - SERVICES TO VIEWMODELS
    %% ============================
    DashboardViewModel --> BusinessService : usa
    DashboardViewModel --> UserService : usa
    
    BusinessDetailsViewModel --> BusinessService : usa
    BusinessDetailsViewModel --> ReviewService : usa
    BusinessDetailsViewModel --> UserService : usa
    BusinessDetailsViewModel --> ReportService : usa
    
    MapViewModel --> BusinessService : usa
    MapViewModel --> LocationService : usa
    
    LoginViewModel --> AuthService : usa
    LoginViewModel --> UserService : usa
    
    RegisterViewModel --> AuthService : usa
    
    UserProfileViewModel --> UserService : usa
    UserProfileViewModel --> ReviewService : usa
    
    WriteReviewViewModel --> ReviewService : usa
    
    EventsViewModel --> EventService : usa
    
    RegisterBusinessViewModel --> BusinessService : usa
    RegisterBusinessViewModel --> LocationService : usa
    
    %% ============================
    %% RELATIONSHIPS - VIEW TO VIEWMODEL
    %% ============================
    DashboardView --> DashboardViewModel : watches
    BusinessDetailsView --> BusinessDetailsViewModel : watches
    MapView --> MapViewModel : watches
    LoginView --> LoginViewModel : watches
    RegisterView --> RegisterViewModel : watches
    UserProfileView --> UserProfileViewModel : watches
    WriteReviewView --> WriteReviewViewModel : watches
    EventsView --> EventsViewModel : watches
    RegisterBusinessView --> RegisterBusinessViewModel : watches
    
    %% ============================
    %% RELATIONSHIPS - VIEW TO WIDGETS
    %% ============================
    DashboardView ..> BusinessCard : usa
    DashboardView ..> LoadingIndicator : usa
    DashboardView ..> ErrorWidget : usa
    DashboardView ..> CustomAppBar : usa
    DashboardView ..> CustomBottomNavBar : usa
    
    BusinessDetailsView ..> RatingStars : usa
    BusinessDetailsView ..> LoadingIndicator : usa
    BusinessDetailsView ..> ErrorWidget : usa
    BusinessDetailsView ..> CustomAppBar : usa
    
    MapView ..> LoadingIndicator : usa
    MapView ..> ErrorWidget : usa
    MapView ..> CustomAppBar : usa
    
    LoginView ..> LoadingIndicator : usa
    LoginView ..> ErrorWidget : usa
    
    RegisterView ..> LoadingIndicator : usa
    RegisterView ..> ErrorWidget : usa
    
    UserProfileView ..> LoadingIndicator : usa
    UserProfileView ..> ErrorWidget : usa
    UserProfileView ..> CustomAppBar : usa
    
    WriteReviewView ..> RatingStars : usa
    WriteReviewView ..> LoadingIndicator : usa
    
    EventsView ..> LoadingIndicator : usa
    EventsView ..> ErrorWidget : usa
    EventsView ..> CustomAppBar : usa
    
    RegisterBusinessView ..> LoadingIndicator : usa
    RegisterBusinessView ..> ErrorWidget : usa
    RegisterBusinessView ..> CustomAppBar : usa
    RegisterBusinessView ..> ProductCard : usa
```
