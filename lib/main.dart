import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


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

  List<double> prices = [10000,];
  int counter = 0;
  final Duration interval = Duration(seconds: 30);
  final int chartLength = 100;

  @override
  void initState() {
    super.initState();
    Timer.periodic(interval, (timer) {
      addCurrentPrice();
    });
  }

  void addCurrentPrice() async {
    var response = await http.get(Uri.encodeFull('https://blockchain.info/ticker'));
    var data = json.decode(response.body);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(counter.toString(), data['USD']['last']);
    counter++;

    setState(() {
      prices.add(data['USD']['last']);
    });
    print(data['USD']['last']);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin Price'),
      ),
      body: _getChart(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: addCurrentPrice,
      //   child: Icon(Icons.attach_money),
      // ),
      bottomSheet: ListTile(
        leading: Icon(
          Icons.attach_money,
          color: Colors.pink.shade500,
          size: 32.0,
        ),
        title: Text(
          prices[prices.length-1].toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32.0,
            color: Colors.pink.shade500,
          ),
        )
      ),
    );
  }

  Widget _priceList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i >= prices.length) return null;
        return ListTile(
          title: Text(prices[abs(i - (prices.length - 1))].toString()),
          );
      },
    );
  }

  Widget _getChart() {
    List<double> data = [];
    if (prices.length <= chartLength) {
      data = prices;
    }
    else {
      data = prices.sublist(prices.length - chartLength);
    }
    return new Container(
      height: 300.0,
      padding: new EdgeInsets.all(30.0),
      child: new Sparkline(data: data),
    );
  }

  int abs(int value) {
    if (value < 0) return -value;
    return value;
  }
}


