import 'package:flutter/material.dart';

import '../core/constants/ods.dart';

/// Selo compacto de um ODS com a cor oficial da ONU.
class OdsBadge extends StatelessWidget {
  const OdsBadge({super.key, required this.ods, this.compacto = false});

  final Ods ods;
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'ODS ${ods.numero}: ${ods.titulo}',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compacto ? 10 : 12,
          vertical: compacto ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: ods.cor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'ODS ${ods.numero}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: compacto ? 13 : 15,
          ),
        ),
      ),
    );
  }
}
