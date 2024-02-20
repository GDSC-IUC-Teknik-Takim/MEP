import 'package:flutter/material.dart';
import 'package:mep/app/views/home/navigation_bar/navigation_bar.dart';
import 'package:mep/app/views/report/create_report/create_report_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBarPage(
      content: _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatefulWidget {
  const _HomePageContent({Key? key}) : super(key: key);

  @override
  State<_HomePageContent> createState() => __HomePageContentState();
}

class __HomePageContentState extends State<_HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Home Page"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateReport()),
                );
              },
              child: const Text("Create Report"),
            ),
          ],
        ),
      ),
    );
  }
}
