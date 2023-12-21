import 'package:flutter/material.dart';

class LeagueListWidget extends StatelessWidget {
  final int items;
  final double height;

  LeagueListWidget({ required this.items  , required this.height});

  @override
  Widget build(BuildContext context) {
    // Container for the entire league list widget
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      height: height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: _buildListView(),
    );
  }

   Widget _buildListView() {
    return Container(
      height: height,
      child: ListView.separated(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: items,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey), 
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // show league or user details 
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Text(
                      "1",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "League/user name",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.primary),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}