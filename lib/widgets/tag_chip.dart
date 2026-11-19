import 'package:flutter/material.dart';

import '../models/ocorrencia.dart';

/// Etiqueta colorida compacta (status, prioridade, etc.).
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.texto,
    required this.cor,
    this.icone,
  });

  factory TagChip.status(StatusOcorrencia s) =>
      TagChip(texto: s.label, cor: s.color, icone: s.icon);

  factory TagChip.prioridade(Prioridade p) =>
      TagChip(texto: 'Prioridade ${p.label}', cor: p.color);

  final String texto;
  final Color cor;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 14, color: cor),
            const SizedBox(width: 4),
          ],
          Text(
            texto,
            style: TextStyle(
              color: cor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
