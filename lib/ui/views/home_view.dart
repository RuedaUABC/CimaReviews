import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _searchField(),
            _categorySection(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
                    child: Text(
                      'Negocios',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Imagen (Container estilizado)
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Container(
                                    height: 140,
                                    width: double.infinity,
                                    color: _getCardColor(index),
                                    child: Center(
                                      child: Icon(
                                        _getCardIcon(index),
                                        size: 50,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                // Contenido de texto
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getCardTitle(index),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.3,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getCardSubtitle(index),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (_getCardDescription(index).isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          _getCardDescription(index),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[500],
                                            fontStyle: FontStyle.italic,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  // Funciones helper para los datos de las cards
  Color _getCardColor(int index) {
    final colors = [
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
      Colors.red.shade400,
      Colors.blue.shade400,
      Colors.amber.shade400,
      Colors.indigo.shade400,
      Colors.pink.shade400,
      Colors.cyan.shade400,
    ];
    return colors[index % colors.length];
  }

  IconData _getCardIcon(int index) {
    const icons = [
      Icons.restaurant,
      Icons.local_cafe,
      Icons.fastfood,
      Icons.icecream,
      Icons.lunch_dining,
      Icons.bakery_dining,
      Icons.ramen_dining,
      Icons.local_pizza,      // ← Cambiado: Icons.pizza no existe, usar Icons.local_pizza
      Icons.set_meal,          // ← Cambiado: Icons.sushi no existe, usar Icons.set_meal
      Icons.breakfast_dining,
    ];
    return icons[index % icons.length];
  }

  String _getCardTitle(int index) {
    const titles = [
      "D'Volada",
      "Chick In",
      "TORTAS TONKA",
      "Café Vegano",
      "Burritos MX",
      "Sushi House",
      "Pizza Planet",
      "Taco Loco",
      "Green Bowl",
      "Sweet Home",
    ];
    return titles[index % titles.length];
  }

  String _getCardSubtitle(int index) {
    const subtitles = [
      "CAFÉ & SMOOTHIES",
      "Pollo frito",
      "Recíen hecho mas sabroso.",
      "Comida saludable",
      "Comida mexicana",
      "Comida japonesa",
      "Pizza artesanal",
      "Tacos y más",
      "Comida vegana",
      "Postres",
    ];
    return subtitles[index % subtitles.length];
  }

  String _getCardDescription(int index) {
    const descriptions = [
      "Su tiempo es nuestro tiempo",
      "El mejor pollo frito de la ciudad",
      "Hecho al momento con ingredientes frescos",
      "Para los amantes del café vegano",
      "Sabores auténticos de México",
      "Pescado fresco y rolls especiales",
      "Masa madre y ingredientes premium",
      "Tacos al pastor, suadero y más",
      "Comida 100% vegetal",
      "Los mejores postres artesanales",
    ];
    return descriptions[index % descriptions.length];
  }
}

class _categorySection extends StatelessWidget {
  const _categorySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 8),
          child: Text(
            'Categoria',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 55,
          margin: const EdgeInsets.only(top: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Text(
                    _getCategoryName(index),
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getCategoryName(int index) {
    const categories = [
      "Cafés",
      "Comida rápida",
      "Restaurantes",
      "Vegano",
      "Postres",
      "Mexicano",
      "Italiano",
      "Japonés",
      "Bebidas",
      "Desayunos",
    ];
    return categories[index % categories.length];
  }
}

class _searchField extends StatelessWidget {
  const _searchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: 'Buscar...',
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}