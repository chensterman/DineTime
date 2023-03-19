import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> paymentLink() {
  return http.post(
    Uri.parse(
        'https://connect.squareupsandbox.com/v2/online-checkout/payment-links'),
    headers: <String, String>{
      'Square-Version': '2023-01-19',
      'Authorization':
          'Bearer EAAAEBuvXFUFXTzEMEV6Xyu-lOGN5H1d0dt4Y3zEGyqJxaYxYPto17QL5jl_4CXb',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {
        "order": {
          "location_id": "LKTG1QBR5CWS7",
          "line_items": [
            {
              "quantity": "1",
              "base_price_money": {"amount": 30, "currency": "USD"},
              "name": "Test Item"
            }
          ]
        }
      },
    ),
  );
}

void main() async {
  final test = await paymentLink();
  print(jsonDecode(test.body));
}
