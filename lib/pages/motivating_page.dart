// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MotivatingPage extends StatefulWidget {
  const MotivatingPage({super.key});

  @override
  State<MotivatingPage> createState() => _MotivatingPageState();
}

class _MotivatingPageState extends State<MotivatingPage> {
  List _loadedQuote = [];
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    const apiUrl = "https://zenquotes.io/api/random";
    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);

    setState(() {
      _loadedQuote = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Motivating Page'),
        ),
        body: SafeArea(
            child: _loadedQuote.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.lightbulb_rounded, size: 45),
                            title: Text(_loadedQuote[0]["q"]),
                            subtitle: Text(_loadedQuote[0]["a"]),
                          )
                        ],
                      ),
                    ),
                  )
                )
              );
            }
          }
