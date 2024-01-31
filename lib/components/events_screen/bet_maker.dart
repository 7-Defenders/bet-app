import 'package:app/components/other/nunito_text.dart';
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
    // return Card(
    //   margin: const EdgeInsets.all(10),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   child: Container(
    //     color: Theme.of(context).colorScheme.background,
    //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    //     child: Column(
    //       children: [
    //         Column(
    //           children: [
    //             Row(
    //               children: [
    //                 SvgPicture.asset(
    //                   'lib/assets/images/futbol-regular.svg',
    //                   height: 30,
    //                   width: 30,
    //                 ), // Adjust size as needed
    //                 const SizedBox(width: 10),
    //                 ConstrainedBox(
    //                   constraints:
    //                       const BoxConstraints(maxWidth: 160, minWidth: 160),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         widget.gameName,
    //                         style: const TextStyle(
    //                           fontSize: 18,
    //                         ), // Adjust font size as needed
    //                       ),
    //                       const Text(
    //                         'Temporary text', // Replace with actual text
    //                         style: TextStyle(
    //                           fontSize: 12,
    //                         ), // Adjust font size as needed
    //                       ), // Replace with actual text
    //                     ],
    //                   ),
    //                 ),
    //                 const SizedBox(width: 15),
    //                 Stack(
    //                   alignment: Alignment.center,
    //                   children: [
    //                     SvgPicture.asset(
    //                       'lib/assets/images/odds_trapeze.svg',
    //                       height: 40,
    //                     ), // Adjust size as needed
    //                     Text(
    //                       '${widget.odds}',
    //                       style: TextStyle(
    //                         fontSize: 20,
    //                         fontWeight: FontWeight.bold,
    //                         color: Theme.of(context).colorScheme.error,
    //                       ), // Adjust font size as needed
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(width: 25),
    //                 Text(
    //                   widget.betType,
    //                   style: TextStyle(
    //                     fontSize: 20,
    //                     color: Theme.of(context).colorScheme.onBackground,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ), // Adjust font size as needed
    //               ],
    //             ),
    //           ],
    //         ),
    //         const SizedBox(height: 5),
    //         Row(
    //           children: [
    //             Expanded(
    //               child: TextField(
    //                 decoration: InputDecoration(
    //                   labelText: 'Amount',
    //                   contentPadding: const EdgeInsets.all(10),
    //                   border: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(
    //                       10.0,
    //                     ), // Adjust radius for more rectangular shape
    //                   ),
    //                 ),
    //                 controller: widget.amountController,
    //                 keyboardType: TextInputType.number,
    //                 inputFormatters: <TextInputFormatter>[
    //                   FilteringTextInputFormatter.digitsOnly,
    //                 ], // Only numbers can be entered
    //               ),
    //             ),
    //             const SizedBox(width: 10),
    //             ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    //                 backgroundColor: Theme.of(context).colorScheme.onSurface,
    //                 foregroundColor: Theme.of(context).colorScheme.onPrimary,
    //                 padding: const EdgeInsets.all(10),
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(12),
    //                 ),
    //               ),
    //               onPressed: () {
    //                 {
    //                   final int amount =
    //                       int.parse(widget.amountController.text);
    //                   final Future<bool> betFuture = widget.createBet(
    //                     amount,
    //                     widget.betType,
    //                     widget.odds,
    //                     widget.matchRef,
    //                   );

    //                   showDialog(
    //                     context: context,
    //                     builder: (BuildContext context) {
    //                       return FutureBuilder<bool>(
    //                         future: betFuture,
    //                         builder: (
    //                           BuildContext context,
    //                           AsyncSnapshot<bool> snapshot,
    //                         ) {
    //                           if (snapshot.connectionState ==
    //                               ConnectionState.waiting) {
    //                             return const AlertDialog(
    //                               title: Text('Placing bet...'),
    //                               content: CircularProgressIndicator(),
    //                             );
    //                           } else if (snapshot.hasError) {
    //                             return AlertDialog(
    //                               title: const Text('Error'),
    //                               content: const Text('Failed to create bet.'),
    //                               actions: <Widget>[
    //                                 TextButton(
    //                                   child: const Text('OK'),
    //                                   onPressed: () {
    //                                     Navigator.of(context).pop();
    //                                   },
    //                                 ),
    //                               ],
    //                             );
    //                           } else {
    //                             final bool success = snapshot.data ?? false;
    //                             return AlertDialog(
    //                               title: const Text('Bet Status'),
    //                               content: Text(
    //                                 success
    //                                     ? 'Bet created successfully.'
    //                                     : 'Failed to create bet.',
    //                               ),
    //                               actions: <Widget>[
    //                                 TextButton(
    //                                   child: const Text('OK'),
    //                                   onPressed: () {
    //                                     Navigator.of(context).pop();
    //                                   },
    //                                 ),
    //                               ],
    //                             );
    //                           }
    //                         },
    //                       );
    //                     },
    //                   );
    //                 }
    //               },
    //               child: const Text('Place Bet'),
    //             ),
    //             IconButton(
    //               icon: const Icon(Icons.close),
    //               onPressed: widget.onRemove,
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        0,
      ),
      child: SizedBox(
        height: 110,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 100,
                decoration: ShapeDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      width: 4,
                      color: Color(0xFFEFB566),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                  child: Column(
                    children: [
                      Container(
                        decoration: const ShapeDecoration(
                          color: Color.fromARGB(251, 44, 81,
                              202), //TODO: change color BECAUSE IM BLIND AND CANT SEE GREY ON WHITE BACKGROUND
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'lib/assets/images/futbol-regular.svg',
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(
                                width: 10, //separating ball and text
                              ), // Adjust size as needed
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: nunitoText(
                                      widget.gameName,
                                      14,
                                      FontWeight.w700,
                                      const Color(0xFF1E1E1B),
                                    ),
                                  ),
                                  SizedBox(
                                    child: nunitoText(
                                      'Date of the match TBA', // TODO: Replace with actual date
                                      12,
                                      FontWeight.w400,
                                      const Color(0xFF1E1E1B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 7, //separating rows
                      ),
                      Row(
                        children: [
                          Container(
                            width: 120,
                            height: 34,
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Stack(
                              children: [
                                const Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Text(
                                    'Amount',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 12, // Adjust this value as needed
                                  child: SizedBox(
                                    width: 100, // Provide a finite width
                                    height: 20,

                                    child: TextField(
                                      controller: widget.amountController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: 'Nunito',
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ], // Only numbers can be entered
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12, //separating amount and button
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'lib/assets/images/odds_trapeze.svg',
                                height: 30,
                              ), // Adjust size as needed
                              nunitoText(
                                '${widget.odds}',
                                15,
                                FontWeight.w700,
                                const Color(0xFFFFFFFF),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 4, //separating button and type
                          ),
                          nunitoText(
                            widget.betType,
                            15,
                            FontWeight.w700,
                            const Color.fromARGB(255, 38, 32, 32),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 80,
                            height: 34,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(96, 179, 255, 1),
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                {
                                  final int amount =
                                      int.parse(widget.amountController.text);
                                  final Future<bool> betFuture =
                                      widget.createBet(
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
                                              content:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasError) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: const Text(
                                                'Failed to create bet.',
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
                                          } else {
                                            final bool success =
                                                snapshot.data ?? false;
                                            if (success) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                widget.onRemove();
                                              });
                                            }
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
                              child: nunitoText(
                                'Place Bet',
                                14,
                                FontWeight.w700,
                                const Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Handle your button tap here
                widget.onRemove();
              },
              child: Container(
                width: 25,
                height: 60,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFF7272),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'lib/assets/images/trash-solid1.svg',
                    height: 18,
                    width: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
