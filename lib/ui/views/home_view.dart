import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/repositories/business_repository.dart';
import 'package:cimareviews/ui/views/business_details_view.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:cimareviews/ui/widgets/navbar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.title});

  final String title;

  static const _images = [
    'https://www.figma.com/api/mcp/asset/c2741bcc-8193-481f-9832-e31831eb2f48',
    'https://www.figma.com/api/mcp/asset/54e58995-c1ba-4d70-bc2c-6dff2c53ff22',
    'https://www.figma.com/api/mcp/asset/448e9e2f-d4e6-4032-8c00-540e711c7d2b',
  ];

  @override
  Widget build(BuildContext context) {
    final businesses = BusinessRepository.instance.getBusinesses();

    return CimaNavigationScaffold(
      currentIndex: 0,
      child: SafeArea(
        child: Column(
          children: [
            const _SearchBar(),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const _CategoryRow(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemBuilder: (context, index) {
                  final business = businesses[index];
                  return _BusinessCard(
                    business: business,
                    imageUrl: _images[index % _images.length],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BusinessDetailsView(business: business),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: businesses.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

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
        child: const Row(
          children: [
            SizedBox(width: 16),
            Icon(Icons.search, color: Color(0xFF6B7280), size: 20),
            SizedBox(width: 12),
            Text(
              'Buscar...',
              style: TextStyle(color: Color(0x80111827), fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: const [
          _CategoryChip(label: 'Cafe'),
          _CategoryChip(label: 'Vegano'),
          _CategoryChip(label: 'Comida rapida'),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cimaSurface,
        border: Border.all(color: const Color(0xFFB2A5A5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF374151),
          fontSize: 14,
          fontWeight: FontWeight.w500,
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
                      _subtitleFor(business.name),
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

  String _subtitleFor(String name) {
    if (name.toLowerCase().contains('chick')) {
      return 'Pollo frito';
    }
    if (name.toLowerCase().contains('tonka')) {
      return 'Tortas';
    }
    return 'Su tiempo es nuestro tiempo';
  }
}
