import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class BetMaker extends StatefulWidget {
  final String gameName;
  final String betType;
  final double odds;
  final String matchRef;
  final TextEditingController amountController;
  final VoidCallback onRemove;
  final Future<bool> Function(
    int amount,
    String betType,
    double odds,
    String matchRef,
  ) createBet;

  const BetMaker({
    required this.gameName,
    required this.betType,
    required this.odds,
    required this.matchRef,
    required this.amountController,
    required this.onRemove,
    required this.createBet,
  });

  @override
  _BetMakerState createState() => _BetMakerState();
}

class _BetMakerState extends State<BetMaker> {
  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   title: Text('Match: ${widget.gameName}'),
    //   subtitle: Row(
    //     children: [
    //       Expanded(
    //         child: Text('Option: ${widget.betType}'),
    //       ),
    //       Text('Odds: ${widget.odds}'),
    //       IconButton(
    //         icon: const Icon(Icons.close),
    //         onPressed: widget.onRemove,
    //       ),
    //       Expanded(
    //         child: TextField(
    //           decoration: const InputDecoration(
    //             labelText: 'Amount',
    //           ),
    //           controller: widget.amountController,
    //           keyboardType: TextInputType.number,
    //           inputFormatters: <TextInputFormatter>[
    //             FilteringTextInputFormatter.digitsOnly,
    //           ], // Only numbers can be entered
    //         ),
    //       ),
    //       ElevatedButton(
    //         onPressed: () {
    //           final int amount = int.parse(widget.amountController.text);
    //           final Future<bool> betFuture = widget.createBet(
    //             amount,
    //             widget.betType,
    //             widget.odds,
    //             widget.matchRef,
    //           );

    //           showDialog(
    //             context: context,
    //             builder: (BuildContext context) {
    //               return FutureBuilder<bool>(
    //                 future: betFuture,
    //                 builder: (
    //                   BuildContext context,
    //                   AsyncSnapshot<bool> snapshot,
    //                 ) {
    //                   if (snapshot.connectionState == ConnectionState.waiting) {
    //                     return const AlertDialog(
    //                       title: Text('Placing bet...'),
    //                       content: CircularProgressIndicator(),
    //                     );
    //                   } else if (snapshot.hasError) {
    //                     return AlertDialog(
    //                       title: const Text('Error'),
    //                       content: const Text('Failed to create bet.'),
    //                       actions: <Widget>[
    //                         TextButton(
    //                           child: const Text('OK'),
    //                           onPressed: () {
    //                             Navigator.of(context).pop();
    //                           },
    //                         ),
    //                       ],
    //                     );
    //                   } else {
    //                     final bool success = snapshot.data ?? false;
    //                     return AlertDialog(
    //                       title: const Text('Bet Status'),
    //                       content: Text(
    //                         success
    //                             ? 'Bet created successfully.'
    //                             : 'Failed to create bet.',
    //                       ),
    //                       actions: <Widget>[
    //                         TextButton(
    //                           child: const Text('OK'),
    //                           onPressed: () {
    //                             Navigator.of(context).pop();
    //                           },
    //                         ),
    //                       ],
    //                     );
    //                   }
    //                 },
    //               );
    //             },
    //           );
    //         },
    //         child: const Text('Place Bet'),
    //       ),
    //     ],
    //   ),
    // );
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'lib/assets/images/futbol-regular.svg',
                      height: 30,
                      width: 30,
                    ), // Adjust size as needed
                    const SizedBox(width: 10),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 160, minWidth: 160),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.gameName,
                            style: const TextStyle(
                              fontSize: 18,
                            ), // Adjust font size as needed
                          ),
                          const Text(
                            'Temporary text', // Replace with actual text
                            style: TextStyle(
                              fontSize: 12,
                            ), // Adjust font size as needed
                          ), // Replace with actual text
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          'lib/assets/images/odds_trapeze.svg',
                          height: 40,
                        ), // Adjust size as needed
                        Text(
                          '${widget.odds}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ), // Adjust font size as needed
                        ),
                      ],
                    ),
                    const SizedBox(width: 25),
                    Text(
                      widget.betType,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Adjust font size as needed
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Adjust radius for more rectangular shape
                      ),
                    ),
                    controller: widget.amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ], // Only numbers can be entered
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    {
                      final int amount =
                          int.parse(widget.amountController.text);
                      final Future<bool> betFuture = widget.createBet(
                        amount,
                        widget.betType,
                        widget.odds,
                        widget.matchRef,
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FutureBuilder<bool>(
                            future: betFuture,
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<bool> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const AlertDialog(
                                  title: Text('Placing bet...'),
                                  content: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Failed to create bet.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                final bool success = snapshot.data ?? false;
                                return AlertDialog(
                                  title: const Text('Bet Status'),
                                  content: Text(
                                    success
                                        ? 'Bet created successfully.'
                                        : 'Failed to create bet.',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Place Bet'),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
