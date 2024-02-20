import 'package:flutter/material.dart';
import 'package:mep/app/views/report/create_report/create_report_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),),
      body: Center(
        child: Column(children: [
          const Text("Home Page"),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateReport()),
                );
              },
              child: Text("Check Report List"))
        ]),
      ),
    );
  }
}
