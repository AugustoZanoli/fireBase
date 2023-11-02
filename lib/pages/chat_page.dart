import 'dart:io';
import 'package:chat/pages/search_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../components/to_do_form.dart';
import '../components/to_do_list.dart';
import 'package:chat/core/models/to_do.dart';
import 'package:chat/core/services/auth/auth_service.dart';

class DoPage extends StatefulWidget {
  @override
  _DoPageState createState() => _DoPageState();
}

class _DoPageState extends State<DoPage> {
  List<ToDo> _ToDos = [];

  List<ToDo> get _recentToDos {
    return _ToDos.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  List<ToDo> searchToDosByName(List<ToDo> todos, String query) {
    query = query.toLowerCase();
    return todos
        .where((todo) => todo.name.toLowerCase().contains(query))
        .toList();
  }

  List<ToDo> filterToDosByCategory(List<ToDo> todos, String category) {
    category = category.toLowerCase();
    return todos
        .where((todo) => todo.category.toLowerCase() == category)
        .toList();
  }

  void updateToDos(List<ToDo> toDos) {
    setState(() {
      _ToDos = toDos;
    });
  }

  _addToDo(String name, String category, DateTime date) {
    final newToDo = ToDo(
      id: Random().nextDouble().toString(),
      name: name,
      date: date,
      category: category,
    );

    setState(() {
      _ToDos.add(newToDo);
    });

    Navigator.of(context).pop();
  }

  _removeToDo(String id) {
    setState(() {
      _ToDos.removeWhere((tr) {
        return tr.id == id;
      });
    });
  }

  void _openToDoFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ToDoForm(onSubmit: _addToDo);
      },
    );
  }

  void _handleSearch(String query) {
    final TextEditingController _searchController = TextEditingController();
    // Use o valor do controlador para realizar a pesquisa.
    final searchResults = searchToDosByName(_ToDos, _searchController.text);
    // Atualize o estado do widget com os resultados da pesquisa.
    setState(() {
      _ToDos = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Minha Lista de Afazeres'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(onSearch: _handleSearch),
                ),
              );
            },
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                }
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Coloca os elementos no canto direito e esquerdo
                  children: [
                    Row(
                      children: [
                        // Aqui você pode exibir a imagem do usuário (se disponível)
                        if (currentUser != null && currentUser.imageURL != null)
                          CircleAvatar(
                            backgroundImage:
                                FileImage(File(currentUser.imageURL)),
                            radius:
                                25, // Ajuste o tamanho do avatar conforme necessário
                          ),

                        // Nome e e-mail do usuário
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, ${currentUser?.name ?? 'Usuário'}!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'E-mail: ${currentUser?.email ?? ''}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            ToDoList(_ToDos, _removeToDo),
            // Por exemplo, sua lista de afazeres
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openToDoFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
