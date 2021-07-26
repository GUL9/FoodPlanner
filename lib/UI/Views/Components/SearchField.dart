import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';
import 'package:grocerylister/util/strings.dart';

class SearchField extends StatefulWidget {
  final StreamController searchResults;
  final List<String> searchOptions;

  SearchField({this.searchOptions, this.searchResults});

  @override
  _SearchFieldState createState() => _SearchFieldState(searchOptions: searchOptions, searchResults: searchResults);
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController searchController = TextEditingController();
  final StreamController searchResults;
  final List<String> searchOptions;

  _SearchFieldState({this.searchOptions, this.searchResults});

  void search(String searchString) {
    for (var i = 0; i < searchOptions.length; i++)
      if (searchOptions[i].startsWith(searchString))
        return searchResults.sink.add({"index": i, "result": searchOptions[i]});

    for (var i = 0; i < searchOptions.length; i++)
      if (searchOptions[i].contains(searchString))
        return searchResults.sink.add({"index": i, "result": searchOptions[i]});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: searchController,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(hintText: Strings.search, suffixIcon: Icon(Icons.search, color: primary3)),
        onChanged: search);
  }
}
