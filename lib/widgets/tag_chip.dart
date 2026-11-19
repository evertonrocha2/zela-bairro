import 'package:flutter/material.dart';

import '../models/ocorrencia.dart';

/// Etiqueta colorida compacta (status, prioridade, etc.).
class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.texto, required this.cor});

  factory TagChip.status(StatusOcorrencia s) =>
      TagChip(texto: s.label, cor: s.color);

  factory TagChip.prioridade(Prioridade p) =>
      TagChip(texto: 'Prioridade ${p.label}', cor: p.color);

  final String texto;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(color: cor, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
