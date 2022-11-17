import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomDebouncedIconButton extends StatefulWidget {
  const CustomDebouncedIconButton(
      {Key? key,
      required this.onPressed,
      required this.duration,
      this.margin = const EdgeInsets.all(0.0),
      this.padding = const EdgeInsets.all(8.0),
      required this.icon,
      required this.debouncedAction,
      required this.focusedDay})
      : super(key: key);

  final VoidCallback onPressed;
  final Function debouncedAction;
  final Duration duration;
  final Widget icon;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final DateTime focusedDay;

  @override
  State<CustomDebouncedIconButton> createState() =>
      _CustomDebouncedIconButtonState();
}

class _CustomDebouncedIconButtonState extends State<CustomDebouncedIconButton> {
  late ValueNotifier<bool> isEnabled;

  late Timer _timer;

  @override
  void initState() {
    isEnabled = ValueNotifier<bool>(true);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onButtonPressed() {
    isEnabled.value = false;
    widget.onPressed();

    _timer = Timer(widget.duration, () => isEnabled.value = true);
    widget.debouncedAction(widget.focusedDay);
  }

  void _onButtonPressed2() {
    widget.onPressed();
    print("Focused 2");
    _timer.cancel();
    _timer = Timer(widget.duration, () {
      widget.debouncedAction(widget.focusedDay);
      isEnabled.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    return ValueListenableBuilder(
        valueListenable: isEnabled,
        builder: (context, value, child) {
          return Padding(
              padding: widget.margin,
              child: !kIsWeb &&
                      (platform == TargetPlatform.iOS ||
                          platform == TargetPlatform.macOS)
                  ? CupertinoButton(
                      onPressed: isEnabled.value
                          ? _onButtonPressed
                          : _onButtonPressed2,
                      padding: widget.padding,
                      child: widget.icon,
                    )
                  : InkWell(
                      onTap: isEnabled.value
                          ? _onButtonPressed
                          : _onButtonPressed2,
                      borderRadius: BorderRadius.circular(100.0),
                      child: Padding(
                        padding: widget.padding,
                        child: widget.icon,
                      ),
                    ));
        });
  }
}
