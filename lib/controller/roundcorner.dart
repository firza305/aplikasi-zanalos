import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RoundNeuButton extends StatefulWidget {
  final Widget child;
  final String rtdbKey;
  final dynamic rtdbValueOn;
  final dynamic rtdbValueOff;

  RoundNeuButton({
    required this.child,
    required this.rtdbKey,
    required this.rtdbValueOn,
    required this.rtdbValueOff,
  });

  @override
  State<RoundNeuButton> createState() => _RoundNeuButtonState();
}

class _RoundNeuButtonState extends State<RoundNeuButton> {
  bool isDeviceOn = false;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isDeviceOn = !isDeviceOn; // Toggle the device state
          print('Button Pressed, Device is ${isDeviceOn ? 'On' : 'Off'}');
          databaseRef
              .child(widget.rtdbKey)
              .set(isDeviceOn ? widget.rtdbValueOn : widget.rtdbValueOff);
        });
      },
      child: Container(
        width: 160,
        height: 160,
        child: Center(
          child: widget.child,
        ),
        decoration: BoxDecoration(
          color: isDeviceOn ? Colors.grey[200] : Colors.grey[300],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
