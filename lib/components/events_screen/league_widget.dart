import 'package:flutter/material.dart';
import 'package:app/models/structure.dart'; // Make sure this points to your League model

class LeagueListWidget extends StatelessWidget {
  final String title;
  final List<League> leagues;

  LeagueListWidget({
    required this.title,
    required this.leagues,
  });

  @override
  Widget build(BuildContext context) {
    // Container for the entire league list widget
    return Container(
      // The width is set to the screen's width minus 32 for margin
      width: MediaQuery.of(context).size.width - 32, 
      // Padding inside the container
      padding: const EdgeInsets.all(8.0),
      // Decoration for the container including color, border radius, and shadow
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade200,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      // Column for title and the list
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container for the title of the league list
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade800,
              ),
            ),
          ),
          // Expanded to allow the ListView to take all available space
          Expanded(
            child: _buildListView(),
          ),
        ],
      ),
    );
  }

  // Builds the list view of leagues
  Widget _buildListView() {
    // ListView to allow scrolling through the leagues
    return ListView.separated(
      // shrinkWrap makes the ListView only as tall as needed
      shrinkWrap: true,
      // ClampingScrollPhysics allows the ListView to scroll
      physics: ClampingScrollPhysics(),
      itemCount: leagues.length,
      // Builder for the dividers in the list
      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.orange.shade600),
      // Builder for the individual league list items
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Placeholder for the tap event
          },
          // Padding for each list item
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // Row for the ranking number, league name, and trailing icon
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container for the ranking number with right margin
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.grey, // Ranking number color
                    ),
                  ),
                ),
                // Expanded to allow the league name to take available space
                Expanded(
                  child: Text(
                    leagues[index].name,
                    style: TextStyle(
                      color: Colors.black, // League name color
                    ),
                  ),
                ),
                // Trailing icon for navigation indication
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange.shade800),
              ],
            ),
          ),
        );
      },
    );
  }
}
