import 'package:flutter/material.dart';

class LeagueListWidget extends StatelessWidget {
  final String? header;
  final List<Widget> leadingWidgets;
  final List<String> titles;
  // final List<Object?>? addons;
  final List<Widget> trailingWidgets;
  final Function(int) onTap;
  final double height;

  const LeagueListWidget({
    this.header,
    required this.leadingWidgets,
    required this.titles,
    // this.addons,
    required this.trailingWidgets,
    required this.onTap,
    required this.height,
  }) : assert(
          leadingWidgets.length == titles.length &&
              leadingWidgets.length == trailingWidgets.length, 
          'The length of leadingWidgets, titles, and trailingWidgets must be the same.',
        );
        // assert(
        //   addons == null || leadingWidgets.length == addons.length,
        //   'The length of addons (optional) and leadingWidgets must be the same.',
        // );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
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
    return Column(
      children: [
        if (header != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              header!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // const Divider(height: 1, color: Colors.grey),
        ],
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
            physics: const ClampingScrollPhysics(),
            itemCount: leadingWidgets.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
            itemBuilder: (context, index) {
              Color backgroundColor = index.isOdd 
                ? Color.fromRGBO(255, 186, 75, 1)
                : Color.fromRGBO(250, 222, 176, 1);

              return Material(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(5),
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
                        trailingWidgets[index],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
