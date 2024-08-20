import 'package:app/components/other/nunito_text.dart';
import 'package:flutter/material.dart';

class LeagueListWidget extends StatelessWidget {
  final Widget? header;
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
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
            child: header,
          ),
        ],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3), 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 3),
                physics: const ClampingScrollPhysics(),
                itemCount: leadingWidgets.length,
                separatorBuilder: (context, index) => const SizedBox.shrink(),
                itemBuilder: (context, index) {
                  final Color backgroundColor = index.isEven
                    ? const Color.fromRGBO(255, 186, 75, 1)
                    : const Color.fromRGBO(255, 255, 255, 1);
                  final Color textColor = index.isEven
                    ? const Color.fromRGBO(255, 255, 255, 1)
                    : const Color.fromRGBO(30, 30, 27, 1);

                  return Material(
                    color: backgroundColor,
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
                                child: nunitoText(titles[index], 16, FontWeight.normal, textColor),
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
          ),
        ),
      ],
    );
  }
}
