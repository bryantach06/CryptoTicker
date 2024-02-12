import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = '9C34FBDF-AE3A-418D-AB7A-4C32A3005B80';

const btcUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CoinModel {
  Future getCoinData(String currency, BuildContext context) async {

    Map<String, String> cryptoPrices = {};

    for (var coin in cryptoList) {
      String url = '$btcUrl/$coin/$currency?apikey=$apiKey';

      log(url);

      http.Response response = await http.get(Uri.parse(url));

      log('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        double lastPrice = decodedData['rate'];
        cryptoPrices[coin] = lastPrice.toStringAsFixed(0);
      } else if (response.statusCode == 429) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              content: const Text('Request limit reached!'),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
              duration: const Duration(milliseconds: 1500),
              width: 300.0, // Width of the SnackBar.
              padding: const EdgeInsets.only(
                left: 20, // Inner padding for SnackBar content.
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        }
      } else {
        log('${response.statusCode}');
      }
    }
    return cryptoPrices;
  }
}
