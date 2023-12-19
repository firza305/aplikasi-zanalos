import 'package:flutter/material.dart';
import 'package:loginpage/controller/blankgap.dart';
import 'package:loginpage/controller/roundcorner.dart';
import 'package:firebase_database/firebase_database.dart';

class DpadButton extends StatelessWidget {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.reference();

  DpadButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlankGap(),
                RoundNeuButton(
                  child: Icon(
                    Icons.power_settings_new_rounded,
                    size: 120,
                    color: Colors.grey[700],
                  ),
                  rtdbKey: 'power',
                  rtdbValueOn: true,
                  rtdbValueOff: false,
                ),
                BlankGap(),
              ],
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     RoundNeuButton(
            //       child: Icon(
            //         Icons.arrow_drop_up_rounded,
            //         size: 50,
            //         color: Colors.grey[700],
            //       ),
            //       rtdbKey: 'up',
            //       rtdbValueOn: true,
            //       rtdbValueOff: false,
            //     ),
            //     BlankGap(),
            // RoundNeuButton(
            //   child: Icon(
            //     Icons.arrow_drop_down_rounded,
            //     size: 50,
            //     color: Colors.grey[700],
            //   ),
            //   rtdbKey: 'down',
            //   rtdbValueOn: true,
            //   rtdbValueOff: false,
            // )
          ],
        ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     BlankGap(),
        //     RoundNeuButton(
        //       child: Icon(
        //         Icons.arrow_right_rounded,
        //         size: 50,
        //         color: Colors.grey[700],
        //       ),
        //       rtdbKey: 'right',
        //       rtdbValueOn: true,
        //       rtdbValueOff: false,
        //     ),
        //     BlankGap(),
        //   ],
        // ),
        //   ],
        // ),
      ],
    );
  }
}
