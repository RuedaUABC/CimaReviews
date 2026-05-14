import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:cimareviews/ui/widgets/navbar.dart';
import 'package:flutter/material.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  static const _events = [
    _EventData(
      title: 'Bazar FCQI',
      date: '25 de Abril del 2026',
      description: 'Ven a disfrutar de todo tipo de productos',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/c0f729cd-1e92-442b-be87-3b0bf27270eb',
      businesses: ['Sushito', 'Michoacana', 'Mundo Otaku', 'Brownies Deli'],
    ),
    _EventData(
      title: 'Evento 2',
      date: 'Fecha',
      description: 'Descripcion',
      imageUrl: '',
      businesses: ['Student Union Cafe', 'Campus Coffee House'],
    ),
    _EventData(
      title: 'Coffee Tasting Event',
      date: 'April 28, 2026',
      description: 'Learn about coffee origins and brewing methods',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/260933ba-7fb0-4967-a373-84af20d8cc66',
      businesses: ['Campus Coffee House'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CimaNavigationScaffold(
      currentIndex: 1,
      child: Column(
        children: [
          const SafeArea(
            bottom: false,
            child: FigmaHeader(title: 'Eventos', green: true),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemBuilder: (context, index) {
                return _EventCard(
                  event: _events[index],
                  onTap: () => Navigator.pushNamed(context, '/event-details'),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: _events.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventData {
  const _EventData({
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrl,
    required this.businesses,
  });

  final String title;
  final String date;
  final String description;
  final String imageUrl;
  final List<String> businesses;
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onTap});

  final _EventData event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
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
            event.imageUrl.isEmpty
                ? Container(height: 140, color: Colors.black)
                : NetworkImageBox(url: event.imageUrl, height: 140),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: cimaText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: cimaGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        event.date,
                        style: const TextStyle(
                          color: cimaGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.description,
                    style: const TextStyle(color: cimaMuted, fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cimaSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Negocios participantes',
                          style: TextStyle(color: cimaMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final business in event.businesses)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  business,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                          ],
                        ),
                      ],
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
}
