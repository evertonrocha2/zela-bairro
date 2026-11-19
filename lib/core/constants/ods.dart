import 'package:flutter/material.dart';

/// Objetivo de Desenvolvimento Sustentável (ONU) atendido pelo app.
class Ods {
  const Ods({
    required this.numero,
    required this.titulo,
    required this.cor,
    required this.icone,
    required this.comoAtendemos,
  });

  final int numero;
  final String titulo;
  final Color cor;
  final IconData icone;
  final String comoAtendemos;
}

/// Cores oficiais dos ODS da ONU.
const List<Ods> odsAtendidos = [
  Ods(
    numero: 11,
    titulo: 'Cidades e Comunidades Sustentáveis',
    cor: Color(0xFFFD9D24),
    icone: Icons.location_city,
    comoAtendemos:
        'Dá voz ao cidadão para mapear e cobrar a manutenção da '
        'infraestrutura urbana do seu bairro.',
  ),
  Ods(
    numero: 3,
    titulo: 'Saúde e Bem-Estar',
    cor: Color(0xFF4C9F38),
    icone: Icons.favorite_border,
    comoAtendemos:
        'Reduz riscos de acidentes e focos de doenças causados por '
        'buracos, lixo acumulado e água parada.',
  ),
  Ods(
    numero: 13,
    titulo: 'Ação Contra a Mudança Global do Clima',
    cor: Color(0xFF3F7E44),
    icone: Icons.public,
    comoAtendemos:
        'Identifica pontos de alagamento para apoiar a adaptação da '
        'cidade a eventos climáticos extremos.',
  ),
];
