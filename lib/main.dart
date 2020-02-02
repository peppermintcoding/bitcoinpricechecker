import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


void main() => runApp(BitcoinApp());

class BitcoinApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitcoin',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: BitcoinPrice(),
    );
  }

}

class BitcoinPrice extends StatefulWidget {

  @override
  _BitcoinPriceState createState() => _BitcoinPriceState();

}

class _BitcoinPriceState extends State<BitcoinPrice> {

  List<double> prices = [];

  @override
  void initState() {
    super.initState();
  }

  void addCurrentPrice() async {
    var response = await http.get(Uri.encodeFull('https://blockchain.info/ticker'));
    var data = json.decode(response.body);
    print(data['USD']['last']);
    
    setState(() {
      prices.add(data['USD']['last']);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin'),
      ),
      body: _priceList(),
      floatingActionButton: FloatingActionButton(
        onPressed: addCurrentPrice,
        child: Icon(Icons.attach_money),
      ),
    );
  }

  Widget _priceList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i >= prices.length) return null;
        return ListTile(
          title: Text(prices[abs(i - (prices.length - 1))].toString())
          ,);
      },
    );
  }

  int abs(int value) {
    if (value < 0) return -value;
    return value;
  }
}


