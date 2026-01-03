import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Events")),
      body: Center(
        child: Text(
          "🎉 Upcoming campus events",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
