import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/ui/viewmodels/register_business_viewmodel.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class RegisterBusinessView extends StatefulWidget {
  const RegisterBusinessView({super.key});

  @override
  State<RegisterBusinessView> createState() => _RegisterBusinessViewState();
}

class _RegisterBusinessViewState extends State<RegisterBusinessView> {
  late final RegisterBusinessViewModel _viewModel;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = RegisterBusinessViewModel()..addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submit() async {
    final registered = await _viewModel.registerBusiness();
    if (!mounted) {
      return;
    }

    if (registered) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Negocio registrado.')));
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushReplacementNamed(context, '/my-businesses');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Registrar Negocio'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  FigmaField(
                    label: 'Nombre del negocio',
                    hint: 'Cafe Cima',
                    controller: _nameController,
                    enabled: !_viewModel.isLoading,
                    textInputAction: TextInputAction.next,
                    onChanged: _viewModel.updateName,
                  ),
                  FigmaField(
                    label: 'Descripcion',
                    hint: 'Breve descripcion',
                    lines: 4,
                    controller: _descriptionController,
                    enabled: !_viewModel.isLoading,
                    onChanged: _viewModel.updateDescription,
                  ),
                  const _FieldLabel(label: 'Categoria'),
                  const SizedBox(height: 8),
                  _CategoryDropdown(
                    value: _viewModel.selectedCategory,
                    enabled: !_viewModel.isLoading,
                    onChanged: _viewModel.selectCategory,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FigmaField(
                          label: 'Latitud',
                          hint: '32.5308',
                          controller: _latitudeController,
                          enabled: !_viewModel.isLoading,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: _viewModel.updateLatitude,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FigmaField(
                          label: 'Longitud',
                          hint: '-116.9824',
                          controller: _longitudeController,
                          enabled: !_viewModel.isLoading,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: _viewModel.updateLongitude,
                        ),
                      ),
                    ],
                  ),
                  FigmaField(
                    label: 'URL de imagen',
                    hint: 'https://...',
                    controller: _imageUrlController,
                    enabled: !_viewModel.isLoading,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    onChanged: _viewModel.updateImageUrl,
                    onSubmitted: (_) => _submit(),
                  ),
                  if (_viewModel.errors.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    _ErrorList(errors: _viewModel.errors),
                    const SizedBox(height: 16),
                  ] else
                    const SizedBox(height: 18),
                  FigmaButton(
                    label: _viewModel.isLoading
                        ? 'Creando...'
                        : 'Crear Negocio',
                    icon: Icons.storefront_outlined,
                    onPressed: _viewModel.isLoading ? null : _submit,
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

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final Category? value;
  final bool enabled;
  final ValueChanged<Category?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Category>(
      initialValue: value,
      isExpanded: true,
      items: [
        for (final category in Category.values)
          DropdownMenuItem(value: category, child: Text(category.toString())),
      ],
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: cimaSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF374151),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ErrorList extends StatelessWidget {
  const _ErrorList({required this.errors});

  final List<String> errors;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final error in errors)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                error,
                style: const TextStyle(
                  color: Color(0xFF991B1B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
