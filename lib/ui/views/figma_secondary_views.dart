import 'package:cimareviews/data/repositories/business_repository.dart';
import 'package:cimareviews/ui/views/business_details_view.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cimaGreen,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/CimaReviewsIcon.png',
              width: 147,
              height: 119,
              color: Colors.white,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Color(0xFFE8DEF8),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text(
                'Continuar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterSuccessView extends StatelessWidget {
  const RegisterSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FDF4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: cimaGreen,
                  size: 48,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Registro exitoso!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              const Text(
                'Se le ha enviado un correo de verificacion.',
                textAlign: TextAlign.center,
                style: TextStyle(color: cimaMuted, fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 40),
              FigmaButton(
                label: 'Volver al inicio de sesion',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                ),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () {},
                child: const Text('Reenviar Correeo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventDetailsView extends StatelessWidget {
  const EventDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimpleScaffold(
      title: 'Bazar FCQI',
      body: [
        _InfoBlock(
          title: '25 de Abril del 2026',
          text: 'Ven a disfrutar de todo tipo de productos.',
        ),
        _InfoBlock(
          title: 'Negocios participantes',
          text: 'Sushito, Michoacana, Mundo Otaku y Brownies Deli.',
        ),
      ],
    );
  }
}

class MyBusinessesView extends StatelessWidget {
  const MyBusinessesView({super.key});

  @override
  Widget build(BuildContext context) {
    final businesses = BusinessRepository.instance.getBusinesses();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Mis Negocios'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  FigmaButton(
                    label: 'Registrar Negocio',
                    icon: Icons.add,
                    onPressed: () =>
                        Navigator.pushNamed(context, '/register-business'),
                  ),
                  const SizedBox(height: 16),
                  for (final business in businesses)
                    Card(
                      child: ListTile(
                        title: Text(business.name),
                        subtitle: Text(
                          '${business.avgRating.toStringAsFixed(1)} estrellas',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BusinessDetailsView(business: business),
                          ),
                        ),
                      ),
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

class MyReviewsView extends StatelessWidget {
  const MyReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimpleScaffold(
      title: 'Mis resenas',
      body: [
        _InfoBlock(title: 'D’Volada', text: 'Muy buenos frappes'),
        _InfoBlock(title: 'Tortas Tonka', text: 'Excelente servicio.'),
      ],
    );
  }
}

class BusinessMenuView extends StatelessWidget {
  const BusinessMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final products = BusinessRepository.instance.getBusiness('1').products;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Menu'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final product in products)
                    ListTile(
                      title: Text(product.name),
                      trailing: Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: cimaGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  FigmaButton(
                    label: 'Agregar Producto',
                    icon: Icons.add,
                    onPressed: () =>
                        Navigator.pushNamed(context, '/add-product'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/add-category'),
                    child: const Text('Agregar Categoria'),
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

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProductEditor(
      title: 'Agregar Producto',
      button: 'Agregar Producto',
      onSubmit: () => Navigator.pop(context),
    );
  }
}

class EditProductView extends StatelessWidget {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProductEditor(
      title: 'Editar Producto',
      button: 'Guardar Cambios',
      onSubmit: () => Navigator.pop(context),
    );
  }
}

class AddCategoryView extends StatelessWidget {
  const AddCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Agregar Categoria'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Seleccionar Categoria',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Seleciona de las categorias populares',
                    style: TextStyle(color: cimaMuted),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _Pill('Coffee'),
                      _Pill('Tea'),
                      _Pill('Drinks'),
                      _Pill('Snacks'),
                      _Pill('Meals'),
                      _Pill('Breakfast'),
                      _Pill('Lunch'),
                      _Pill('Dinner'),
                      _Pill('Desserts'),
                      _Pill('Pastries'),
                      _Pill('Sandwiches'),
                      _Pill('Salads'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const FigmaField(
                    label: 'Crear Nueva Categoria',
                    hint: 'ej. Bebidas especiales',
                  ),
                  FigmaButton(
                    label: 'Agregar Categoria',
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

class _ProductEditor extends StatelessWidget {
  const _ProductEditor({
    required this.title,
    required this.button,
    required this.onSubmit,
  });

  final String title;
  final String button;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            BackHeader(title: title),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const FigmaField(
                    label: 'Nombre',
                    hint: 'Nombre del producto',
                  ),
                  const FigmaField(label: 'Precio', hint: '\$50'),
                  const FigmaField(
                    label: 'Descripcion',
                    hint: 'Descripcion breve',
                    lines: 4,
                  ),
                  FigmaButton(label: button, onPressed: onSubmit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleScaffold extends StatelessWidget {
  const _SimpleScaffold({required this.title, required this.body});

  final String title;
  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            BackHeader(title: title),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(text),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: () {}, child: Text(label));
  }
}
