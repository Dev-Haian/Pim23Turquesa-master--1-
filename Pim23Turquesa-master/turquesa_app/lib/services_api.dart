//services_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ServicesAPI {
  // Função para buscar subcategorias com base na categoria
  static Future<List<dynamic>> getSubcategories(String categoryName) async {
    // Substitua a URL pelo seu servidor back-end
    final url = Uri.parse('http://localhost:3000/services/$categoryName');

    // Faz a requisição HTTP GET para buscar as subcategorias
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Se a resposta for OK, parseia o JSON e retorna as subcategorias
      final data = json.decode(response.body);
      return data['subcategories'];
    } else {
      throw Exception('Falha ao carregar subcategorias');
    }
  }
}
