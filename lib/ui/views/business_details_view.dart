import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/product.dart';
import 'package:cimareviews/data/models/review.dart';
import 'package:cimareviews/ui/viewmodels/business_details_viewmodel.dart';
import 'package:cimareviews/ui/views/write_review_view.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class BusinessDetailsView extends StatefulWidget {
  const BusinessDetailsView({super.key, required this.business});

  final Business business;

  @override
  State<BusinessDetailsView> createState() => _BusinessDetailsViewState();
}

class _BusinessDetailsViewState extends State<BusinessDetailsView> {
  late final BusinessDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BusinessDetailsViewModel(initialBusiness: widget.business);
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadDetails();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final business = _viewModel.business;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _viewModel.loadDetails,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _HeroImage(business: business),
                if (_viewModel.error != null)
                  _ErrorBanner(
                    message: _viewModel.error!,
                    onRetry: _viewModel.loadDetails,
                  ),
                _BusinessSummary(business: business),
                _ProductsSection(
                  business: business,
                  onOpenMenu: _openBusinessMenu,
                ),
                const SizedBox(height: 16),
                _ReviewsSection(
                  reviews: business.reviews,
                  canDeleteReview: _viewModel.canDeleteReview,
                  deletingReviewId: _viewModel.deletingReviewId,
                  onDeleteReview: _deleteReview,
                ),
                const SizedBox(height: 104),
              ],
            ),
          ),
          if (_viewModel.isLoading)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(minHeight: 3),
            ),
          Positioned(
            left: 79,
            right: 79,
            bottom: 24,
            child: FigmaButton(
              label: 'Escribir Resena',
              icon: Icons.add,
              onPressed: () async {
                final created = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute<bool>(
                    builder: (context) => WriteReviewView(business: business),
                  ),
                );
                if (created == true && mounted) {
                  setState(() {});
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteReview(Review review) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar resena'),
          content: const Text('Esta accion quitara la resena del negocio.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB91C1C),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final deleted = await _viewModel.deleteReview(review);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deleted
              ? 'Resena eliminada.'
              : _viewModel.error ?? 'No se pudo eliminar la resena.',
        ),
      ),
    );
  }

  Future<void> _openBusinessMenu(Business business) async {
    await Navigator.pushNamed(context, '/business-menu', arguments: business);

    if (mounted) {
      setState(() {});
    }
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}

class _BusinessSummary extends StatelessWidget {
  const _BusinessSummary({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final description = business.description?.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 1, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register-report'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: Colors.red,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Reportar Negocio'),
            ),
          ),
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
          const SizedBox(height: 12),
          if (business.categories.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in business.categories)
                  _InfoPill(label: category.toString()),
              ],
            ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              description,
              style: const TextStyle(
                color: cimaMuted,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 18),
          _LocationButton(business: business),
        ],
      ),
    );
  }
}

class _LocationButton extends StatelessWidget {
  const _LocationButton({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final lat = business.location.latitude.toStringAsFixed(5);
    final lng = business.location.longitude.toStringAsFixed(5);

    return SizedBox(
      width: double.infinity,
      height: 52.5,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/map'),
        icon: const Icon(Icons.location_on_outlined, size: 20),
        label: Text('Ver Ubicacion ($lat, $lng)'),
        style: OutlinedButton.styleFrom(
          backgroundColor: cimaSurface,
          foregroundColor: cimaGreen,
          side: const BorderSide(color: cimaBorder),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _ProductsSection extends StatelessWidget {
  const _ProductsSection({required this.business, required this.onOpenMenu});

  final Business business;
  final ValueChanged<Business> onOpenMenu;

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
                onPressed: () => onOpenMenu(business),
                child: const Text('Ver menu'),
              ),
            ],
          ),
          if (business.products.isEmpty)
            const _EmptySectionMessage(
              message: 'Este negocio aun no tiene productos.',
            )
          else
            for (final product in business.products)
              _ProductRow(product: product),
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final description = product.description?.trim();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: cimaBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (description != null && description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: cimaMuted, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
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
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({
    required this.reviews,
    required this.canDeleteReview,
    required this.deletingReviewId,
    required this.onDeleteReview,
  });

  final List<Review> reviews;
  final bool Function(Review review) canDeleteReview;
  final String? deletingReviewId;
  final ValueChanged<Review> onDeleteReview;

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
          if (reviews.isEmpty)
            const _EmptySectionMessage(message: 'Todavia no hay resenas.')
          else
            for (int index = 0; index < reviews.length; index++)
              _ReviewCard(
                review: reviews[index],
                index: index,
                canDelete: canDeleteReview(reviews[index]),
                isDeleting: deletingReviewId == reviews[index].id,
                onDelete: () => onDeleteReview(reviews[index]),
              ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.review,
    required this.index,
    required this.canDelete,
    required this.isDeleting,
    required this.onDelete,
  });

  final Review review;
  final int index;
  final bool canDelete;
  final bool isDeleting;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
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
                _reviewDate(review),
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
              if (canDelete)
                TextButton.icon(
                  onPressed: isDeleting ? null : onDelete,
                  icon: isDeleting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline, size: 18),
                  label: Text(isDeleting ? 'Eliminando' : 'Eliminar'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB91C1C),
                  ),
                ),
            ],
          ),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, imageIndex) => NetworkImageBox(
                  url: review.images[imageIndex],
                  width: 72,
                  height: 72,
                  borderRadius: BorderRadius.circular(8),
                ),
                separatorBuilder: (context, imageIndex) =>
                    const SizedBox(width: 8),
                itemCount: review.images.length,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _reviewDate(Review review) {
    final createdAt = review.createdAt;
    if (createdAt == null) {
      final times = ['hace 2 dias', 'hace 1 semana', 'hace 2 semanas'];
      return times[index % times.length];
    }

    return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        border: Border.all(color: cimaGreen),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: cimaGreen,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptySectionMessage extends StatelessWidget {
  const _EmptySectionMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Text(message, style: const TextStyle(color: cimaMuted)),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFFCA5A5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
