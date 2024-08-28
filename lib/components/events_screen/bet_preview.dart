import 'package:app/components/other/nunito_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BetPreviewWidget extends StatefulWidget {
  final String eventName;
  final String eventDetails;
  final Map<String, double> bets;
  final ValueChanged<String>? onOptionSelected;
  final String? initialSelection;
  final String? matchRef;
  final String sportIconPath;

  const BetPreviewWidget({
    super.key,
    required this.eventName,
    required this.eventDetails,
    required this.bets,
    required this.onOptionSelected,
    this.initialSelection,
    this.matchRef,
    this.sportIconPath = 'lib/assets/images/futbol-regular.svg',
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
    //debugPrint(widget.initialSelection);
  }

  void onItemTapped(String? option) {
    setState(() {
      _selectedOption = option == _selectedOption ? null : option;
      widget.onOptionSelected!(option!);
    });
  }

  Widget buildBetItem(
    String? option,
    Function(String?) onItemTapped,
    BuildContext context, {
    Color color = Colors.transparent,
  }) {
    final double panelHeight = MediaQuery.of(context).size.height;
    final double panelWidth = MediaQuery.of(context).size.width;
    const Color textColor = Colors.white;

    final width = panelWidth * 0.2 * 0.9;
    final translationMultiplier = width * 0.1;

    double translation;
    switch (option) {
      case '1':
        translation = 0;
      case '1X':
        translation = -translationMultiplier;
      case 'X':
        translation = 0;
      case 'X2':
        translation = translationMultiplier;
      case '2':
        translation = 0;
      default:
        throw Exception('Invalid option');
    }

    return GestureDetector(
      onTap: () => onItemTapped(option),
      child: Container(
        width: width,
        height: panelHeight * 0.08,
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              nunitoText(option ?? 'null', 14, FontWeight.bold, textColor),
              Transform.translate(
                offset: Offset(translation, 0),
                child: nunitoText(
                  widget.bets[option].toString(),
                  14,
                  FontWeight.bold,
                  textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container krzeminBetWidget(
    // add blue border

    BuildContext context,
    Function(String?) onItemTapped, {
    String? option,
  }) {
    final double panelHeight = MediaQuery.of(context).size.height;
    final double panelWidth = MediaQuery.of(context).size.width;
    String betWidgetPath;
    switch (option) {
      case null:
        betWidgetPath = 'lib/assets/images/bet_widget/nobet.svg';
      case '1':
        betWidgetPath = 'lib/assets/images/bet_widget/bet1.svg';
      case '1X':
        betWidgetPath = 'lib/assets/images/bet_widget/bet1X.svg';
      case 'X':
        betWidgetPath = 'lib/assets/images/bet_widget/betX.svg';
      case 'X2':
        betWidgetPath = 'lib/assets/images/bet_widget/betX2.svg';
      case '2':
        betWidgetPath = 'lib/assets/images/bet_widget/bet2.svg';
      default:
        throw Exception('Invalid option');
    }

    final sportIcon = SvgPicture.asset(
      widget.sportIconPath,
      fit: BoxFit.cover,
      width: panelWidth * 0.9 * 0.2 * 0.4,
    );

    return Container(
      decoration: const BoxDecoration(
        // adjust this shadow if you dont like it
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(48, 0, 0, 0),
            spreadRadius: 0.1,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
        // border: Border.all(
        //   color: Colors.blue,
        //   width: 2.0,
        // ),
      ),
      width: panelWidth * 0.95,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // on bottom, custom navbar svg image based on the selected index (1-5)
          SvgPicture.asset(
            betWidgetPath,
            clipBehavior: Clip.hardEdge,
            //fit: BoxFit.cover,
            width: panelWidth * 1,
          ),
          // on top, invisible buttons to make the navbar items clickable
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildBetItem('1', onItemTapped, context),
              buildBetItem('1X', onItemTapped, context),
              buildBetItem('X', onItemTapped, context),
              buildBetItem('X2', onItemTapped, context),
              buildBetItem('2', onItemTapped, context),
            ],
          ),
          Positioned(
            top: panelHeight * 0.020,
            left: panelHeight * 0.04,
            child: sportIcon,
          ),
          Positioned(
            top: panelHeight * 0.013,
            left: panelHeight * 0.9 * 0.12,
            child: SizedBox(
              width: panelWidth * 0.9 * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: nunitoText(
                      widget.eventName,
                      14,
                      FontWeight.bold,
                      Colors.black,
                      maxLines: 1,
                    ),
                  ),
                  nunitoText(
                    widget.eventDetails,
                    12,
                    FontWeight.normal,
                    Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final buttonStatesProvider = Provider.of<ButtonStatesProvider>(context);
    // final double containerWidth = panelWidth * 0.9;
    // const double padding = 8.0;

    return krzeminBetWidget(
      context,
      (p0) => onItemTapped(p0),
      option: _selectedOption,
    );
  }
}
