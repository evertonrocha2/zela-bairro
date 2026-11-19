import 'package:intl/intl.dart';

class Formatters {
  const Formatters._();

  static final DateFormat _data = DateFormat('dd/MM/yyyy');
  static final DateFormat _dataHora = DateFormat('dd/MM/yyyy HH:mm');

  static String data(DateTime d) => _data.format(d);
  static String dataHora(DateTime d) => _dataHora.format(d);

  static String percentual(double valor) =>
      '${(valor * 100).toStringAsFixed(0)}%';

  /// Texto relativo simples: "hoje", "ontem", "há 3 dias".
  static String relativo(DateTime d, {DateTime? agora}) {
    final ref = agora ?? DateTime.now();
    final dias = DateTime(
      ref.year,
      ref.month,
      ref.day,
    ).difference(DateTime(d.year, d.month, d.day)).inDays;
    if (dias <= 0) return 'hoje';
    if (dias == 1) return 'ontem';
    return 'há $dias dias';
  }
}
