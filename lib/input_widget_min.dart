import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputmin extends StatefulWidget {
  CustomInputmin(
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

class _CustomInputState extends State<CustomInputmin> {
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
                if (int.parse(value) > 60) {
                  widget.controller.text = '60';
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
                  labelText: 'Minute',
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
                if (int.parse(value) > 60) {
                  widget.controller.text = '60';
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
                  labelText: 'Perc',
                  labelStyle: TextStyle(color: Colors.black)),
              controller: widget.controller,
            ),
    );
  }
}
