class Endereco {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  Endereco({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) { // 1 - esse construtor factory recebe os dados que decodificamos
    // Para cada propriedade da nossa classe, ele busca o valor correspondente usando a chave (a string 'cep').
    // O ?? '' é uma segurança caso a API não retornar uma chave, usamos ums string vazia para evitar que o app quebre
    return Endereco(
      cep: json['cep'] ?? '', 
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }
}
