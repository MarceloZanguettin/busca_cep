// lib/screens/cep_lookup_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/endereco_model.dart'; // Importa o modelo
import '../services/cep_service.dart'; // Importa o serviço

class CepLookupPage extends StatefulWidget {
  const CepLookupPage({super.key});

  @override
  State<CepLookupPage> createState() => _CepLookupPageState();
}

class _CepLookupPageState extends State<CepLookupPage> {
  final CepService _cepService = CepService();
  final TextEditingController _cepController = TextEditingController();

  // Variáveis de estado da UI
  bool _isLoading = false;
  String? _errorMessage;
  Endereco? _enderecoResult;

  Future<void> _searchCep() async {
    // Esconde o teclado
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _enderecoResult = null;
    });

    try {
      // A UI chama o serviço para buscar os dados.
      // Ela não sabe como ele busca, apenas que retorna um Endereco.
      final endereco = await _cepService.fetchCep(_cepController.text);
      setState(() {
        _enderecoResult = endereco;
      });
    } catch (e) {
      // Se o serviço lançar uma exceção, a UI a captura e exibe a mensagem.
      setState(() {
        _errorMessage = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar CEP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Digite o CEP',
                hintText: 'Apenas números',
                border: OutlineInputBorder(),
              ),
              // Formatação para aceitar apenas 8 dígitos numéricos.
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _searchCep,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Buscar'),
              ),
            ),
            const SizedBox(height: 24),

            // --- ÁREA DE RESULTADO ---
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red))
            else if (_enderecoResult != null)
              _buildAddressCard(_enderecoResult!),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar o card de endereço
  Widget _buildAddressCard(Endereco endereco) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressRow('Logradouro:', endereco.logradouro),
            _buildAddressRow('Bairro:', endereco.bairro),
            _buildAddressRow('Cidade:', endereco.localidade),
            _buildAddressRow('Estado:', endereco.uf),
            _buildAddressRow('CEP:', endereco.cep),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text.rich(
        TextSpan(
          text: '$label ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
