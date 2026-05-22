import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/event.dart';
import 'package:cimareviews/data/services/api_service.dart';
import 'package:cimareviews/data/services/business_service.dart';
import 'package:cimareviews/ui/views/business_details_view.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class EventDetailsView extends StatefulWidget {
  const EventDetailsView({super.key, this.event});

  final Event? event;

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  final _businessService = BusinessService();
  final List<Business> _businesses = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBusinesses();
  }

  Future<void> _loadBusinesses() async {
    final businessIds = widget.event?.businessIds ?? [];
    if (businessIds.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final businesses = await Future.wait(
        businessIds.map(_businessService.getBusiness),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _businesses
          ..clear()
          ..addAll(businesses);
      });
    } on ApiException catch (exception) {
      if (!mounted) {
        return;
      }
      setState(() => _error = exception.message);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _error = 'No se pudieron cargar los negocios.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEvent = widget.event;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            BackHeader(title: currentEvent?.title ?? 'Evento'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _InfoBlock(
                    title: currentEvent == null
                        ? 'Fecha'
                        : _formatEventDate(currentEvent.date),
                    text: currentEvent?.description ?? 'Detalles del evento.',
                  ),
                  _ParticipantBusinessesSection(
                    businesses: _businesses,
                    isLoading: _isLoading,
                    error: _error,
                    hasBusinessIds:
                        currentEvent?.businessIds.isNotEmpty ?? false,
                    onRetry: _loadBusinesses,
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

String _formatEventDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _ParticipantBusinessesSection extends StatelessWidget {
  const _ParticipantBusinessesSection({
    required this.businesses,
    required this.isLoading,
    required this.error,
    required this.hasBusinessIds,
    required this.onRetry,
  });

  final List<Business> businesses;
  final bool isLoading;
  final String? error;
  final bool hasBusinessIds;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Negocios participantes',
          style: TextStyle(
            color: cimaText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (error != null)
          _InlineError(message: error!, onRetry: onRetry)
        else if (!hasBusinessIds)
          const _InlineMessage(message: 'Sin negocios asignados.')
        else if (businesses.isEmpty)
          const _InlineMessage(message: 'No se encontraron negocios.')
        else
          for (final business in businesses)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ParticipantBusinessCard(business: business),
            ),
      ],
    );
  }
}

class _ParticipantBusinessCard extends StatelessWidget {
  const _ParticipantBusinessCard({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessDetailsView(business: business),
        ),
      ),
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
            NetworkImageBox(url: business.imageUrl ?? '', height: 160),
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
                      _businessSubtitle(business),
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

  String _businessSubtitle(Business business) {
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

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.message});

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

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(text),
      ),
    );
  }
}
