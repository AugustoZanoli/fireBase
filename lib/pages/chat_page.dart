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
  final List<ToDo> _ToDos = [];

  List<ToDo> get _recentToDos {
    return _ToDos.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('ToDo'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openToDoFormModal(context),
          ),
          DropdownButton(
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
                        color: Colors.white,
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 60,
              width: 10,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
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
