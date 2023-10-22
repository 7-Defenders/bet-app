import 'package:flutter/material.dart';

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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Wrap(
        spacing: 8.0,
        children: [
          Column(
          children: [...[
            Text(widget.eventName),
            Text(widget.eventDetails),
            ],
            Row(
              children: widget.bets.entries.map((entry) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedOption = entry.key;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedOption == entry.key ? Colors.blue : Colors.amber,
                ),
                child:
                    Column(
                  children: [
                    Text(entry.key),
                    Text(entry.value.toString()),
                    ],
                  ),
              ); 
              }).toList(),),
            ],),],
            ),

      );
  }
}
