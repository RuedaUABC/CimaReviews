import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                const FigmaField(
                  label: 'Correo',
                  hint: 'tu.correo@uabc.edu.mx',
                ),
                const FigmaField(
                  label: 'Contrasena',
                  hint: '........',
                  obscure: true,
                ),
                const SizedBox(height: 8),
                FigmaButton(
                  label: 'Log in',
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
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
