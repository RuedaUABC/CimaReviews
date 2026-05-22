import 'package:cimareviews/ui/viewmodels/user_profile_viewmodel.dart';
import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:cimareviews/ui/widgets/navbar.dart';
import 'package:flutter/material.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final _viewModel = UserProfileViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadCurrentUser();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CimaNavigationScaffold(
      currentIndex: 2,
      child: SafeArea(
        child: Column(
          children: [
            const FigmaHeader(title: 'Perfil'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _ProfileHeader(
                    name: _viewModel.displayName,
                    role: _viewModel.displayRole,
                    error: _viewModel.error,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Menu',
                          style: TextStyle(
                            color: cimaText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _ProfileMenuItem(
                          icon: Icons.home_outlined,
                          title: 'Mis Negocios',
                          subtitle: 'Administra tus negocios',
                          active: true,
                          onTap: () =>
                              Navigator.pushNamed(context, '/my-businesses'),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.star_border,
                          title: 'Mis resenas',
                          subtitle: 'Ve tus resenas',
                          onTap: () =>
                              Navigator.pushNamed(context, '/my-reviews'),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.edit_outlined,
                          title: 'Editar Perfil',
                          subtitle: 'Actualiza tu informacion',
                          onTap: () =>
                              Navigator.pushNamed(context, '/dashboard'),
                        ),
                      ],
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.role,
    required this.error,
  });

  final String name;
  final String role;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 235.5,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFF8D8D8D),
              shape: BoxShape.circle,
              border: Border.all(color: cimaBorder, width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 52),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: cimaText,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              border: Border.all(color: cimaGreen),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role,
              style: const TextStyle(
                color: cimaGreen,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 10),
            Text(
              error!,
              style: const TextStyle(color: cimaMuted, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cimaSurface,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: active ? cimaGreen : cimaSurface,
            border: active ? null : Border.all(color: cimaBorder),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: active ? Colors.white : cimaMuted),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
      ),
    );
  }
}
