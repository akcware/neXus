import 'dart:io';

import 'package:flutter/material.dart';

class NxsTap extends StatefulWidget {
  NxsTap({
    super.key,
    required this.child,
    required this.onTap,
    this.useRipple,
    BorderRadius? borderRadius,
  }) : borderRadius = BorderRadius.zero;

  final Widget child;
  final void Function() onTap;
  bool? useRipple;
  final BorderRadius borderRadius;

  @override
  State<NxsTap> createState() => _NxsTapState();
}

class _NxsTapState extends State<NxsTap> {
  double opacity = 1;

  @override
  Widget build(BuildContext context) {
    widget.useRipple ??= !Platform.isIOS;

    return !widget.useRipple!
        ? Listener(
            onPointerDown: (e) {
              opacity = 0.6;
              setState(() {});
            },
            onPointerUp: (e) {
              opacity = 1.0;
              widget.onTap();
              setState(() {});
            },
            onPointerCancel: (e) {
              opacity = 1;
              setState(() {});
            },
            child: Opacity(
              opacity: opacity,
              child: widget.child,
            ),
          )
        : InkWell(
            onTap: widget.onTap,
            customBorder:
                RoundedRectangleBorder(borderRadius: widget.borderRadius),
            child: widget.child,
          );
  }
}
