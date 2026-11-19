import 'package:flutter/material.dart';

/// Card de indicador numérico usado no dashboard.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.valor,
    required this.cor,
    this.onTap,
  });

  final String label;
  final String valor;
  final Color cor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$label: $valor',
      button: onTap != null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: cor,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
