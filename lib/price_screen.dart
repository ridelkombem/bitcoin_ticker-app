import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> getDropItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      getDropItems.add(newItem);
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: getDropItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
          });
        });
  }

  CupertinoPicker iosPicker() {
    List<Text> getItems = [];
    for (String currency in currenciesList) {
      getItems.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      children: getItems,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
        //  call getData when the picker dropdown changes
      },
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;
  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🤑 Coin Ticker',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'BTC',
            value: isWaiting ? '?' : coinValues['BTC']!,
          ),
          CryptoCard(
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'ETH',
            value: isWaiting ? '?' : coinValues['ETH']!,
          ),
          CryptoCard(
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'LTC',
            value: isWaiting ? '?' : coinValues['LTC']!,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({Key? key,
    required this.selectedCurrency,
    required this.value,
    required this.cryptoCurrency,}) : super(key: key);


  final String selectedCurrency;
  final String value;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value$selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
