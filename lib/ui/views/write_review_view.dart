import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class WriteReviewView extends StatefulWidget {
  const WriteReviewView({super.key});

  @override
  State<WriteReviewView> createState() => _WriteReviewViewState();
}

class _WriteReviewViewState extends State<WriteReviewView> {
  int rating = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Escribir Resena'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'D’Volada',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Tu Puntuacion',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (index) {
                      final value = index + 1;
                      return IconButton(
                        onPressed: () => setState(() => rating = value),
                        icon: Icon(
                          Icons.star,
                          color: value <= rating ? cimaStar : cimaBorder,
                          size: 38,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 26),
                  const FigmaField(
                    label: 'Comentario',
                    hint: 'Comparte tu experiencia...',
                    lines: 6,
                  ),
                  const SizedBox(height: 18),
                  FigmaButton(
                    label: 'Enviar Resena',
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
