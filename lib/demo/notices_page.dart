import 'package:flutter/material.dart';

class NoticesPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notices")),
      body: Center(
        child: Text(
          "📢 Latest Notices will appear here",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
