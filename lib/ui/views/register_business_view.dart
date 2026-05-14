import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class RegisterBusinessView extends StatelessWidget {
  const RegisterBusinessView({super.key});

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
                  const FigmaField(label: 'Nombre del negocio', hint: 'Nombre'),
                  const FigmaField(
                    label: 'Descripcion',
                    hint: 'Breve descripcion',
                    lines: 5,
                  ),
                  const FigmaField(
                    label: 'Ubicacion',
                    hint: 'Cafeteria central local 4',
                  ),
                  const Text(
                    'Business Photo',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: cimaSurface,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 48,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Subir foto',
                          style: TextStyle(
                            color: cimaGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'JPG, PNG hasta 5MB',
                          style: TextStyle(color: cimaMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),
                  FigmaButton(
                    label: 'Crear Negocio',
                    onPressed: () =>
                        Navigator.pushNamed(context, '/my-businesses'),
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
