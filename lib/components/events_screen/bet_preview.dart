import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BetPreviewWidget extends StatefulWidget {
  final String eventName;
  final String eventDetails;
  final Map<String, double> bets;
  final ValueChanged<String>? onOptionSelected;
  final String? initialSelection;
  final String? matchRef;

  const BetPreviewWidget({
    super.key,
    required this.eventName,
    required this.eventDetails,
    required this.bets,
    required this.onOptionSelected,
    this.initialSelection,
    this.matchRef,
  });

  @override
  _BetPreviewWidgetState createState() => _BetPreviewWidgetState();
}

class _BetPreviewWidgetState extends State<BetPreviewWidget> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialSelection;
    //print(widget.initialSelection);
  }

  @override
  Widget build(BuildContext context) {
    //final buttonStatesProvider = Provider.of<ButtonStatesProvider>(context);
    final double containterWidth = MediaQuery.of(context).size.width * 0.9;
    const double padding = 8.0;
    const SizedBox paddingBox = SizedBox(height: padding, width: padding);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        width: containterWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.fromLTRB(8, 3, 8, 8),
        child: Wrap(
          children: [
            Column(
              children: [
                paddingBox,
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      paddingBox,
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(
                          'lib/assets/images/futbol-regular.svg',
                        ),
                      ),
                      paddingBox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            child: Text(
                              widget.eventName,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                          Align(
                            child: Text(
                              widget.eventDetails,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.bets.entries.map((entry) {
                    return SizedBox(
                      width:
                          (containterWidth - 4 * padding) / widget.bets.length,
                      height: 38.0,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedOption =
                                _selectedOption == entry.key ? null : entry.key;
                            widget.onOptionSelected!(entry.key);
                            debugPrint(entry.key);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedOption == entry.key
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 0.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            Text(
                              entry.value.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
