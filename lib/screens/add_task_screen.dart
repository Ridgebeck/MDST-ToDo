import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../util/task_data.dart';

class AddTaskScreen extends StatelessWidget {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int emojiIndex1 = 0;
    int emojiIndex2 = 0;
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: kKliemannPink,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.0),
                topLeft: Radius.circular(25.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Expanded(
                      //   child: Container(
                      //     child: Center(
                      //       child: Text(
                      //         'Dat',
                      //         style: TextStyle(
                      //           fontSize: 15.0,
                      //           fontWeight: FontWeight.bold,
                      //           color: kKliemannGrau,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 90.0,
                          child: CupertinoPicker(
                            itemExtent: 42,
                            children: taskData.categoryEmojis,
                            onSelectedItemChanged: (value) {
                              emojiIndex1 = value;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Center(
                            child: Text(
                              'muss \n endlich',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: kKliemannGrau,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 90.0,
                          child: CupertinoPicker(
                            itemExtent: 42,
                            children: taskData.activityEmojis,
                            onSelectedItemChanged: (value) {
                              emojiIndex2 = value;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Center(
                            child: Text(
                              'werden.',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: kKliemannGrau,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 100.0,
                    child: Center(
                      child: TextField(
                        controller: myController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'sach ma kurz was es wird',
                          hintStyle: TextStyle(color: kKliemannBlau),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        cursorColor: kKliemannBlau,
                        autofocus: true,
                        style: TextStyle(fontSize: 20.0, color: kKliemannGrau),
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      taskData.addTask(
                          emojiIndex1: emojiIndex1,
                          emojiIndex2: emojiIndex2,
                          subtitle: myController.text);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kKliemannBlau,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Text(
                          'UND ABFAHRT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
