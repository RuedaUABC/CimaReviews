import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/repositories/business_repository.dart';

class HomeViewmodel {
  final businessRepository = BusinessRepository.instance;

  List<Business> getBusinesses() {
    return businessRepository.getBusinesses();
  }

  List<String> getBusinessNames() {
    return businessRepository.businesses.map((b) => b.name).toList();
  }

  List<double> getBusinessRatings() {
    return businessRepository.businesses.map((b) => b.avgRating).toList();
  }

  List<String> getCategories() {
    final categories = <Category>{};
    for (final business in businessRepository.businesses) {
      categories.addAll(business.categories);
    }
    return categories.map(_categoryDisplayName).toList();
  }

  String _categoryDisplayName(Category category) {
    switch (category) {
      case Category.VEGANO:
        return 'Vegano';
      case Category.CAFETERIA:
        return 'Cafeteria';
      case Category.ASIATICA:
        return 'Asiatica';
      case Category.RAMEN:
        return 'Ramen';
      case Category.MEXICANA:
        return 'Mexicana';
      case Category.DESAYUNOS:
        return 'Desayunos';
      case Category.PANADERIA:
        return 'Panaderia';
      case Category.SUSHI:
        return 'Sushi';
      case Category.PIZZA:
        return 'Pizza';
      case Category.HAMBURGUESAS:
        return 'Hamburguesas';
      case Category.TACOS:
        return 'Tacos';
      case Category.ITALIANA:
        return 'Italiana';
      case Category.ENSALADAS:
        return 'Ensaladas';
      case Category.POSTRES:
        return 'Postres';
    }
  }
}
