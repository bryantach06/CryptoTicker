import 'package:bitcoin_ticker/coin_card.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  var coinPrice;

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {},
      children: currenciesList.map((currency) => Text(currency)).toList(),
    );
  }

  DropdownButtonFormField androidDropdown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black38, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getCoinPrices();
        });
      },
      items: currenciesList
          .map((currency) => DropdownMenuItem(
                value: currency,
                child: Text(currency),
              ))
          .toList(),
    );
  }

  bool isWaiting = false;
  Map<String, String> coinValues = {};

  void getCoinPrices() async {
    isWaiting = true;
    try {
      var data = await CoinModel().getCoinData(selectedCurrency, context);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCoinPrices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Ticker'),
        actions: [
          IconButton(
            onPressed: () {
              getCoinPrices();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CoinCard(
                value: isWaiting ? '?' : coinValues['BTC'],
                selectedCurrency: selectedCurrency,
                cryptoCurrency: 'BTC',
              ),
              CoinCard(
                value: isWaiting ? '?' : coinValues['ETH'],
                selectedCurrency: selectedCurrency,
                cryptoCurrency: 'ETH',
              ),
              CoinCard(
                value: isWaiting ? '?' : coinValues['LTC'],
                selectedCurrency: selectedCurrency,
                cryptoCurrency: 'LTC',
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: kContainerBorderRadius,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            height: 150.0,
            alignment: Alignment.center,
            child: Padding(
              padding: kPaddingSymmetricHorizontal20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Select currency', style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),),
                  Platform.isAndroid ? androidDropdown() : iOSPicker(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
