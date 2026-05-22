import 'dart:async';

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../data/models/business.dart';
import '../../data/models/category.dart';
import '../../data/services/api_service.dart';
import '../../data/services/business_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({BusinessService? businessService})
    : _businessService = businessService ?? BusinessService();

  final BusinessService _businessService;

  final List<Business> _allBusinesses = [];
  final List<Business> _searchResults = [];
  Timer? _searchDebounce;

  bool isLoading = false;
  bool isSearching = false;
  String? error;
  String searchQuery = '';
  Category? selectedCategory;

  List<Business> get businesses {
    final source = searchQuery.trim().length >= 2
        ? _searchResults
        : _allBusinesses;

    if (selectedCategory == null) {
      return List.unmodifiable(source);
    }

    return List.unmodifiable(
      source.where(
        (business) => business.categories.contains(selectedCategory),
      ),
    );
  }

  List<Category> get categories {
    final values = <Category>{};
    for (final business in _allBusinesses) {
      values.addAll(business.categories);
    }
    return values.toList()
      ..sort((a, b) => a.toString().compareTo(b.toString()));
  }

  Future<void> loadBusinesses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final businesses = await _businessService.getBusinesses(limit: 100);
      _allBusinesses
        ..clear()
        ..addAll(businesses);
      _searchResults.clear();
    } on ApiException catch (exception) {
      error = exception.message;
    } catch (_) {
      error =
          'No se pudieron cargar los negocios. Revisa la API e intentalo de nuevo.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(Category? category) {
    selectedCategory = selectedCategory == category ? null : category;
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    searchQuery = value;
    error = null;
    _searchDebounce?.cancel();

    if (searchQuery.trim().length < 2) {
      _searchResults.clear();
      isSearching = false;
      notifyListeners();
      return;
    }

    isSearching = true;
    notifyListeners();
    _searchDebounce = Timer(const Duration(milliseconds: 350), _runSearch);
  }

  Future<void> _runSearch() async {
    final query = searchQuery.trim();
    if (query.length < 2) {
      isSearching = false;
      notifyListeners();
      return;
    }

    try {
      final results = await _businessService.searchBusinesses(query);
      if (query != searchQuery.trim()) {
        return;
      }
      _searchResults
        ..clear()
        ..addAll(results);
    } on ApiException catch (exception) {
      error = exception.message;
      _searchResults.clear();
    } catch (_) {
      error = 'No se pudo completar la busqueda.';
      _searchResults.clear();
    } finally {
      if (query == searchQuery.trim()) {
        isSearching = false;
        notifyListeners();
      }
    }
  }

  void clearSearch() {
    searchQuery = '';
    _searchResults.clear();
    _searchDebounce?.cancel();
    isSearching = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
