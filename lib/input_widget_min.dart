import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputmin extends StatefulWidget {
  CustomInputmin(
      {Key? key,
      required this.controller,
      required this.textw,
      required this.fsize,
      required this.eng})
      : super(key: key);
  bool eng;
  double textw;
  double fsize;
  TextEditingController controller;

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInputmin> {
  late double sizereduce;
  FocusNode _focus = FocusNode();
  FocusNode _focus2 = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sizereduce = widget.eng ? 0 : 30;

    _focus.addListener(_onFocusChange);
    _focus2.addListener(_onFocusChange2);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    _focus2.removeListener(_onFocusChange2);
    _focus2.dispose();
  }

  void _onFocusChange() {
    if (!_focus.hasFocus) {
      sizereduce = 0.0;
    }
  }

  void _onFocusChange2() {
    if (!_focus2.hasFocus) {
      sizereduce = 30.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      width: widget.textw - sizereduce,
      child: widget.eng
          ? TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: true)
              ],
              style: TextStyle(fontSize: widget.fsize),
              focusNode: _focus,
              onTap: () => {sizereduce = 20},
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
              focusNode: _focus2,
              onTap: () => {sizereduce = 40.0},
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
