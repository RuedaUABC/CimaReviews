import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:cimareviews/ui/viewmodels/register_user_viewmodel.dart';
import 'package:flutter/material.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  final _viewModel = RegisterUserViewModel();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submit() async {
    _viewModel
      ..name = _nameController.text
      ..email = _emailController.text
      ..password = _passwordController.text
      ..confirmPassword = _confirmPasswordController.text;

    final registered = await _viewModel.register();
    if (!mounted || !registered) {
      return;
    }

    Navigator.pushReplacementNamed(context, '/register-success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 65),
              Image.asset(
                'images/CimaReviewsIcon.png',
                width: 119,
                height: 96,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 22),
              const Text(
                'Registrarse',
                style: TextStyle(
                  color: cimaGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .48,
                ),
              ),
              const SizedBox(height: 26),
              FigmaField(
                label: 'Nombre',
                hint: 'Tu nombre',
                controller: _nameController,
                enabled: !_viewModel.isLoading,
                textInputAction: TextInputAction.next,
              ),
              FigmaField(
                label: 'Correo',
                hint: 'tu.correo@uabc.edu.mx',
                controller: _emailController,
                enabled: !_viewModel.isLoading,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              FigmaField(
                label: 'Contrasena',
                hint: '........',
                obscure: true,
                controller: _passwordController,
                enabled: !_viewModel.isLoading,
                textInputAction: TextInputAction.next,
              ),
              FigmaField(
                label: 'Confirmar contrasena',
                hint: '........',
                obscure: true,
                controller: _confirmPasswordController,
                enabled: !_viewModel.isLoading,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Soy',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _RoleButton(
                      label: 'Cliente',
                      selected: !_viewModel.seller,
                      onTap: _viewModel.isLoading
                          ? null
                          : () => setState(() => _viewModel.seller = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _RoleButton(
                      label: 'Vendedor',
                      selected: _viewModel.seller,
                      onTap: _viewModel.isLoading
                          ? null
                          : () => setState(() => _viewModel.seller = true),
                    ),
                  ),
                ],
              ),
              if (_viewModel.errors.isNotEmpty) ...[
                const SizedBox(height: 16),
                _RegisterErrors(errors: _viewModel.errors),
              ],
              const SizedBox(height: 24),
              FigmaButton(
                label: _viewModel.isLoading ? 'Registrando...' : 'Registrarse',
                onPressed: _viewModel.isLoading ? null : _submit,
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _viewModel.isLoading
                    ? null
                    : () => Navigator.pop(context),
                child: const Text('Ya tienes una cuenta? Inicia sesion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 52.5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? cimaGreen : cimaSurface,
          border: selected ? null : Border.all(color: cimaBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF374151),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _RegisterErrors extends StatelessWidget {
  const _RegisterErrors({required this.errors});

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
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                error,
                style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
