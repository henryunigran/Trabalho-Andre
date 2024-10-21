import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../services/database_helper.dart';

class CadastroScreen extends StatefulWidget {
  final Contato? contato;

  CadastroScreen({this.contato});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      nomeController.text = widget.contato!.nome;
      telefoneController.text = widget.contato!.telefone;
      emailController.text = widget.contato!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato == null ? 'Cadastrar Contato' : 'Editar Contato'),
        actions: widget.contato != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _dbHelper.deleteContato(widget.contato!.id!);
                    Navigator.pop(context);
                  },
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nomeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Nome não pode estar vazio')),
                  );
                  return;
                }

                Contato contato = Contato(
                  nome: nomeController.text,
                  telefone: telefoneController.text,
                  email: emailController.text,
                );

                if (widget.contato == null) {
                  _dbHelper.addContato(contato);
                } else {
                  contato = Contato(
                    id: widget.contato!.id,
                    nome: nomeController.text,
                    telefone: telefoneController.text,
                    email: emailController.text,
                  );
                  _dbHelper.updateContato(contato);
                }
