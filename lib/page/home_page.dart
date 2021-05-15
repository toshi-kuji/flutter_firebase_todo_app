import 'package:firebase_setup/api/firebase_api.dart';
import 'package:firebase_setup/main.dart';
import 'package:firebase_setup/model/todo.dart';
import 'package:firebase_setup/provider/providers.dart';
import 'package:firebase_setup/provider/todos.dart';
import 'package:firebase_setup/widget/add_todo_dialog_widget.dart';
import 'package:firebase_setup/widget/todo_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final int selectedIndex = watch(selectedPageProvider).state;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          MyApp.title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: 5,
          ),
        ),
        leading: Text(
          'Click each card to edit',
          style: TextStyle(color: Colors.white70),
        ),
        leadingWidth: 300,
      ),
      body: StreamBuilder(
        stream: FirebaseApi.readTodos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Something Went Wrong'));
              } else {
                context
                    .read(todosProvider)
                    .setTodos(snapshot.data as List<Todo>);
                return TodoListWidget(selectedIndex);
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddTodoDialogWidget(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => watch(selectedPageProvider).state = index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_rounded),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done, size: 28),
            label: 'Completed',
          ),
        ],
        unselectedItemColor: Colors.black45,
        currentIndex: context.read(selectedPageProvider).state,
      ),
    );
  }
}