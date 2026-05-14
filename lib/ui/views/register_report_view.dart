import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class RegisterReportView extends StatelessWidget {
  const RegisterReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Reporte'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'D’volada',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ayudanos a mantener nuestra comunidad sana',
                    style: TextStyle(color: cimaMuted, fontSize: 14),
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    'Razon del reporte',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 52.5,
                    decoration: BoxDecoration(
                      color: cimaSurface,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: cimaMuted,
                    ),
                  ),
                  const SizedBox(height: 26),
                  const FigmaField(
                    label: 'Detalles',
                    hint: 'Porporciona detalles del reporte...',
                    lines: 6,
                  ),
                  const SizedBox(height: 18),
                  FigmaButton(
                    label: 'Enviar Reporte',
                    onPressed: () => Navigator.pop(context),
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
