import 'package:flutter/material.dart';
import '../core/models/to_do.dart';
import 'package:intl/intl.dart';

class ToDoList extends StatelessWidget {
  final List<ToDo> afazeres;
  final void Function(String) onRemove;

  ToDoList(this.afazeres, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: afazeres.isEmpty
          ? Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Nenhum afazer registrado!',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 20),
              ],
            )
          : ListView.builder(
              itemCount: afazeres.length,
              itemBuilder: (ctx, index) {
                final tr = afazeres[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      tr.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      DateFormat('d MMM y').format(tr.date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => onRemove(tr.id),
                    ),
                  ),
                );
              }),
    );
  }
}
