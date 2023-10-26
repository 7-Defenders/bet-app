import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BetPreviewWidget extends StatefulWidget {
  final String eventName;
  final String eventDetails;
  final Map<String, double> bets;

  const BetPreviewWidget({super.key, required this.eventName, required this.eventDetails, required this.bets});

  @override
  _BetPreviewWidgetState createState() => _BetPreviewWidgetState();
}

class _BetPreviewWidgetState extends State<BetPreviewWidget> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final double containterWidth = MediaQuery.of(context).size.width * 0.9;
    const double padding = 8.0;
    const SizedBox paddingBox = SizedBox(height: padding, width: padding);

    return Card(
      elevation: 20,
      child: Container(
        width: containterWidth,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 136, 0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Wrap(
          children: [
            Column(
              children: [
                paddingBox,
                Row(
                  children: [
                    paddingBox,
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: SvgPicture.asset('lib/assets/images/futbol-regular.svg'),
                    ),
                    paddingBox,
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.eventName,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.eventDetails),
                        ),
                      ],
                    ),
                  ],
                ),
                paddingBox,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.bets.entries.map((entry) {
                    return SizedBox(
                      width: containterWidth / widget.bets.length,
                      height:40.0,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedOption = _selectedOption == entry.key ? null : entry.key;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _selectedOption == entry.key ? Colors.blue : Colors.amber,
                        ),
                        child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: 
                              [
                                Text(entry.key),
                                Text(entry.value.toString()),
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
