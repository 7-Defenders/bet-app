import 'package:app/components/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/components/nunito_text.dart';

class TextInputDialog extends StatefulWidget {
  final double vw;
  final double vh;
  final String title;
  final String subtext;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const TextInputDialog({
    super.key,
    required this.vw,
    required this.vh,
    required this.title,
    required this.subtext,
    required this.hintText,
    this.validator,
    this.onSaved,
  });

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final textController = TextEditingController();
  final focusNode = FocusNode();
  static final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          height: 33*widget.vh,
          width: 85*widget.vw,
          decoration: BoxDecoration(
            color: constants.bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                // shadow color, no need to be in constants
                color: Colors.black26,
                blurRadius: 10,
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2*widget.vh),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      widget.title,
                      style: GoogleFonts.nunito(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: constants.tertiaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.fromLTRB(8*widget.vw, 1*widget.vh, 8*widget.vw, 1*widget.vh),
                  child: Text(
                    widget.subtext,
                    style: const TextStyle(
                      fontSize: 13,
                      color: constants.senaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8*widget.vw),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: GoogleFonts.nunito(
                        fontSize: 15,
                        color: constants.dialogWindowTextColor,
                      ),
                      fillColor: constants.secondaryColor,
                    ),
                    controller: textController,
                    focusNode: focusNode,
                    validator: widget.validator,
                    onSaved: widget.onSaved,
                  ),
                ),
                SizedBox(height: 2*widget.vh),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5*widget.vw, 1*widget.vh, 2*widget.vw, 1*widget.vh),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 6*widget.vh,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(240, 196, 30, 58),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: nunitoText('Cancel', 15, FontWeight.bold, const Color.fromARGB(255, 254, 255, 254)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(2*widget.vw, 1*widget.vh, 5*widget.vw, 1*widget.vh),
                        child: GestureDetector(
                          onTap: () => {
                            formKey.currentState!.validate(),
                            if (formKey.currentState!.validate()) {
                              formKey.currentState?.save(),
                              Navigator.pop(context),
                            } else {
                            },
                          },
                          child: Container(
                            height: 6*widget.vh,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 9, 121, 105),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              // don't use constants color, since the button will always be green so text should be white
                              child: nunitoText('Save', 15, FontWeight.bold, const Color.fromARGB(255, 254, 255, 254)),
                            ),
                          ),
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
    );
  }
}
