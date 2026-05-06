import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/ui/viewmodels/home_viewmodel.dart';
import 'package:cimareviews/ui/views/business_details_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewmodel _viewModel = HomeViewmodel();
  late final List<Business> _businesses;
  late final List<String> _categoryNames;

  @override
  void initState() {
    super.initState();
    _businesses = _viewModel.getBusinesses();
    _categoryNames = _viewModel.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _SearchField(),
            _CategorySection(categoryNames: _categoryNames),
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
                      itemCount: _businesses.length,
                      itemBuilder: (context, index) {
                        final business = _businesses[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _openBusinessDetails(business),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getBusinessTitle(business),
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
                                        _getBusinessSubtitle(business),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _getBusinessDescription(business),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[500],
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          )
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
      Icons.local_pizza,
      Icons.set_meal,
      Icons.breakfast_dining,
    ];
    return icons[index % icons.length];
  }

  String _getBusinessTitle(Business business) {
    return business.name;
  }

  String _getBusinessSubtitle(Business business) {
    if (business.categories.isEmpty) {
      return 'Sin categoría';
    }
    return business.categories.map(_categoryDisplayName).join(' · ');
  }

  String _getBusinessDescription(Business business) {
    final reviewCount = business.reviews.length;
    final reviewText = reviewCount == 0 ? 'Sin reseñas' : '$reviewCount reseñas';
    return '${business.avgRating.toStringAsFixed(1)} · $reviewText';
  }

  String _categoryDisplayName(Category category) {
    return category.toString();
  }

  void _openBusinessDetails(Business business) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessDetailsView(business: business),
      ),
    );
  }
}


class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.categoryNames});

  final List<String> categoryNames;

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
            itemCount: categoryNames.length,
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
                    categoryNames[index],
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
}

class _SearchField extends StatelessWidget {

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