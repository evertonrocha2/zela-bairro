import 'package:flutter/material.dart';

import '../core/constants/ods.dart';
import '../widgets/ods_badge.dart';
import '../widgets/section_title.dart';

/// Tela 5: sobre o projeto, o problema real e os ODS conectados.
class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o ZelaBairro')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _BlocoTexto(
            icone: Icons.report_problem_outlined,
            titulo: 'O problema',
            texto:
                'Buracos, lixo descartado, postes apagados e ruas que alagam '
                'afetam a segurança e a saúde de milhões de pessoas. Muitas '
                'vezes o cidadão não sabe como reportar, e o poder público não '
                'tem uma visão clara de onde agir primeiro.',
          ),
          const SizedBox(height: 12),
          const _BlocoTexto(
            icone: Icons.groups_outlined,
            titulo: 'Para quem',
            texto:
                'Moradores, associações de bairro e agentes públicos de '
                'zeladoria urbana, de grandes centros a pequenas cidades.',
          ),
          const SizedBox(height: 12),
          const _BlocoTexto(
            icone: Icons.lightbulb_outline,
            titulo: 'A solução',
            texto:
                'Um app simples para registrar o problema com categoria, local '
                'e gravidade, acompanhar o status até a solução e enxergar '
                'indicadores do bairro em um painel.',
          ),
          const SizedBox(height: 24),
          const SectionTitle('Objetivos de Desenvolvimento Sustentável'),
          for (final ods in odsAtendidos) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OdsBadge(ods: ods),
                    const SizedBox(height: 10),
                    Text(ods.titulo, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(ods.comoAtendemos),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          Center(
            child: Text(
              'FIAP · Desafio CitizenTech 2026',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlocoTexto extends StatelessWidget {
  const _BlocoTexto({
    required this.icone,
    required this.titulo,
    required this.texto,
  });

  final IconData icone;
  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(texto),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
