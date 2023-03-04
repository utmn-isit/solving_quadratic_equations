import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Решение квадратного уравнения'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _cController = TextEditingController();

  String _errorText = '';
  String resultText = '';
  String xText = '';
  double? _x1;
  double? _x2;

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      xText = '';
      _x1 = _x2 = null;
      double? a = double.tryParse(_aController.text);
      double? b = double.tryParse(_bController.text);
      double? c = double.tryParse(_cController.text);

      if (_aController.text.isEmpty && _bController.text.isEmpty
      && _cController.text.isEmpty) {
        _errorText = '';
        return;
      }
      else if (_aController.text.isEmpty || _bController.text.isEmpty
          || _cController.text.isEmpty) {
        _errorText = 'Введите данные';
        return;
      }
      else if (a == null || b == null || c == null) {
        _errorText = 'Введите корректные данные';
        return;
      }
      else {
        _errorText = '';
      }

      if (a == 0 && b == 0 && c == 0) {
        xText = "x \u2208 R";
      }
      else if (a == 0 && b != 0) {
        _x1 = _x2 = -c / b;
      }
      else if (a !=0 && c != 0){
        double d = pow(b, 2) - 4 * a * c;
        if (d >= 0) {
          _x1 = (-b + sqrt(d)) / (2 * a);
          _x2 = (-b - sqrt(d)) / (2 * a);
        }
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Результат:'),
            content: xText.isNotEmpty
                ? Text(xText, textAlign: TextAlign.center,)
                : _x1 == null
                ? const Text('Уравнение не имеет корней', textAlign: TextAlign.center,)
                : _x1 == _x2
                ? Text('x = ${_x1! % 1 == 0 ? _x1?.toInt() : _x1?.toStringAsFixed(3)}', textAlign: TextAlign.center)
                : Text('x₁ = ${_x1! % 1 == 0 ? _x1?.toInt() : _x1?.toStringAsFixed(3)}'
                ', x₂ = ${_x2! % 1 == 0 ? _x2?.toInt() : _x2?.toStringAsFixed(3)}',
              textAlign: TextAlign.center,),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _aController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Введите коэффициент a',
              ),
            ),
            TextField(
              controller: _bController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Введите коэффициент b',
              ),
            ),
            TextField(
              controller: _cController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Введите коэффициент c',
              ),
            ),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Вычислить'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                  _errorText,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
