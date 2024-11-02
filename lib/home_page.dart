import 'package:crud_sqlite/sql_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final txtNome = TextEditingController();
  final txtEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Nome:',
            ),
            controller: txtNome,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'email:',
            ),
            controller: txtEmail,
          ),
          ElevatedButton(
            onPressed: () async {
              // grava no banco
              final id = await SqlHelper.gravar(txtNome.text, txtEmail.text);

              final snack = SnackBar(
                content: Text('Salvo com sucesso! $id'),
                showCloseIcon: true,
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            },
            child: Text('Gravar'),
          )
        ],
      ),
    );
  }
}
