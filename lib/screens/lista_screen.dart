import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes/app_routes.dart';
import '../models/ocorrencia.dart';
import '../providers/ocorrencia_provider.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/feedback_states.dart';
import '../widgets/ocorrencia_card.dart';

/// Tela 2: listagem dinâmica com ListView.separated, filtros e estados
/// de loading, lista vazia e erro.
class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key});

  Future<void> _onAcao(
    BuildContext context,
    Ocorrencia o,
    AcaoCard acao,
  ) async {
    switch (acao) {
      case AcaoCard.editar:
        await Navigator.pushNamed(context, AppRoutes.formulario, arguments: o);
      case AcaoCard.excluir:
        final ok = await mostrarConfirmacao(
          context,
          titulo: 'Excluir ocorrência?',
          mensagem: '"${o.titulo}" será removida permanentemente.',
        );
        if (!ok || !context.mounted) return;
        final sucesso = await context.read<OcorrenciaProvider>().remover(o.id!);
        if (!context.mounted) return;
        mostrarSnack(
          context,
          sucesso ? 'Ocorrência excluída' : 'Erro ao excluir ocorrência',
          erro: !sucesso,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ocorrências')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.formulario),
        icon: const Icon(Icons.add),
        label: const Text('Reportar'),
      ),
      body: Column(
        children: [
          const _FiltroStatus(),
          Expanded(
            child: Consumer<OcorrenciaProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.ocorrencias.isEmpty) {
                  return const LoadingState(
                    mensagem: 'Carregando ocorrências...',
                  );
                }

                if (provider.erro != null && provider.ocorrencias.isEmpty) {
                  return ErrorState(
                    mensagem: provider.erro!,
                    onRetry: provider.carregar,
                  );
                }

                final itens = provider.ocorrenciasFiltradas;
                if (itens.isEmpty) {
                  final filtrando = provider.filtroStatus != null;
                  return EmptyState(
                    icone: Icons.check_circle_outline,
                    titulo: filtrando
                        ? 'Nada por aqui'
                        : 'Nenhuma ocorrência registrada',
                    mensagem: filtrando
                        ? 'Não há ocorrências com o status '
                              '"${provider.filtroStatus!.label}".'
                        : 'Seu bairro está em dia! Viu algum problema? '
                              'Reporte agora mesmo.',
                    acaoLabel: filtrando ? null : 'Reportar problema',
                    onAcao: filtrando
                        ? null
                        : () => Navigator.pushNamed(
                            context,
                            AppRoutes.formulario,
                          ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: provider.carregar,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: itens.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final o = itens[index];
                      return OcorrenciaCard(
                        key: ValueKey(o.id),
                        ocorrencia: o,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.detalhes,
                          arguments: o.id,
                        ),
                        onAcao: (acao) => _onAcao(context, o, acao),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltroStatus extends StatelessWidget {
  const _FiltroStatus();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OcorrenciaProvider>();
    final atual = provider.filtroStatus;

    Widget chip(String label, StatusOcorrencia? valor, int qtd) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text('$label ($qtd)'),
          selected: atual == valor,
          onSelected: (_) =>
              context.read<OcorrenciaProvider>().filtrarPorStatus(valor),
        ),
      );
    }

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 10, 8, 6),
        children: [
          chip('Todas', null, provider.total),
          for (final s in StatusOcorrencia.values)
            chip(s.label, s, provider.contarPorStatus(s)),
        ],
      ),
    );
  }
}
