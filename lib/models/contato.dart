class Contato {
  final int? id;
  final String nome;
  final String telefone;
  final String email;

  Contato({this.id, required this.nome, required this.telefone, required this.email});

  // Converter Contato para Map (para armazenar no SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
    };
  }

  // Converter de Map para Contato
  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
    );
  }
}
