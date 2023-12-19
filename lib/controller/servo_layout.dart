// import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loginpage/controller/maincontroller.dart';
import 'package:provider/provider.dart';
import 'package:loginpage/controller/customeq.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ServoLayout(
    children: [],
  ));
}

class BluetoothIndicator extends StatelessWidget {
  final bool isConnected;

  BluetoothIndicator({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, // Adjust width as needed
      height: 20, // Adjust height as needed
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isConnected ? Colors.green : Colors.red,
      ),
    );
  }
}

class ServoLayout extends StatefulWidget {
  const ServoLayout({super.key, required List<Positioned> children});

  @override
  _ServoLayoutState createState() => _ServoLayoutState();
}

class _ServoLayoutState extends State<ServoLayout> {
  double servo1 = 0.0;

  @override
  void initState() {
    super.initState();
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('servo1').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        double initialValue = double.parse(snapshot.value.toString());
        setState(() {
          servo1 = initialValue;
        });
      }
    }, onError: (error) {
      // Handle the error, if needed
      print('Error retrieving servo1 value: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 224, 224),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 70.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Z A N A L O S',
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(width: 10), // Adjust as needed for spacing
                  Row(
                    children: [
                      BluetoothIndicator(isConnected: false),
                    ],
                  ), // Your indicator widget
                ],
              ),
              const SizedBox(height: 70.0),
              const Expanded(
                child: MainController(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  color: const Color.fromARGB(255, 224, 224, 224),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.grey[300]!,
                              Colors.grey[300]!,
                              Colors.grey[300]!,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'V O L U M E',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500],
                                ),
                              ),
                              SizedBox(
                                width: 300.0, // Adjust the width as needed
                                child: Slider(
                                  value: servo1,
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  label: servo1.round().toString(),
                                  thumbColor: Colors.grey[700],
                                  activeColor: Colors.grey[100],
                                  inactiveColor: Colors.grey[600],
                                  onChanged: (double value) {
                                    setState(() {
                                      servo1 = value;
                                    });
                                    DatabaseReference databaseReference =
                                        FirebaseDatabase.instance.reference();
                                    databaseReference
                                        .child('servo1')
                                        .set(value.round());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ), // Add other UI elements here...
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[300],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                },
                child: const Text(
                  'Equalizer',
                  style: TextStyle(
                    color: Color(0xFF424242),
                  ),
                ),
              ),
            ],
          ),
          // Add BluetoothIndicator widget here and position it as needed
          // Positioned(
          //   top: 100, // Adjust top position as needed
          //   right: 20, // Adjust right position as needed
          //   child: BluetoothIndicator(isConnected: true),
          // ),
        ],
      ),
    );
  }
}

class UserStatus with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }
}
