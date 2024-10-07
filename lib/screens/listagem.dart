import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../services/database_helper.dart';
import 'cadastro.dart';

class Listagem extends StatefulWidget {
  @override
  _ListagemState createState() => _ListagemState();
}

class _ListagemState extends State<Listagem> {
  late Future<List<Contato>> _contatos;

  @override
  void initState() {
    super.initState();
    _carregarContatos();
  }

  void _carregarContatos() {
    setState(() {
      _contatos = DatabaseHelper().getContatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
      ),
      body: FutureBuilder<List<Contato>>(
        future: _contatos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar contatos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum contato encontrado'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final contato = snapshot.data![index];
                return ListTile(
                  title: Text(contato.nome),
                  subtitle: Text('${contato.telefone} - ${contato.email}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cadastro(contato: contato),
                      ),
                    ).then((_) => _carregarContatos());
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
