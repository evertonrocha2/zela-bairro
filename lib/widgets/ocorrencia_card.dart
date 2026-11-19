import 'package:flutter/material.dart';

import '../models/ocorrencia.dart';
import 'tag_chip.dart';

enum AcaoCard { editar, excluir }

/// Item da listagem de ocorrências.
class OcorrenciaCard extends StatelessWidget {
  const OcorrenciaCard({
    super.key,
    required this.ocorrencia,
    required this.onTap,
    required this.onAcao,
  });

  final Ocorrencia ocorrencia;
  final VoidCallback onTap;
  final ValueChanged<AcaoCard> onAcao;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final o = ocorrencia;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      o.bairro,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        TagChip.status(o.status),
                        TagChip.prioridade(o.prioridade),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<AcaoCard>(
                tooltip: 'Ações',
                onSelected: onAcao,
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: AcaoCard.editar,
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Editar'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: AcaoCard.excluir,
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, color: Colors.red),
                      title: Text('Excluir'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
