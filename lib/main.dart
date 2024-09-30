import 'package:flutter/material.dart';

void main() {
  runApp(AppBancario());
}

class AppBancario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação Bancária',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TelaFormulario(),
    );
  }
}

class TelaFormulario extends StatefulWidget {
  @override
  _TelaFormularioState createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  List<Map<String, String>> _transacoes = [];

  void _adicionarTransacao() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _transacoes.add({
          'nome': _nomeController.text,
          'valor': _valorController.text,
        });
        _nomeController.clear();
        _valorController.clear();
      });
    }
  }

  void _irParaLista() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaListaTransacoes(
          transacoes: _transacoes,
          atualizarTransacoes: (novasTransacoes) {
            setState(() {
              _transacoes = novasTransacoes;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Transações'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _irParaLista,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome da transação'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(labelText: 'Valor da transação'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Insira um valor numérico válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _adicionarTransacao();
                },
                child: Text('Adicionar Transação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaListaTransacoes extends StatelessWidget {
  final List<Map<String, String>> transacoes;
  final Function(List<Map<String, String>>) atualizarTransacoes;

  TelaListaTransacoes({required this.transacoes, required this.atualizarTransacoes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Transações'),
      ),
      body: ListView.builder(
        itemCount: transacoes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(transacoes[index]['nome']!),
              subtitle: Text('R\$ ${transacoes[index]['valor']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editarTransacao(context, index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _excluirTransacao(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _editarTransacao(BuildContext context, int index) {
    final nomeController = TextEditingController(text: transacoes[index]['nome']);
    final valorController = TextEditingController(text: transacoes[index]['valor']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Transação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: valorController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                transacoes[index] = {
                  'nome': nomeController.text,
                  'valor': valorController.text,
                };
                atualizarTransacoes(transacoes);
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _excluirTransacao(int index) {
    transacoes.removeAt(index);
    atualizarTransacoes(transacoes);
  }
}
