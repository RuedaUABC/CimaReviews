import 'package:cimareviews/data/models/business.dart';
import 'package:flutter/material.dart';

class BusinessDetailsView extends StatelessWidget {
  const BusinessDetailsView({super.key, required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  child: business.imageUrl != null && business.imageUrl!.isNotEmpty
                      ? Image.network(
                          business.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Center(child: Icon(Icons.broken_image)),
                          ),
                        )
                      : Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20), // tamaño del círculo
                      ),

                    onPressed: () {Navigator.pop(context);},
                    child: const Icon(Icons.arrow_back)
                  )
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20), // tamaño del círculo
                      ),

                    onPressed: () {},
                    child: const Icon(Icons.report)
                  )
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.zero,  
                      title: Text(
                        business.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(business.avgRating.toStringAsFixed(1), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () {},
                    child: _DetailChipRow(icon: Icons.location_on_outlined , label: "Ver Ubicación")
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Productos',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  business.products.isEmpty
                      ? const Text(
                          'No hay productos registrados.',
                          style: TextStyle(fontSize: 16),
                        )
                      : Column(
                          children: business.products
                              .map(
                                (product) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(product.name),
                                  trailing: Text(
                                    '\$ ${product.price.toStringAsFixed(2)}',
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailChipRow extends StatelessWidget {
  const _DetailChipRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
