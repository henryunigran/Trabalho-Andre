import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../services/database_helper.dart';

class Cadastro extends StatefulWidget {
  final Contato? contato;

  Cadastro({this.contato});

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      _nomeController.text = widget.contato!.nome;
      _telefoneController.text = widget.contato!.telefone;
      _emailController.text = widget.contato!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato == null ? 'Cadastrar Contato' : 'Editar Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nome'),
              controller: _nomeController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Telefone'),
              controller: _telefoneController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'E-mail'),
              controller: _emailController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final nome = _nomeController.text;
                final telefone = _telefoneController.text;
                final email = _emailController.text;

                if (nome.isEmpty || telefone.isEmpty || email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, preencha todos os campos')),
                  );
                  return;
                }

                final contato = Contato(
                  nome: nome,
                  telefone: telefone,
                  email: email,
                );

                if (widget.contato == null) {
                  await DatabaseHelper().addContato(contato);
                } else {
                  await DatabaseHelper().updateContato(
                    contato.copyWith(id: widget.contato!.id),
                  );
                }

                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
