import 'package:cimareviews/data/repositories/business_repository.dart';
import 'package:cimareviews/ui/views/business_details_view.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final business = BusinessRepository.instance.getLocalBusiness('1');

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _MapGrid()),
          const Positioned(top: 225, left: 142, child: _Pin()),
          const Positioned(top: 342, left: 214, child: _Pin()),
          const Positioned(top: 420, left: 70, child: _Pin()),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.chevron_left),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 46.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Color(0x26000000), blurRadius: 4),
                        ],
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 16),
                          Icon(Icons.search, color: cimaMuted, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Buscar negocios',
                            style: TextStyle(color: Color(0x80111827)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 237.5,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Color(0x26000000), blurRadius: 8)],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cimaBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      NetworkImageBox(
                        url: business.imageUrl ?? '',
                        width: 80,
                        height: 80,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              business.name,
                              style: const TextStyle(
                                color: cimaText,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: cimaStar,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  business.avgRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            const Text(
                              'Cafe',
                              style: TextStyle(color: cimaMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  FigmaButton(
                    label: 'Ver Detalles',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BusinessDetailsView(business: business),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.location_on, color: cimaGreen, size: 48);
  }
}

class _MapGrid extends StatelessWidget {
  const _MapGrid();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MapGridPainter());
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF5F3EF),
    );
    final roadLight = Paint()
      ..color = const Color(0xFFD4D2CE)
      ..strokeWidth = 4;
    final roadDark = Paint()
      ..color = const Color(0xFFBFBDB9)
      ..strokeWidth = 5;
    canvas.drawLine(const Offset(108, 0), Offset(108, size.height), roadLight);
    canvas.drawLine(
      Offset(0, size.height * .4),
      Offset(size.width, size.height * .4),
      roadLight,
    );
    canvas.drawLine(const Offset(252, 0), Offset(252, size.height), roadDark);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
