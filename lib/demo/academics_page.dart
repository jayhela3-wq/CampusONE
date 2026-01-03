import 'package:flutter/material.dart';

class AcademicsPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Academics")),
      body: Center(
        child: Text(
          "🎓 Academic details and resources",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
