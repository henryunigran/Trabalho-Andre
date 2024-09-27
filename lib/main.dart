import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Principal(),
    );
  }
}

class Contato {
  final String nome;
  final String telefone;
  final String email;

  Contato({required this.nome, required this.telefone, required this.email});
}

class ContatosRepository {
  final List<Contato> contatos = [];

  void addContato(Contato c) {
    contatos.add(c);
  }

  void updateContato(int index, Contato contato) {
    contatos[index] = contato;
  }

  void deleteContato(int index) {
    contatos.removeAt(index);
  }

  List<Contato> getContatos() {
    return contatos;
  }
}

class Principal extends StatelessWidget {
  final ContatosRepository contatos = ContatosRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de Contatos'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Cadastro(contatos: contatos),
                ),
              );
            },
            child: Text("Cadastrar Contato"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Listagem(contatos: contatos),
                ),
              );
            },
            child: Text("Listar Contatos"),
          ),
        ],
      ),
    );
  }
}

class Cadastro extends StatefulWidget {
  final ContatosRepository contatos;
  final int? index; // Para editar um contato já existente

  Cadastro({required this.contatos, this.index});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      final contato = widget.contatos.getContatos()[widget.index!];
      nomeController.text = contato.nome;
      telefoneController.text = contato.telefone;
      emailController.text = contato.email;
    }
  }

  String? _validarEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      return 'E-mail inválido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index == null ? 'Cadastrar Contato' : 'Editar Contato'),
        actions: widget.index != null
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.contatos.deleteContato(widget.index!);
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
              decoration: InputDecoration(labelText: 'Nome'),
              controller: nomeController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Telefone'),
              controller: telefoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            TextField(
              decoration: InputDecoration(labelText: 'E-mail'),
              controller: emailController,
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

                if (_validarEmail(emailController.text) != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('E-mail inválido')),
                  );
                  return;
                }

                final contato = Contato(
                  nome: nomeController.text,
                  telefone: telefoneController.text,
                  email: emailController.text,
                );

                setState(() {
                  if (widget.index == null) {
                    widget.contatos.addContato(contato);
                  } else {
                    widget.contatos.updateContato(widget.index!, contato);
                  }
                });

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

class Listagem extends StatefulWidget {
  final ContatosRepository contatos;
  Listagem({required this.contatos});

  @override
  State<Listagem> createState() => _ListagemState();
}

class _ListagemState extends State<Listagem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
      ),
      body: ListView.builder(
        itemCount: widget.contatos.getContatos().length,
        itemBuilder: (context, index) {
          final contato = widget.contatos.getContatos()[index];
          return ListTile(
            title: Text(contato.nome),
            subtitle: Text('${contato.telefone} - ${contato.email}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Cadastro(
                    contatos: widget.contatos,
                    index: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
