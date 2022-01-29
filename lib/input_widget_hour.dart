import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputhour extends StatefulWidget {
  CustomInputhour(
      {Key? key,
      required this.controller,
      required this.textsfw,
      required this.textmfw,
      required this.fsize,
      required this.eng})
      : super(key: key);
  bool eng;
  double textsfw;
  double textmfw;
  double fsize;
  TextEditingController controller;

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInputhour> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      width: widget.textmfw,
      child: widget.eng
          ? TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: true)
              ],
              style: TextStyle(fontSize: widget.fsize),
              onChanged: (value) {
                if (int.parse(value) > 24) {
                  widget.controller.text = '24';
                }
                if (int.parse(value) < 0) {
                  widget.controller.text = '0';
                }
              },
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Hour',
                  labelStyle: TextStyle(color: Colors.black)),
              controller: widget.controller,
            )
          : TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: true)
              ],
              style: TextStyle(fontSize: widget.fsize),
              onChanged: (value) {
                if (int.parse(value) > 24) {
                  widget.controller.text = '24';
                }
                if (int.parse(value) < 0) {
                  widget.controller.text = '0';
                }
              },
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Óra',
                  labelStyle: TextStyle(color: Colors.black)),
              controller: widget.controller,
            ),
    );
  }
}
