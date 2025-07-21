import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/endereco_model.dart'; // Importa nosso modelo

class CepService {
  final String _baseUrl = 'https://viacep.com.br/ws';

  Future<Endereco> fetchCep(String cep) async {
    // Limpa o CEP, deixando apenas os números.
    final String cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepLimpo.length != 8) {
      throw Exception('CEP inválido. Deve conter 8 dígitos.');
    }

    final response = await http.get(Uri.parse('$_baseUrl/$cepLimpo/json/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('erro')) {
        throw Exception('CEP não encontrado.');
      }

      return Endereco.fromJson(data);
    } else {
      throw Exception('Falha ao buscar o CEP. Tente novamente.');
    }
  }
}
