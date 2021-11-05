import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  static const routeName = "/quiz-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chevron_right),
        tooltip: "Next",
        onPressed: () {},
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Question Here"),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      value: true,
                      onChanged: (value) {},

                      title: Text("Answer $index"),
                      // onTap: () {
                      //   // Navigator.of(context).pushNamed(ResultScreen.routeName);
                      // },
                    );
                  },
                  itemCount: 10),
            ),
          ],
        ),
      ),
    );
  }
}
