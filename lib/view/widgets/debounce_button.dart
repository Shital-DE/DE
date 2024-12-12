import 'dart:async';

import 'package:flutter/material.dart';

class DebouncedButton extends StatefulWidget {
  final String _text;
  final VoidCallback _onPressed;
  final Duration _duration;
  final ButtonStyle _style;

  DebouncedButton({
    super.key,
    required String text,
    required VoidCallback onPressed,
    required ButtonStyle style,
    int debounceTimeMs = 1000,
  })  : _text = text,
        _onPressed = onPressed,
        _duration = Duration(milliseconds: debounceTimeMs),
        _style = style;

  @override
  DebouncedButtonState createState() => DebouncedButtonState();
}

class DebouncedButtonState extends State<DebouncedButton> {
  late ValueNotifier<bool> _isEnabled;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _isEnabled = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    super.dispose();
    // _timer!.cancel(); // temporary commented
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isEnabled,
        builder: (context, isEnabled, child) {
          return ElevatedButton(
            style: widget._style,
            onPressed: isEnabled ? _onButtonPressed : null,
            child: Text(widget._text,
                style: const TextStyle(
                    color: Color.fromARGB(255, 243, 242, 242),
                    fontWeight: FontWeight.bold)),
          );
        });
  }

  void _onButtonPressed() {
    _isEnabled.value = false;

    widget._onPressed();
    timer = Timer(widget._duration, () => _isEnabled.value = true);
  }
}
