import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final void Function(String) onSearch;
  final TextEditingController _searchController = TextEditingController();

  SearchScreen({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisar Afazeres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController, // Use o TextEditingController aqui
              onChanged: (query) {
                // Neste ponto, o valor da pesquisa é atualizado automaticamente no controlador.
              },
              decoration: InputDecoration(labelText: 'Pesquisar por nome'),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                final query =
                    _searchController.text; // Obtenha o valor do campo de texto
                onSearch(
                    query); // Chame a função de pesquisa com o valor obtido
              },
            ),
          ],
        ),
      ),
    );
  }
}
