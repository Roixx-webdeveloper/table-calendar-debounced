// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Function headerButtonTap;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(8.0),
    required this.headerButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    Future<void> onTapped() async {
      onTap;
      return Future.delayed(Duration(microseconds: 1));
    }

    return Padding(
        padding: margin,
        child: !kIsWeb &&
                (platform == TargetPlatform.iOS ||
                    platform == TargetPlatform.macOS)
            ? CupertinoButton(
                onPressed: () async => await onTapped(),
                padding: padding,
                child: icon,
              )
            : InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(100.0),
                child: Padding(
                  padding: padding,
                  child: icon,
                ),
              ));
  }
}
