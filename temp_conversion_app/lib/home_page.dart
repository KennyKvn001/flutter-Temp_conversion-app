import 'package:flutter/material.dart';

class TempConverter extends StatefulWidget {
  const TempConverter({super.key});

  @override
  State<TempConverter> createState() => _TempConverterState();
}

class _TempConverterState extends State<TempConverter> {
  String _conversionType = 'ftoc';
  final TextEditingController _inputController = TextEditingController();
  double? _convertedTemp;
  List<String> _history = [];

  void _handleConversionTypeChange(String? value) {
    setState(() {
      _conversionType = value!;
      _convertedTemp = null;
    });
  }

  void _convertTemperature() {
    double? inputTemp = double.tryParse(_inputController.text);
    if (inputTemp == null) return;

    setState(() {
      if (_conversionType == 'ftoc') {
        _convertedTemp = (inputTemp - 32) * 5 / 9;
        _addToHistory('F to C', inputTemp, _convertedTemp!);
      } else {
        _convertedTemp = (inputTemp * 9 / 5) + 32;
        _addToHistory('C to F', inputTemp, _convertedTemp!);
      }
    });
  }

  void _addToHistory(String operation, double input, double result) {
    _history.insert(0,
        '$operation: ${input.toStringAsFixed(1)} => ${result.toStringAsFixed(1)}');
    if (_history.length > 5) _history.removeLast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Temperature Converter',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('°F to °C'),
                        value: 'ftoc',
                        groupValue: _conversionType,
                        onChanged: _handleConversionTypeChange,
                        activeColor: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('°C to °F'),
                        value: 'ctof',
                        groupValue: _conversionType,
                        onChanged: _handleConversionTypeChange,
                        activeColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _inputController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText:
                        'Enter temperature in ${_conversionType == 'ftoc' ? '°F' : '°C'}',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    _convertTemperature();
                    _inputController.clear();
                  },
                  child: const Text(
                    'Convert',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                if (_convertedTemp != null)
                  Text(
                    'Converted Temperature: ${_convertedTemp!.toStringAsFixed(2)}° ${_conversionType == 'ftoc' ? 'C' : 'F'}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Conversion History:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _history.map((entry) => Text(entry)).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
