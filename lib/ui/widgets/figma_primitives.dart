import 'package:flutter/material.dart';

const cimaGreen = Color(0xFF166534);
const cimaText = Color(0xFF111827);
const cimaMuted = Color(0xFF6B7280);
const cimaSurface = Color(0xFFF9FAFB);
const cimaBorder = Color(0xFFE5E7EB);
const cimaStar = Color(0xFFFACC15);

class FigmaHeader extends StatelessWidget {
  const FigmaHeader({super.key, required this.title, this.green = false});

  final String title;
  final bool green;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: green ? 60 : 69,
      width: double.infinity,
      decoration: BoxDecoration(
        color: green ? cimaGreen : Colors.white,
        border: Border(
          bottom: BorderSide(color: green ? cimaGreen : cimaBorder),
        ),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          color: green ? Colors.white : cimaText,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class BackHeader extends StatelessWidget {
  const BackHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: cimaBorder)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left, size: 28),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              color: cimaText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class FigmaField extends StatelessWidget {
  const FigmaField({
    super.key,
    required this.label,
    required this.hint,
    this.lines = 1,
    this.obscure = false,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final int lines;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            minLines: obscure ? 1 : lines,
            maxLines: obscure ? 1 : lines,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0x99111827)),
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
          ),
        ],
      ),
    );
  }
}

class FigmaButton extends StatelessWidget {
  const FigmaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = cimaGreen,
    this.foregroundColor = Colors.white,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class NetworkImageBox extends StatelessWidget {
  const NetworkImageBox({
    super.key,
    required this.url,
    this.height = 160,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(16)),
    this.fit = BoxFit.cover,
  });

  final String url;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: cimaGreen,
            alignment: Alignment.center,
            child: const Icon(Icons.restaurant, color: Colors.white, size: 42),
          );
        },
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, this.size = 16});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round() ? Icons.star : Icons.star,
          size: size,
          color: index < rating.round() ? cimaStar : cimaBorder,
        );
      }),
    );
  }
}
