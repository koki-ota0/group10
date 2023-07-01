import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Task {
  final String name;
  bool isDone;

  Task({this.name = "Task", this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}

class TaskData extends ChangeNotifier {
  List<Task> tasks = [
    Task(name: 'Task 1'),
    Task(name: 'Task 2'),
    Task(name: 'Task 3'),
  ];

  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle);
    tasks.add(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }
}
class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Consumer<TaskData>(
        builder: (context, taskData, child) {
          return ListView.builder(
            itemCount: taskData.tasks.length,
            itemBuilder: (context, index) {
              final task = taskData.tasks[index];
              return ListTile(
                title: Text(task.name),
                trailing: Checkbox(
                  value: task.isDone,
                  onChanged: (bool? newValue) {
                    task.toggleDone();
                    taskData.notifyListeners();
                  },
                ),
                onLongPress: () {
                  taskData.deleteTask(task);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Add a task'),
              content: TextField(
                autofocus: true,
                onSubmitted: (newTaskTitle) {
                  TaskData taskData = Provider.of<TaskData>(context, listen: false);
                  taskData.addTask(newTaskTitle);
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}
