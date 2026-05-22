import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/ui/viewmodels/home_viewmodel.dart';
import 'package:cimareviews/ui/views/business_details_view.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:cimareviews/ui/widgets/navbar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _viewModel = HomeViewModel();
  final _searchController = TextEditingController();

  static const _images = [
    'https://www.figma.com/api/mcp/asset/c2741bcc-8193-481f-9832-e31831eb2f48',
    'https://www.figma.com/api/mcp/asset/54e58995-c1ba-4d70-bc2c-6dff2c53ff22',
    'https://www.figma.com/api/mcp/asset/448e9e2f-d4e6-4032-8c00-540e711c7d2b',
  ];

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadBusinesses();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final businesses = _viewModel.businesses;

    return CimaNavigationScaffold(
      currentIndex: 0,
      child: SafeArea(
        child: Column(
          children: [
            _SearchBar(
              controller: _searchController,
              isSearching: _viewModel.isSearching,
              onChanged: _viewModel.updateSearchQuery,
              onClear: () {
                _searchController.clear();
                _viewModel.clearSearch();
              },
            ),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            _CategoryRow(
              categories: _viewModel.categories,
              selectedCategory: _viewModel.selectedCategory,
              onSelected: _viewModel.selectCategory,
            ),
            Expanded(child: _buildBody(context, businesses)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Business> businesses) {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.error != null && businesses.isEmpty) {
      return _HomeMessage(
        icon: Icons.wifi_off_outlined,
        title: 'No se pudieron cargar los negocios',
        message: _viewModel.error!,
        actionLabel: 'Reintentar',
        onAction: _viewModel.loadBusinesses,
      );
    }

    if (businesses.isEmpty) {
      return const _HomeMessage(
        icon: Icons.storefront_outlined,
        title: 'Sin resultados',
        message: 'Prueba con otra busqueda o categoria.',
      );
    }

    return RefreshIndicator(
      onRefresh: _viewModel.loadBusinesses,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemBuilder: (context, index) {
          final business = businesses[index];
          return _BusinessCard(
            business: business,
            imageUrl: business.imageUrl ?? _images[index % _images.length],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusinessDetailsView(business: business),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: businesses.length,
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.isSearching,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool isSearching;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 50.5,
        decoration: BoxDecoration(
          color: cimaSurface,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search, color: Color(0xFF6B7280), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (isSearching)
              const Padding(
                padding: EdgeInsets.only(right: 14),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (controller.text.isNotEmpty)
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close, size: 20),
                color: cimaMuted,
                tooltip: 'Limpiar busqueda',
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<Category> categories;
  final Category? selectedCategory;
  final ValueChanged<Category?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _CategoryChip(
            label: 'Todos',
            selected: selectedCategory == null,
            onTap: () => onSelected(null),
          ),
          for (final category in categories)
            _CategoryChip(
              label: category.toString(),
              selected: selectedCategory == category,
              onTap: () => onSelected(category),
            ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 43,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? cimaGreen : cimaSurface,
          border: Border.all(
            color: selected ? cimaGreen : const Color(0xFFB2A5A5),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _BusinessCard extends StatelessWidget {
  const _BusinessCard({
    required this.business,
    required this.imageUrl,
    required this.onTap,
  });

  final Business business;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 252,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 3)],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkImageBox(url: imageUrl, height: 160),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          business.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: cimaText,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(Icons.star, size: 18, color: cimaStar),
                      const SizedBox(width: 4),
                      Text(
                        business.avgRating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: cimaText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _subtitleFor(business),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: cimaMuted, fontSize: 14),
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

  String _subtitleFor(Business business) {
    final description = business.description?.trim();
    if (description != null && description.isNotEmpty) {
      return description;
    }
    if (business.categories.isNotEmpty) {
      return business.categories
          .map((category) => category.toString())
          .join(', ');
    }
    return 'Negocio de comida';
  }
}

class _HomeMessage extends StatelessWidget {
  const _HomeMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: cimaMuted, size: 42),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: cimaText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: cimaMuted),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
