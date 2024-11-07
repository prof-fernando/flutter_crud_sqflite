import 'package:crud_sqlite/sql_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final txtNome = TextEditingController();

  final txtEmail = TextEditingController();
  // controlar stado da tela
  List<Map<String, Object?>> usuarios = [];

  @override
  void initState() {
    super.initState();
    _atualizarListaUsuario();
  }

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
              _atualizarListaUsuario();
            },
            child: Text('Gravar'),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, indice) => ListTile(
                      title: Text('${usuarios[indice]["nome"]}'),
                      subtitle: Text(usuarios[indice]["email"].toString()),
                      leading: CircleAvatar(),
                      trailing: IconButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Excluir item?'),
                                      content:
                                          Text('Tem certeza que deseja...'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('AGUARDE...'),
                                              ),
                                            );
                                            int id = usuarios[indice]
                                                ["idusuario"] as int;
                                            int linhas =
                                                await SqlHelper.deletar(id);
                                            _atualizarListaUsuario();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text('OK'),
                                        )
                                      ],
                                    ));
                          },
                          icon: Icon(
                            Icons.close,
                          )),
                    ),
                separatorBuilder: (context, index) => Divider(),
                itemCount: usuarios.length),
          )
        ],
      ),
    );
  }

  _atualizarListaUsuario() async {
    usuarios = await SqlHelper.listar();
    setState(() {});
  }
}
