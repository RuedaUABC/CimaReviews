import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:cimareviews/ui/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _viewModel = LoginViewModel();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submit() async {
    _viewModel.email = _emailController.text;
    _viewModel.password = _passwordController.text;

    final loggedIn = await _viewModel.login();
    if (!mounted || !loggedIn) {
      return;
    }

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 58),
                Image.asset(
                  'images/CimaReviewsIcon.png',
                  width: 119,
                  height: 96,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 34),
                const Text(
                  'CimaReviews',
                  style: TextStyle(
                    color: cimaGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .48,
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Bienvenido',
                  style: TextStyle(color: cimaMuted, fontSize: 14),
                ),
                const SizedBox(height: 56),
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
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                ),
                if (_viewModel.errorMessage != null) ...[
                  _AuthMessage(message: _viewModel.errorMessage!),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 8),
                FigmaButton(
                  label: _viewModel.isLoading ? 'Iniciando...' : 'Log in',
                  onPressed: _viewModel.isLoading ? null : _submit,
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: _viewModel.isLoading
                      ? null
                      : () => Navigator.pushNamed(context, '/register'),
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthMessage extends StatelessWidget {
  const _AuthMessage({required this.message});

  final String message;

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
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13),
      ),
    );
  }
}
