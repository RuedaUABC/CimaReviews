import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  bool seller = false;

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
              const FigmaField(label: 'Nombre', hint: 'Tu nombre'),
              const FigmaField(label: 'Correo', hint: 'tu.correo@uabc.edu.mx'),
              const FigmaField(
                label: 'Contrasena',
                hint: '........',
                obscure: true,
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
                      selected: !seller,
                      onTap: () => setState(() => seller = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _RoleButton(
                      label: 'Vendedor',
                      selected: seller,
                      onTap: () => setState(() => seller = true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FigmaButton(
                label: 'Registrarse',
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  '/register-success',
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => Navigator.pop(context),
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
  final VoidCallback onTap;

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
