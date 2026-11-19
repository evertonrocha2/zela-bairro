import 'package:flutter/material.dart';

/// Diálogo de confirmação reutilizável. Retorna `true` se confirmado.
Future<bool> mostrarConfirmacao(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  String confirmar = 'Excluir',
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            minimumSize: const Size(0, 44),
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmar),
        ),
      ],
    ),
  );
  return resultado ?? false;
}

void mostrarSnack(BuildContext context, String mensagem, {bool erro = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: erro ? Colors.red.shade700 : const Color(0xFF2E7D32),
      ),
    );
}
