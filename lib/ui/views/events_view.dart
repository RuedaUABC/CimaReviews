import 'package:cimareviews/data/models/event.dart';
import 'package:cimareviews/ui/viewmodels/events_viewmodel.dart';
import 'package:cimareviews/ui/views/event_details_view.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:cimareviews/ui/widgets/navbar.dart';
import 'package:flutter/material.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  final _viewModel = EventsViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadEvents();
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
    return CimaNavigationScaffold(
      currentIndex: 1,
      child: Column(
        children: [
          const SafeArea(
            bottom: false,
            child: FigmaHeader(title: 'Eventos', green: true),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.error != null && _viewModel.events.isEmpty) {
      return _EventsMessage(
        icon: Icons.wifi_off_outlined,
        title: 'No se pudieron cargar los eventos',
        message: _viewModel.error!,
        actionLabel: 'Reintentar',
        onAction: _viewModel.loadEvents,
      );
    }

    if (_viewModel.events.isEmpty) {
      return const _EventsMessage(
        icon: Icons.event_busy_outlined,
        title: 'Sin eventos',
        message: 'Cuando haya eventos disponibles apareceran aqui.',
      );
    }

    return RefreshIndicator(
      onRefresh: _viewModel.refresh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemBuilder: (context, index) {
          final event = _viewModel.events[index];
          return _EventCard(
            event: event,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsView(event: event),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: _viewModel.events.length,
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onTap});

  final Event event;
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
                ? Container(
                    height: 140,
                    color: cimaGreen,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.event,
                      color: Colors.white,
                      size: 42,
                    ),
                  )
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
                        _formatDate(event.date),
                        style: const TextStyle(
                          color: cimaGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (event.description.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      event.description,
                      style: const TextStyle(color: cimaMuted, fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 14),
                  _BusinessIdsBox(businessIds: event.businessIds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessIdsBox extends StatelessWidget {
  const _BusinessIdsBox({required this.businessIds});

  final List<String> businessIds;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          if (businessIds.isEmpty)
            const Text(
              'Sin negocios asignados',
              style: TextStyle(color: cimaMuted, fontSize: 13),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final businessId in businessIds)
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
                      businessId,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _EventsMessage extends StatelessWidget {
  const _EventsMessage({
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

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
