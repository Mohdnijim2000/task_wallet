import 'dart:ui';

import 'package:flutter/material.dart';
import 'To_Do_item.dart';
import 'colors.dart';
import 'todos.dart';



class home extends StatefulWidget {
  home({Key? key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final todolist = ToDo.todolist();
  final _todoController = TextEditingController();
  int sum = 0;

  List<ToDo> _foundToDo = [];

  @override
  void initState() {
    _foundToDo = todolist;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGcolor,
      appBar
          :
      _buildAppBar(),


      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          'What you did (price): ',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      for (ToDo todoo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: deleteToDoItem,
                        ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Add a new todo item',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: tdBlue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void deleteToDoItem(String id) {
    setState(() {
      todolist.removeWhere((item) => item.id == id);
      // Update the total expense when deleting an item
      sum = _calculateTotalExpenses();

    });
  }

  int _calculateTotalExpenses() {
    int total = 0;
    for (var todo in todolist) {
      if (todo.expenseAmount != null) {
        total += todo.expenseAmount!.toInt();
      }
    }
    return total;
  }

  void _addToDoItem(String todo) {
    setState(() {
      var matches = RegExp(r'\((\d+(\.\d+)?)\)$').allMatches(todo);
      if (matches.isNotEmpty) {
        double amount = double.parse(matches.first.group(1)!);
        sum += amount.toInt();
        todolist.add(
          ToDo(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            todoText: todo,
            expenseAmount: amount,
          ),
        );
      }
      _todoController.clear();
    });
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todolist;
    } else {
      results = todolist
          .where(
            (item) => item.todoText!
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()),
      )
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          prefixIcon: Icon(Icons.search, color: tdblack, size: 20),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(

      flexibleSpace: Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.purple],
          ),
        ),
      ),
      elevation: 0,
      title: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(( 'Total Expenses: \$${sum.toStringAsFixed(2)}'), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
          Container(

            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ],
      ),
    );
  }
}
