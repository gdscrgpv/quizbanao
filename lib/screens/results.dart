import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = "/results-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(height: 20),
              Text("Leaderboards"),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text("${index + 1}"),
                        ),
                        title: Text("User name $index"),
                        trailing: Text("${index + 1}"),
                      );
                    },
                    itemCount: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
