import 'package:app/components/events_screen/bet_preview.dart';
import 'package:app/components/events_screen/button_with_bets.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/providers/button_states_provider.dart';
import 'package:flutter/material.dart';

class DuelsMatches extends StatefulWidget {
  final List<BetPreviewWidget> betPreviewWidgets;

  final ButtonStatesProvider buttonStatesProvider;
  final String duelID;

  const DuelsMatches({
    super.key,
    required this.betPreviewWidgets,
    required this.buttonStatesProvider,
    required this.duelID,
  });

  @override
  State<DuelsMatches> createState() => _DuelsMatchesState();
}

class _DuelsMatchesState extends State<DuelsMatches> {
  void resetChoice(BuildContext context, String matchRef) {
    setState(() {
      widget.betPreviewWidgets
          .removeWhere((element) => element.matchRef == matchRef);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usableWidth = MediaQuery.of(context).size.width * 0.9;
    //final usableHeight = MediaQuery.of(context).size.height * 0.9;
    // TODO: implement build
    debugPrint('DuelsMatches: ${widget.betPreviewWidgets.length}');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: nunitoText(
          'Duel ${widget.duelID}',
          24,
          FontWeight.bold,
          Colors.black,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: usableWidth,
            //height: usableHeight,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.betPreviewWidgets,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ButtonWithBets(
        onRemoveMatch: (String matchRef) => resetChoice(context, matchRef),
      ),
    );
  }
}
