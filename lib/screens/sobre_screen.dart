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
            titulo: 'O problema',
            texto:
                'Buracos, lixo descartado, postes apagados e ruas que alagam '
                'afetam a segurança e a saúde de milhões de pessoas. Muitas '
                'vezes o cidadão não sabe como reportar, e o poder público não '
                'tem uma visão clara de onde agir primeiro.',
          ),
          const SizedBox(height: 12),
          const _BlocoTexto(
            titulo: 'Para quem',
            texto:
                'Moradores, associações de bairro e agentes públicos de '
                'zeladoria urbana.',
          ),
          const SizedBox(height: 12),
          const _BlocoTexto(
            titulo: 'A solução',
            texto:
                'Registre o problema com categoria, local e gravidade. '
                'Acompanhe o status até a solução e veja os indicadores do '
                'bairro no painel.',
          ),
          const SizedBox(height: 32),
          const SectionTitle('Objetivos de Desenvolvimento Sustentável'),
          for (final ods in odsAtendidos) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OdsBadge(ods: ods),
                    const SizedBox(height: 12),
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
  const _BlocoTexto({required this.titulo, required this.texto});

  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(texto),
          ],
        ),
      ),
    );
  }
}
