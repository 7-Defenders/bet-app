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
    this.sportIconPath='lib/assets/images/futbol-regular.svg',
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

void onItemTapped(String? option) {
  setState(() {
    if (option == _selectedOption) {
      _selectedOption = null;
    } else {
      _selectedOption = option;
      widget.onOptionSelected!(option!);
    }
  });
}
  
Widget buildBetItem(String? option, Function(String?) onItemTapped, BuildContext context, {Color color = Colors.transparent,}) {
  final Color textColor = option==_selectedOption ? const Color.fromARGB(255, 251, 165, 28) : Colors.white;
  
  final width =  MediaQuery.of(context).size.width * 0.2 * 0.9;
  final translationMultiplier = width * 0.1;

  double translation;
  switch (option){
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
      height: MediaQuery.of(context).size.height * 0.08,
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            nunitoText(option ?? 'null', 14, FontWeight.bold, textColor),
            Transform.translate(offset: Offset(translation, 0), child: nunitoText(widget.bets[option].toString(), 14, FontWeight.bold, textColor)),
          ],),
      ),
    ),
  );
}

Stack krzeminBetWidget(
  BuildContext context,
  Function(String?) onItemTapped,
  {String? option,}
) {

  String betWidgetPath;
  switch (option){
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
    width: MediaQuery.of(context).size.width * 0.9 * 0.2 * 0.4,
  );

  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      // on bottom, custom navbar svg image based on the selected index (1-5)
      SvgPicture.asset(
        betWidgetPath,        
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width * 0.9,
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
      Positioned(top: MediaQuery.of(context).size.height * 0.015, left: MediaQuery.of(context).size.height * 0.05, child: sportIcon),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.013,
        left: MediaQuery.of(context).size.height * 0.9 * 0.12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            nunitoText(widget.eventName, 14, FontWeight.bold, Colors.black),
            nunitoText(widget.eventDetails, 12, FontWeight.normal, Colors.black),
          ],
        ),
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    //final buttonStatesProvider = Provider.of<ButtonStatesProvider>(context);
    final double containerWidth = MediaQuery.of(context).size.width * 0.9;
    const double padding = 8.0;
    
    return krzeminBetWidget(context, (p0) => onItemTapped(p0), option: _selectedOption);
  }
}
