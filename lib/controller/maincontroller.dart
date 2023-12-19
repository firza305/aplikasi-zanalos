import 'package:flutter/material.dart';
import 'package:loginpage/controller/pad.dart';

class MainController extends StatelessWidget {
  const MainController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
          child: Stack(
        children: [
          Row(
            children: [
              // CONTROLS ON THE LEFT SIDE
              Expanded(
                flex: 4,
                child: Container(
                  child: DpadButton(),
                ),
              ),

              // GAP IN THE MIDDLE
            ],
          ),
        ],
      )),
    );
  }
}
