// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:filter_list/filter_list.dart';

class Quote {
   String quote;
   String author;

  Quote(this.quote, this.author);
}


class MotivatingPage extends StatefulWidget {
  const MotivatingPage({super.key});

  @override
  State<MotivatingPage> createState() => _MotivatingPageState();
}

class _MotivatingPageState extends State<MotivatingPage> {
  List<Quote> _loadedQuote = [];
  List<Quote> _selectedQuoteList = [];

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    const apiUrl = "https://zenquotes.io/api/quotes";
    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);

    setState(() {
      _loadedQuote = List<Quote>.from(data.map((json) => Quote(json['q'], json['a'])));
    });
  }

  void openFilterDialog() async {
    await FilterListDialog.display<Quote>(
      context, 
      listData: _loadedQuote, 
      selectedListData: _selectedQuoteList,
      choiceChipLabel: (quote) => quote!.author, 
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (quote, query) {
        return quote.author.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          _selectedQuoteList = List.from(list!);
        });
        Navigator.pop(context);
      },
      height: MediaQuery.of(context).size.height * 0.5,
      
    );
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
            : Column(
              children: [
                FloatingActionButton(
                  onPressed: openFilterDialog,
                  child: Icon(Icons.filter_list_alt)
                  ),
                Expanded(
                  child: (_selectedQuoteList.isEmpty) ? ListView.builder(
                      itemCount: _loadedQuote.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return ListTile(
                          leading: Icon(Icons.lightbulb_rounded, size: 45),
                          title: Text(_loadedQuote[index].quote),
                          subtitle: Text(_loadedQuote[index].author),
                        );
                      }) : ListView.builder(
                        itemCount: _selectedQuoteList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return ListTile(
                          leading: Icon(Icons.lightbulb_rounded, size: 45),
                          title: Text(_selectedQuoteList[index].quote),
                          subtitle: Text(_selectedQuoteList[index].author),
                            );
                          }     
                        )
                ),
              ],
            ),
      ),
    );
  }
}
