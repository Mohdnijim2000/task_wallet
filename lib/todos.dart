class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  double? expenseAmount; // Add this property

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    this.expenseAmount,
  });
  static List<ToDo> todolist(){
    return[
    ];
  }

}