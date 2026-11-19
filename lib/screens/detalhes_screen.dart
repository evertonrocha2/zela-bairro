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
      mensagem: 'Isso apaga "${o.titulo}". Não dá para desfazer.',
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
        body: const EmptyState(titulo: 'Ocorrência não encontrada'),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da ocorrência')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o.categoria.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaria,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(o.titulo, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TagChip.status(o.status),
                      TagChip.prioridade(o.prioridade),
                      if (o.riscoSeguranca)
                        const TagChip(
                          texto: 'Risco à segurança',
                          cor: Color(0xFFC62828),
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
                  const SizedBox(height: 8),
                  Text(o.descricao, style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _InfoTile(titulo: 'Endereço', valor: o.endereco),
                const Divider(height: 1),
                _InfoTile(titulo: 'Bairro', valor: o.bairro),
                const Divider(height: 1),
                _InfoTile(
                  titulo: 'Reportada em',
                  valor: Formatters.dataHora(o.criadoEm),
                ),
                const Divider(height: 1),
                _InfoTile(
                  titulo: 'Protocolo',
                  valor: '#${o.id.toString().padLeft(5, '0')}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (!o.resolvida) ...[
            FilledButton(
              onPressed: () => _avancarStatus(context, o),
              child: Text(
                o.status == StatusOcorrencia.aberta
                    ? 'Marcar como em andamento'
                    : 'Marcar como resolvida',
              ),
            ),
            const SizedBox(height: 12),
          ],
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.formulario,
              arguments: o,
            ),
            child: const Text('Editar'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade200),
            ),
            onPressed: () => _excluir(context, o),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.titulo, required this.valor});

  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
