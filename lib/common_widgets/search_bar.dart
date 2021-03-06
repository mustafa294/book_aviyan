import 'package:book_aviyan_final/services/user_state.dart';
import 'package:flutter/material.dart';

import 'package:book_aviyan_final/models/book_model.dart';
import 'package:book_aviyan_final/provider/book_provider.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showSearch(context: context, delegate: DataSearch());
      },
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Search All Books"),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<BookModel> suggestions = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Card(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _bookProvider = Provider.of<BookProvider>(context);

    List<BookModel> _bookList = _bookProvider.books;
    final List<BookModel> suggestionsItems = query.isEmpty
        ? suggestions
        : _bookList
            .where((element) =>
                element.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
        itemCount: suggestionsItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestionsItems[index].title!),
            onTap: () {
              showResults(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserState(index: index)));
            },
          );
        });
  }
}
