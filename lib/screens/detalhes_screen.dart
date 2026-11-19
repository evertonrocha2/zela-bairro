import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../models/ocorrencia.dart';
import '../providers/ocorrencia_provider.dart';
import '../utils/formatters.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/feedback_states.dart';
import '../widgets/tag_chip.dart';

/// Tela 4: detalhes de uma ocorrência. Recebe o id via argumento de rota
/// e lê o registro do Provider, então reflete edições automaticamente.
class DetalhesScreen extends StatelessWidget {
  const DetalhesScreen({super.key, required this.ocorrenciaId});

  final int ocorrenciaId;

  Future<void> _excluir(BuildContext context, Ocorrencia o) async {
    final ok = await mostrarConfirmacao(
      context,
      titulo: 'Excluir ocorrência?',
      mensagem: '"${o.titulo}" será removida permanentemente.',
    );
    if (!ok || !context.mounted) return;
    final sucesso = await context.read<OcorrenciaProvider>().remover(o.id!);
    if (!context.mounted) return;
    if (sucesso) {
      mostrarSnack(context, 'Ocorrência excluída');
      Navigator.pop(context);
    } else {
      mostrarSnack(context, 'Erro ao excluir ocorrência', erro: true);
    }
  }

  Future<void> _avancarStatus(BuildContext context, Ocorrencia o) async {
    final proximo = o.status == StatusOcorrencia.aberta
        ? StatusOcorrencia.emAndamento
        : StatusOcorrencia.resolvida;
    final sucesso = await context.read<OcorrenciaProvider>().alterarStatus(
      o.id!,
      proximo,
    );
    if (!context.mounted) return;
    mostrarSnack(
      context,
      sucesso ? 'Status alterado para "${proximo.label}"' : 'Erro ao alterar',
      erro: !sucesso,
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = context.select<OcorrenciaProvider, Ocorrencia?>(
      (p) => p.buscarPorId(ocorrenciaId),
    );

    if (o == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhes')),
        body: const EmptyState(
          icone: Icons.search_off,
          titulo: 'Ocorrência não encontrada',
          mensagem: 'Ela pode ter sido excluída.',
        ),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da ocorrência'),
        actions: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.formulario,
              arguments: o,
            ),
          ),
          IconButton(
            tooltip: 'Excluir',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _excluir(context, o),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppTheme.primaria.withValues(
                          alpha: 0.1,
                        ),
                        child: Icon(
                          o.categoria.icon,
                          color: AppTheme.primaria,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          o.categoria.label,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppTheme.primaria,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(o.titulo, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      TagChip.status(o.status),
                      TagChip.prioridade(o.prioridade),
                      if (o.riscoSeguranca)
                        const TagChip(
                          texto: 'Risco à segurança',
                          cor: Color(0xFFC62828),
                          icone: Icons.health_and_safety_outlined,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descrição', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text(o.descricao, style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _InfoTile(
                  icone: Icons.signpost_outlined,
                  titulo: 'Endereço',
                  valor: o.endereco,
                ),
                const Divider(height: 1),
                _InfoTile(
                  icone: Icons.place_outlined,
                  titulo: 'Bairro',
                  valor: o.bairro,
                ),
                const Divider(height: 1),
                _InfoTile(
                  icone: Icons.event_outlined,
                  titulo: 'Reportada em',
                  valor:
                      '${Formatters.dataHora(o.criadoEm)} (${Formatters.relativo(o.criadoEm)})',
                ),
                const Divider(height: 1),
                _InfoTile(
                  icone: Icons.tag,
                  titulo: 'Protocolo',
                  valor: '#${o.id.toString().padLeft(5, '0')}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (!o.resolvida) ...[
            FilledButton.icon(
              onPressed: () => _avancarStatus(context, o),
              icon: Icon(
                o.status == StatusOcorrencia.aberta
                    ? Icons.build_circle_outlined
                    : Icons.check_circle_outline,
              ),
              label: Text(
                o.status == StatusOcorrencia.aberta
                    ? 'Marcar como em andamento'
                    : 'Marcar como resolvida',
              ),
            ),
            const SizedBox(height: 12),
          ],
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.formulario,
              arguments: o,
            ),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade200),
            ),
            onPressed: () => _excluir(context, o),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  final IconData icone;
  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icone, color: AppTheme.primaria),
      title: Text(
        titulo,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
      ),
      subtitle: Text(
        valor,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }
}
