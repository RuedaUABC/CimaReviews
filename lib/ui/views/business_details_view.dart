import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/review.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class BusinessDetailsView extends StatelessWidget {
  const BusinessDetailsView({super.key, required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  NetworkImageBox(
                    url: business.imageUrl ?? '',
                    height: 240,
                    borderRadius: BorderRadius.zero,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 12,
                    top: 14,
                    child: Material(
                      color: Colors.white.withValues(alpha: .9),
                      elevation: 2,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.chevron_left),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 1, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/register-report'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.red,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Reportar Negocio'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            business.name,
                            style: const TextStyle(
                              color: cimaText,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Icon(Icons.star, color: cimaStar, size: 24),
                        const SizedBox(width: 6),
                        Text(
                          business.avgRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Su tiempo es nuestro tiempo',
                      style: TextStyle(color: cimaMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 52.5,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/map'),
                        icon: const Icon(Icons.location_on_outlined, size: 20),
                        label: const Text('Ver Ubicacion'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: cimaSurface,
                          foregroundColor: cimaGreen,
                          side: const BorderSide(color: cimaBorder),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _ProductsSection(business: business),
              const SizedBox(height: 16),
              _ReviewsSection(reviews: business.reviews),
              const SizedBox(height: 104),
            ],
          ),
          Positioned(
            left: 79,
            right: 79,
            bottom: 24,
            child: FigmaButton(
              label: 'Escribir Resena',
              icon: Icons.add,
              onPressed: () => Navigator.pushNamed(context, '/write-review'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsSection extends StatelessWidget {
  const _ProductsSection({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cimaSurface,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Productos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/business-menu'),
                child: const Text('Ver menu'),
              ),
            ],
          ),
          for (final product in business.products)
            Container(
              height: 47.5,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: cimaBorder)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: cimaGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.reviews});

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Resenas recientes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Ver todas')),
            ],
          ),
          const SizedBox(height: 4),
          for (int index = 0; index < reviews.length; index++)
            _ReviewCard(review: reviews[index], index: index),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.index});

  final Review review;
  final int index;

  @override
  Widget build(BuildContext context) {
    final times = ['hace 2 dias', 'hace 1 semana', 'hace 2 semanas'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cimaSurface,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.author.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                times[index % times.length],
                style: const TextStyle(color: cimaMuted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          StarRating(rating: review.rating, size: 14),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  review.comment,
                  style: const TextStyle(color: Color(0xFF374151)),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/register-report'),
                child: const Text('Reportar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
