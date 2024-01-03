import 'package:flutter/material.dart';

class LeagueListWidget extends StatelessWidget {
  final List<Widget> leadingWidgets;
  final List<String> titles;
  final List<Object?>? addons;
  final IconData icon;
  final Function(int) onTap;
  final double height;

  const LeagueListWidget({
    required this.leadingWidgets,
    required this.titles,
    this.addons,
    required this.icon,
    required this.onTap,
    required this.height,
  }) : assert(
    (addons == null ? leadingWidgets.length == titles.length : leadingWidgets.length == titles.length && leadingWidgets.length == addons.length),
   'The length of addons (optional), leadingWidgets and titles must be the same.',
   );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: leadingWidgets.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
      itemBuilder: (context, index) {
        return Material(
          child: InkWell(
            onTap: () => onTap(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                leadingWidgets[index],
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8), 
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
          ),
        );
      },
    );
  }
}
