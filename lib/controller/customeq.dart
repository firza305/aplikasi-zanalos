import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool enableCustomEQ = false;

  @override
  void initState() {
    super.initState();
    EqualizerFlutter.init(0);
  }

  @override
  void dispose() {
    EqualizerFlutter.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Equalizer example'),
          backgroundColor: const Color.fromARGB(255, 197, 196, 196),
          foregroundColor: const Color.fromARGB(255, 49, 50, 50),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle menu button press
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Handle settings button press
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(height: 10.0),
            Center(
              child: Builder(
                builder: (context) {
                  return TextButton.icon(
                    icon: const Icon(Icons.equalizer),
                    label: const Text('Open device equalizer'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 59, 59, 59),
                      backgroundColor: const Color.fromARGB(255, 197, 196, 196),
                    ),
                    onPressed: () async {
                      try {
                        await EqualizerFlutter.open(0);
                      } on PlatformException catch (e) {
                        final snackBar = SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('${e.message}\n${e.details}'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              color: Colors.grey.withOpacity(0.1),
              child: SwitchListTile(
                title: const Text('Custom Equalizer'),
                value: enableCustomEQ,
                onChanged: (value) {
                  EqualizerFlutter.setEnabled(value);
                  setState(() {
                    enableCustomEQ = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<int>>(
              future: EqualizerFlutter.getBandLevelRange(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? CustomEQ(enableCustomEQ, snapshot.data!)
                    : const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomEQ extends StatefulWidget {
  const CustomEQ(this.enabled, this.bandLevelRange, {Key? key})
      : super(key: key);

  final bool enabled;
  final List<int> bandLevelRange;

  @override
  _CustomEQState createState() => _CustomEQState();
}

class _CustomEQState extends State<CustomEQ> {
  late double min, max;
  String? _selectedValue;
  late Future<List<String>> fetchPresets;

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    fetchPresets = EqualizerFlutter.getPresetNames();
  }

  @override
  Widget build(BuildContext context) {
    int bandId = 0;
    return FutureBuilder<List<int>>(
      future: EqualizerFlutter.getCenterBandFreqs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data;
          if (data != null && data.isNotEmpty) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data
                      .map((freq) => _buildSliderBand(freq, bandId))
                      .toList(),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: _buildPresets(),
                ),
              ],
            );
          } else {
            return const Text('Data is empty or null');
          }
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildSliderBand(int freq, int bandId) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: FutureBuilder<int>(
              future: EqualizerFlutter.getBandLevel(bandId),
              builder: (context, snapshot) {
                var data = snapshot.data?.toDouble() ?? 0.0;
                return RotatedBox(
                  quarterTurns: 1,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 1,
                      trackShape: SliderCustomTrackShape(),
                      thumbColor: Colors.blue,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayColor: Colors.blue.withOpacity(0.2),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                    ),
                    child: Center(
                      child: Slider(
                        min: min,
                        max: max,
                        value: data,
                        onChanged: (lowerValue) {
                          EqualizerFlutter.setBandLevel(
                              bandId, lowerValue.toInt());
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            '${freq ~/ 1000} Hz',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresets() {
    return FutureBuilder<List<String>>(
      future: fetchPresets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final presets = snapshot.data;
          if (presets!.isEmpty) return const Text('No presets available!');
          return DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Available Presets',
              border: OutlineInputBorder(),
            ),
            value: _selectedValue,
            onChanged: widget.enabled
                ? (String? value) {
                    EqualizerFlutter.setPreset(value!);
                    setState(() {
                      _selectedValue = value;
                    });
                  }
                : null,
            items: presets.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text(
            snapshot.error.toString(),
            style: const TextStyle(
              color: Colors.red,
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class SliderCustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = (parentBox.size.height) / 2;
    const double trackWidth = 230;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight!);
  }
}
