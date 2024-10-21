import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../services/database_helper.dart';
import 'cadastro_screen.dart';

class ListagemScreen extends StatefulWidget {
  @override
  _ListagemScreenState createState() => _ListagemScreenState();
}

class _ListagemScreenState extends State<ListagemScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Contato> _contatos = [];

  @override
  void initState() {
    super.initState();
    _loadContatos();
  }

  Future<void> _loadContatos() async {
    List<Contato> contatos = await _dbHelper.getContatos();
    setState(() {
      _contatos = contatos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
      ),
      body: ListView.builder(
        itemCount: _contatos.length,
        itemBuilder: (context, index) {
          Contato contato = _contatos[index];
          return ListTile(
            title: Text(contato.nome),
            subtitle: Text('${contato.telefone} - ${contato.email}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CadastroScreen(
                    contato: contato,
                  ),
                ),
              ).then((value) => _loadContatos());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CadastroScreen(),
            ),
          ).then((value) => _loadContatos());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
