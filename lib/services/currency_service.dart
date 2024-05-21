import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const _apiUrl = 'https://api.exchangerate-api.com/v4/latest/EUR';

  static Future<double> getExchangeRate() async {
    final response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['rates']['USD'];
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }
}
