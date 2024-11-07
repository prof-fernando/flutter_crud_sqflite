import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  static Future<Database> getDataseConnection() async {
    return openDatabase(join(await getDatabasesPath(), 'aula.db'), version: 1,
        onCreate: (banco, index) {
      banco.execute(generate_tables());
    });
  }

  static String generate_tables() {
    return '''
                create table usuario(
                  idusuario integer primary key autoincrement,
                  nome text not null,
                  email text
                );
''';
  }

  static Future<int> gravar(String nome, String email, [int id = 0]) async {
    Database banco = await getDataseConnection();
    final values = {'nome': nome, 'email': email};
    if (id > 0) {
      return banco.update(
        'usuario',
        values,
        where: 'idusuario = ?',
        whereArgs: [id],
      );
    } else {
      return banco.insert('usuario', values);
    }
  }

  static Future<List<Map<String, Object?>>> listar(
      [String campoOrdem = 'nome']) async {
    Database banco = await getDataseConnection();
    return banco.query('usuario', orderBy: campoOrdem);
  }

  static Future<int> deletar(int id) async {
    Database banco = await getDataseConnection();
    return banco.delete(
      'usuario',
      where: 'idusuario = ?',
      whereArgs: [id],
    );
  }
}
