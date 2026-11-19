import 'package:flutter/material.dart';

import '../../models/ocorrencia.dart';
import '../../screens/detalhes_screen.dart';
import '../../screens/formulario_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/lista_screen.dart';
import '../../screens/sobre_screen.dart';

/// Rotas nomeadas do app e passagem de argumentos entre telas.
class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String lista = '/lista';
  static const String formulario = '/formulario';
  static const String detalhes = '/detalhes';
  static const String sobre = '/sobre';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _page(const HomeScreen(), settings);
      case lista:
        return _page(const ListaScreen(), settings);
      case formulario:
        // Argumento opcional: ocorrência a ser editada.
        final ocorrencia = settings.arguments as Ocorrencia?;
        return _page(FormularioScreen(ocorrencia: ocorrencia), settings);
      case detalhes:
        // Argumento obrigatório: id da ocorrência selecionada.
        final id = settings.arguments as int;
        return _page(DetalhesScreen(ocorrenciaId: id), settings);
      case sobre:
        return _page(const SobreScreen(), settings);
      default:
        return _page(const HomeScreen(), settings);
    }
  }

  static MaterialPageRoute<T> _page<T>(Widget child, RouteSettings settings) {
    return MaterialPageRoute<T>(builder: (_) => child, settings: settings);
  }
}
