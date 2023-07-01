import 'package:dunjion_app/ui/Dungeon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// void main() => runApp(const TasksApp());
//
// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => TaskData(),
//       child: MaterialApp(
//         home: TasksScreen(),
//       ),
//     ),
//   );
// }

class Task {
  final String name;
  bool isDone;
  DateTime? deadline;

  Task({this.name = "Task", this.isDone = false, this.deadline});

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
                    taskData.updateTask(task);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dungeon(),
                    ),
                  );
                },
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
                  Provider.of<TaskData>(context, listen: false)
                      .addTask(newTaskTitle);
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

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログインページ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '氏名',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: '氏名を入力してください',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'パスワード',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              maxLength: 8,
              decoration: InputDecoration(
                hintText: '8桁のパスワードを入力してください',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showPopup(context);
                },
                child: const Text(
                  'ログイン',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ログインボーナス!',
            textAlign: TextAlign.center,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '今日のアイテム',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/example_image.jpg',
                height: 100,
                width: 100,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextPage()),
                );
              },
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('次のページ'),
      ),
      body: Center(
        child: const Text('次のページです'),
      ),
    );
  }
}