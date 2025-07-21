import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/endereco_model.dart'; // Importa nosso modelo

class CepService {
  final String _baseUrl = 'https://viacep.com.br/ws';

  Future<Endereco> fetchCep(String cep) async { 
    // Limpa o CEP, deixando apenas os números.
    final String cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), ''); // 1 - Limpa o CEP

    if (cepLimpo.length != 8) { // 2 - aqui se não tiver 8 digitos nem tenta ir para a API
      throw Exception('CEP inválido. Deve conter 8 dígitos.');
    }

    final response = await http.get(Uri.parse('$_baseUrl/$cepLimpo/json/')); // 3 - aqui fazemos
    // a requisição GET HTTP para a URL do ViaCEP inserindo o CEP Limpo

    if (response.statusCode == 200) { // 4 - aqui verificamos se a comunicação foi um sucesso
      final data = json.decode(response.body); // 5 - a resposta vem como texto puro em JSON.
      // essa função decodifica esse texto e transforma em um tipo de dado que o Dart entenda.
      if (data.containsKey('erro')) { // 6 - Aqui se o CEP não existir, ele ainda responde ok, mas 
        // envia um JSON contendo erro = true. Nps verificamos se existe essa chave e tratamos como um erro
        throw Exception('CEP não encontrado.');
      }

      return Endereco.fromJson(data); // 7 - Se tudo deu certo nos passamos os dados para a classe Endereço
    } else {
      throw Exception('Falha ao buscar o CEP. Tente novamente.');
    }
  }
}
