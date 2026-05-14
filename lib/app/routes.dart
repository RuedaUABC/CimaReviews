import 'package:flutter/material.dart';
import 'package:cimareviews/ui/views/dashboard_view.dart';
import 'package:cimareviews/ui/views/events_view.dart';
import 'package:cimareviews/ui/views/figma_secondary_views.dart';
import 'package:cimareviews/ui/views/home_view.dart';
import 'package:cimareviews/ui/views/login_view.dart';
import 'package:cimareviews/ui/views/map_view.dart';
import 'package:cimareviews/ui/views/register_business_view.dart';
import 'package:cimareviews/ui/views/register_report_view.dart';
import 'package:cimareviews/ui/views/register_user_view.dart';
import 'package:cimareviews/ui/views/user_profile_view.dart';
import 'package:cimareviews/ui/views/write_review_view.dart';

Map<String, WidgetBuilder> routes() {
  return {
    '/': (context) => const LoginView(),
    '/splash': (context) => const SplashView(),
    '/login': (context) => const LoginView(),
    '/register': (context) => const RegisterUserView(),
    '/register-success': (context) => const RegisterSuccessView(),
    '/home': (context) => const HomeView(title: 'CimaReviews'),
    '/dashboard': (context) => const DashboardView(),
    '/map': (context) => const MapView(),
    '/events': (context) => const EventsView(),
    '/event-details': (context) => const EventDetailsView(),
    '/profile': (context) => const UserProfileView(),
    '/my-businesses': (context) => const MyBusinessesView(),
    '/my-reviews': (context) => const MyReviewsView(),
    '/business-menu': (context) => const BusinessMenuView(),
    '/add-product': (context) => const AddProductView(),
    '/edit-product': (context) => const EditProductView(),
    '/add-category': (context) => const AddCategoryView(),
    '/register-business': (context) => const RegisterBusinessView(),
    '/register-report': (context) => const RegisterReportView(),
    '/write-review': (context) => const WriteReviewView(),
  };
}
