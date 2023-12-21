import 'package:flutter/material.dart';

class LeagueListWidget extends StatelessWidget {
  final List<Widget> leadingWidgets;
  final List<String> titles;
  final IconData icon;
  final VoidCallback onTap;
  final double height;

  LeagueListWidget({
    required this.leadingWidgets,
    required this.titles,
    required this.icon,
    required this.onTap,
    required this.height,
  }) : assert(leadingWidgets.length == titles.length, 'The length of leadingWidgets and titles must be the same.');

  @override
  Widget build(BuildContext context) {
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
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: leadingWidgets.length,
      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              leadingWidgets[index],
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8), 
                  child: Text(
                    titles[index],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
                Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}
