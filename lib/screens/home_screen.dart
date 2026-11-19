import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/ods.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../models/ocorrencia.dart';
import '../providers/ocorrencia_provider.dart';
import '../utils/formatters.dart';
import '../widgets/ods_badge.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_card.dart';

/// Tela 1: Dashboard CitizenTech com indicadores consumidos via Provider.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _abrirLista(BuildContext context, [StatusOcorrencia? filtro]) {
    context.read<OcorrenciaProvider>().filtrarPorStatus(filtro);
    Navigator.pushNamed(context, AppRoutes.lista);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OcorrenciaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ZelaBairro'),
        actions: [
          IconButton(
            tooltip: 'Sobre o projeto e ODS',
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.sobre),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: provider.carregar,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            const _HeroBanner(),
            const SizedBox(height: 32),
            SectionTitle(
              'Panorama do bairro',
              trailing: provider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
            _GradeIndicadores(
              provider: provider,
              onTapStatus: (s) => _abrirLista(context, s),
            ),
            const SizedBox(height: 12),
            _CardResolucao(provider: provider),
            const SizedBox(height: 32),
            if (provider.porCategoria.isNotEmpty) ...[
              const SectionTitle('Problemas por categoria'),
              _CardCategorias(porCategoria: provider.porCategoria),
              const SizedBox(height: 32),
            ],
            FilledButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.formulario),
              child: const Text('Reportar novo problema'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _abrirLista(context),
              child: const Text('Ver todas as ocorrências'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaria,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reporte problemas do seu bairro e acompanhe até a solução.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'ODS da ONU atendidos',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final ods in odsAtendidos)
                OdsBadge(ods: ods, compacto: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradeIndicadores extends StatelessWidget {
  const _GradeIndicadores({required this.provider, required this.onTapStatus});

  final OcorrenciaProvider provider;
  final ValueChanged<StatusOcorrencia?> onTapStatus;

  @override
  Widget build(BuildContext context) {
    final cards = [
      StatCard(
        label: 'Total reportado',
        valor: '${provider.total}',
        cor: AppTheme.primaria,
        onTap: () => onTapStatus(null),
      ),
      for (final s in StatusOcorrencia.values)
        StatCard(
          label: s.label,
          valor: '${provider.contarPorStatus(s)}',
          cor: s.color,
          onTap: () => onTapStatus(s),
        ),
    ];

    return Column(
      children: [
        for (var i = 0; i < cards.length; i += 2) ...[
          Row(
            children: [
              Expanded(child: cards[i]),
              const SizedBox(width: 12),
              Expanded(child: cards[i + 1]),
            ],
          ),
          if (i + 2 < cards.length) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _CardResolucao extends StatelessWidget {
  const _CardResolucao({required this.provider});

  final OcorrenciaProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urgentes = provider.urgentes;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Taxa de resolução',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Text(
                  Formatters.percentual(provider.taxaResolucao),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: StatusOcorrencia.resolvida.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$urgentes ${urgentes == 1 ? 'urgente' : 'urgentes'} '
              'aguardando solução',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: urgentes > 0
                    ? const Color(0xFFC62828)
                    : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardCategorias extends StatelessWidget {
  const _CardCategorias({required this.porCategoria});

  final Map<Categoria, int> porCategoria;

  @override
  Widget build(BuildContext context) {
    final entradas = porCategoria.entries.toList();
    return Card(
      child: Column(
        children: [
          for (var i = 0; i < entradas.length; i++) ...[
            if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              dense: true,
              title: Text(
                entradas[i].key.label,
                style: const TextStyle(fontSize: 14),
              ),
              trailing: Text(
                '${entradas[i].value}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
