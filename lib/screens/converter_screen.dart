import 'package:flutter/material.dart';

import '../services/currency_service.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  double _exchangeRate = 0.0;
  bool _isEurToUsd = true;
  TextEditingController _amountController = TextEditingController();
  String _result = '';

  @override
  void initState() {
    super.initState();
    _fetchExchangeRate();
  }

  void _fetchExchangeRate() async {
    double rate = await CurrencyService.getExchangeRate();
    setState(() {
      _exchangeRate = rate;
    });
  }

  void _convert() {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    double result = _isEurToUsd ? amount * _exchangeRate : amount / _exchangeRate;
    setState(() {
      _result = result.toStringAsFixed(2);
    });
  }

  void _toggleConversionDirection() {
    setState(() {
      _isEurToUsd = !_isEurToUsd;
      _result = '';
      _amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchExchangeRate,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount in ${_isEurToUsd ? 'EUR' : 'USD'}',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            Text(
              'Result: $_result ${_isEurToUsd ? 'USD' : 'EUR'}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleConversionDirection,
              child: Text('Switch to ${_isEurToUsd ? 'USD to EUR' : 'EUR to USD'}'),
            ),
          ],
        ),
      ),
    );
  }
}
