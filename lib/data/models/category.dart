enum Category {
  vegano,
  cafeteria,
  asiatica,
  ramen,
  mexicana,
  desayunos,
  panaderia,
  sushi,
  pizza,
  hamburguesas,
  tacos,
  italiana,
  ensaladas,
  postres;

  @override
  String toString() {
    switch (this) {
      case Category.vegano:
        return 'Vegano';
      case Category.cafeteria:
        return 'Cafeteria';
      case Category.asiatica:
        return 'Asiatica';
      case Category.ramen:
        return 'Ramen';
      case Category.mexicana:
        return 'Mexicana';
      case Category.desayunos:
        return 'Desayunos';
      case Category.panaderia:
        return 'Panaderia';
      case Category.sushi:
        return 'Sushi';
      case Category.pizza:
        return 'Pizza';
      case Category.hamburguesas:
        return 'Hamburguesas';
      case Category.tacos:
        return 'Tacos';
      case Category.italiana:
        return 'Italiana';
      case Category.ensaladas:
        return 'Ensaladas';
      case Category.postres:
        return 'Postres';
    }
  }
}
