import 'package:cimareviews/ui/widgets/figma_primitives.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const FigmaHeader(title: 'Panel de Administracion'),
            Container(
              height: 121,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: cimaSurface,
                border: Border(bottom: BorderSide(color: cimaBorder)),
              ),
              child: const Row(
                children: [
                  _MetricCard(value: '142', label: 'Usuarios'),
                  SizedBox(width: 12),
                  _MetricCard(value: '28', label: 'Negocios'),
                  SizedBox(width: 12),
                  _MetricCard(value: '5', label: 'Reportes', danger: true),
                ],
              ),
            ),
            Container(
              height: 74,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: cimaBorder)),
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: cimaSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    _AdminTab(label: 'Usuarios'),
                    _AdminTab(label: 'Negocios'),
                    _AdminTab(label: 'Reportes', selected: true),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  _ReportCard(
                    reason: 'Insalubridad',
                    authorLabel: 'Autor',
                    author: 'Aberto Rueda',
                    reportedLabel: 'Reportado',
                    reported: 'D’volada',
                    type: 'Negocio',
                  ),
                  _ReportCard(
                    reason: 'Spam',
                    authorLabel: 'Reporter',
                    author: 'Yamir Moreno',
                    reportedLabel: 'Reported',
                    reported: 'Alberto Rueda',
                    type: 'Resena',
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

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.value,
    required this.label,
    this.danger = false,
  });

  final String value;
  final String label;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: cimaBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: danger ? const Color(0xFFDC2626) : cimaGreen,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: cimaMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _AdminTab extends StatelessWidget {
  const _AdminTab({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 41,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? cimaGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : cimaMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.reason,
    required this.authorLabel,
    required this.author,
    required this.reportedLabel,
    required this.reported,
    required this.type,
  });

  final String reason;
  final String authorLabel;
  final String author;
  final String reportedLabel;
  final String reported;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFFCA5A5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              reason,
              style: const TextStyle(
                color: Color(0xFFDC2626),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _ReportLine(label: authorLabel, value: author),
          _ReportLine(label: reportedLabel, value: reported),
          Text('Tipo: $type', style: const TextStyle(color: cimaMuted)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cimaGreen,
                    side: const BorderSide(color: cimaGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Revisar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Ignorar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportLine extends StatelessWidget {
  const _ReportLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF374151), fontSize: 14),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
