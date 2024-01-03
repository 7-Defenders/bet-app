import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:math' as math;

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
    final double containerWidth = MediaQuery.of(context).size.width * 0.9;
    const double padding = 8.0;
    const SizedBox paddingBox = SizedBox(height: padding, width: padding);
    final double oneWidth = (containerWidth - 2* padding) / 5;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        width: containerWidth,
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
                          (containerWidth - 4 * padding) / widget.bets.length,
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
                const SizedBox(height: 4),
                Row(children: [
                  Button1(onTap: (){print('1');}, width: oneWidth, height: 50),
                  Button1X(onTap: (){print('1X');}, width: oneWidth, height: 50),
                  ButtonX(onTap: (){print('X');}, width: oneWidth, height: 50),
                  ButtonX2(onTap: (){print('X2');}, width: oneWidth, height: 50),
                  Button2(onTap: (){print('2');}, width: oneWidth, height: 50),
                ],),
                ],),
              ],
            ),
        ),
      );
  }
}

class Button1 extends StatelessWidget {
  double width;
  double height;

  Button1({super.key, required this.onTap, required this.width, required this.height});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: Shape1(),
          child: Center(
            child: Transform.translate(
              offset: const Offset(15, 0),
              child: const Icon(
                Icons.send,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Button1X extends StatelessWidget {
  double width;
  double height;

  Button1X({super.key, required this.onTap, required this.width, required this.height});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: Shape1X(),
          child: Center(
            child: Transform.translate(
              offset: const Offset(15, 0),
              child: const Icon(
                Icons.send,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonX extends StatelessWidget {
  double width;
  double height;

  ButtonX({super.key, required this.onTap, required this.width, required this.height});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: ShapeX(),
          child: Center(
            child: Transform.translate(
              offset: const Offset(15, 0),
              child: const Icon(
                Icons.send,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonX2 extends StatelessWidget {
  double width;
  double height;

  ButtonX2({super.key, required this.onTap, required this.width, required this.height});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: ShapeX2(),
          child: Center(
            child: Transform.translate(
              offset: const Offset(15, 0),
              child: const Icon(
                Icons.send,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Button2 extends StatelessWidget {
  double width;
  double height;

  Button2({super.key, required this.onTap, required this.width, required this.height});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: Shape2(),
          child: Center(
            child: Transform.translate(
              offset: const Offset(15, 0),
              child: const Icon(
                Icons.send,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Shape1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.pink.shade400;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 1;
    
    const angle = math.pi / 8;
    final fillWidth = size.height * math.tan(angle);

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - fillWidth, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Shape1X extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.pink.shade400;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 1;
    
    const angle = math.pi / 8;
    final fillWidth = size.height * math.tan(angle);

    final path = Path();
    path.moveTo(fillWidth, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - fillWidth, size.height);
    path.lineTo(0, size.height);
    path.lineTo(fillWidth, 0);
    
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ShapeX extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.pink.shade400;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 1;
    
    const angle = math.pi / 8;
    final fillWidth = size.height * math.tan(angle);

    final path = Path();
    path.moveTo(fillWidth, 0);
    path.lineTo(size.width - fillWidth, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(fillWidth, 0);
    
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ShapeX2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.pink.shade400;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 1;
    
    const angle = math.pi / 8;
    final fillWidth = size.height * math.tan(angle);

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - fillWidth, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(fillWidth, size.height);
    path.lineTo(0, 0);
    
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Shape2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.pink.shade400;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 1;
    
    const angle = math.pi / 8;
    final fillWidth = size.height * math.tan(angle);

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(fillWidth, size.height);
    path.lineTo(0, 0);
    
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}