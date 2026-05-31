import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/ui/viewmodels/write_review_viewmodel.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class WriteReviewView extends StatefulWidget {
  const WriteReviewView({super.key, this.business});

  final Business? business;

  @override
  State<WriteReviewView> createState() => _WriteReviewViewState();
}

class _WriteReviewViewState extends State<WriteReviewView> {
  final _commentController = TextEditingController();
  WriteReviewViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) {
      return;
    }

    _initialized = true;
    final argument = ModalRoute.of(context)?.settings.arguments;
    final business =
        widget.business ?? (argument is Business ? argument : null);
    if (business != null) {
      _viewModel = WriteReviewViewModel(business: business)
        ..addListener(_onViewModelChanged);
    }
  }

  @override
  void dispose() {
    _viewModel?.removeListener(_onViewModelChanged);
    _viewModel?.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submit() async {
    final viewModel = _viewModel;
    if (viewModel == null) {
      return;
    }

    final submitted = await viewModel.submitReview();
    if (!mounted) {
      return;
    }

    if (submitted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Resena enviada.')));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = _viewModel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: viewModel == null
            ? const _MissingBusinessState()
            : Column(
                children: [
                  const BackHeader(title: 'Escribir resena'),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          viewModel.business.name,
                          style: const TextStyle(
                            color: cimaText,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Tu puntuacion',
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _RatingSelector(
                          rating: viewModel.rating,
                          enabled: !viewModel.isLoading,
                          onChanged: viewModel.setRating,
                        ),
                        const SizedBox(height: 26),
                        FigmaField(
                          label: 'Comentario',
                          hint: 'Comparte tu experiencia...',
                          lines: 6,
                          controller: _commentController,
                          enabled: !viewModel.isLoading,
                          onChanged: viewModel.updateComment,
                          onSubmitted: (_) => _submit(),
                        ),
                        if (viewModel.errorMessage != null) ...[
                          const SizedBox(height: 2),
                          _ErrorMessage(message: viewModel.errorMessage!),
                        ],
                        const SizedBox(height: 18),
                        FigmaButton(
                          label: viewModel.isLoading
                              ? 'Enviando...'
                              : 'Enviar resena',
                          icon: Icons.send_outlined,
                          onPressed: viewModel.isLoading ? null : _submit,
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

class _RatingSelector extends StatelessWidget {
  const _RatingSelector({
    required this.rating,
    required this.enabled,
    required this.onChanged,
  });

  final int rating;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final value = index + 1;
        return IconButton(
          tooltip: '$value estrellas',
          onPressed: enabled ? () => onChanged(value) : null,
          icon: Icon(
            Icons.star,
            color: value <= rating ? cimaStar : cimaBorder,
            size: 38,
          ),
        );
      }),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        color: Color(0xFFB91C1C),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _MissingBusinessState extends StatelessWidget {
  const _MissingBusinessState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BackHeader(title: 'Escribir resena'),
        const Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No se encontro el negocio para crear la resena.',
                textAlign: TextAlign.center,
                style: TextStyle(color: cimaMuted),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
