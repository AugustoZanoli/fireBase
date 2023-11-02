class ToDo {
  final String id;
  final String name;
  final DateTime date;
  final String category; // Adicionei a categoria como um campo

  ToDo({
    required this.id,
    required this.name,
    required this.date,
    required this.category, // Certifique-se de passar a categoria ao criar uma tarefa
  });
}
