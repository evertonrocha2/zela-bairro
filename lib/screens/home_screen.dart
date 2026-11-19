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
        title: const Row(
          children: [
            Icon(Icons.location_city),
            SizedBox(width: 8),
            Text('ZelaBairro'),
          ],
        ),
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
            const SizedBox(height: 20),
            SectionTitle(
              'Panorama do bairro',
              trailing: provider.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
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
            const SizedBox(height: 20),
            if (provider.porCategoria.isNotEmpty) ...[
              const SectionTitle('Problemas por categoria'),
              _CardCategorias(porCategoria: provider.porCategoria),
              const SizedBox(height: 20),
            ],
            FilledButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.formulario),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Reportar novo problema'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _abrirLista(context),
              icon: const Icon(Icons.list_alt),
              label: const Text('Ver todas as ocorrências'),
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
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppTheme.primaria, Color(0xFF26A69A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A próxima grande inovação\npode estar na sua rua.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Reporte buracos, lixo, alagamentos e falhas de iluminação. '
            'Acompanhe até a solução.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 16),
          const Text(
            'ODS da ONU atendidos',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
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
        icone: Icons.assignment_outlined,
        cor: AppTheme.primaria,
        onTap: () => onTapStatus(null),
      ),
      for (final s in StatusOcorrencia.values)
        StatCard(
          label: s.label,
          valor: '${provider.contarPorStatus(s)}',
          icone: s.icon,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: provider.taxaResolucao,
                minHeight: 10,
                color: StatusOcorrencia.resolvida.color,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.priority_high, color: Color(0xFFC62828)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${provider.urgentes} ocorrência(s) urgente(s) '
                    'aguardando solução',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
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
    final maior = porCategoria.values.fold<int>(0, (a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            for (final e in porCategoria.entries)
              ListTile(
                dense: true,
                leading: Icon(e.key.icon, color: AppTheme.primaria),
                title: Text(e.key.label),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: LinearProgressIndicator(
                    value: maior == 0 ? 0 : e.value / maior,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(6),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                trailing: Text(
                  '${e.value}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
