import 'package:flutter/material.dart';

class AnimatedChild extends AnimatedWidget {
  final int? index;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double buttonSize;
  final Widget? child;
  final List<BoxShadow>? labelShadow;
  final Key? btnKey;

  final String? label;
  final TextStyle? labelStyle;
  final Color? labelBackgroundColor;
  final Widget? labelWidget;

  final bool visible;
  final bool? dark;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? toggleChildren;
  final ShapeBorder? shape;
  final String? heroTag;
  final bool useColumn;
  final bool switchLabelPosition;

  final EdgeInsets childMargin;

  AnimatedChild({
    this.btnKey,
    required Animation<double> animation,
    this.index,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.buttonSize = 56.0,
    this.child,
    this.labelShadow,
    this.label,
    this.labelStyle,
    this.labelBackgroundColor,
    this.labelWidget,
    this.visible = false,
    this.dark,
    this.onTap,
    required this.switchLabelPosition,
    required this.useColumn,
    this.onLongPress,
    this.toggleChildren,
    this.shape,
    this.heroTag,
    required this.childMargin,
  }) : super(listenable: animation);

  Widget buildLabel() {
    if (label == null && labelWidget == null) return Container();

    if (labelWidget != null) {
      return GestureDetector(
        onTap: _performAction,
        onLongPress: _performLongAction,
        child: labelWidget,
      );
    }

    return GestureDetector(
      onTap: _performAction,
      onLongPress: _performLongAction,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        margin: childMargin,
        decoration: BoxDecoration(
          color: labelBackgroundColor ??
              (dark! ? Colors.grey[800] : Colors.grey[50]),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          boxShadow: labelShadow ??
              [
                BoxShadow(
                  color: dark!
                      ? Colors.grey[900]!.withOpacity(0.7)
                      : Colors.grey.withOpacity(0.7),
                  offset: Offset(0.8, 0.8),
                  blurRadius: 2.4,
                )
              ],
        ),
        child: Text(label!, style: labelStyle),
      ),
    );
  }

  void _performAction() {
    if (onTap != null) onTap!();
    toggleChildren!();
  }

  void _performLongAction() {
    if (onLongPress != null) onLongPress!();
    toggleChildren!();
  }

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;

    Widget button = ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          key: btnKey,
          heroTag: heroTag,
          onPressed: _performAction,
          backgroundColor:
              backgroundColor ?? (dark! ? Colors.grey[800] : Colors.grey[50]),
          foregroundColor:
              foregroundColor ?? (dark! ? Colors.white : Colors.black),
          elevation: elevation ?? 6.0,
          child: child,
          shape: shape,
        ));

    List<Widget> children = [
      if (label != null || labelWidget != null)
        ScaleTransition(
          scale: animation,
          child: Container(
            padding: (child == null) ? EdgeInsets.symmetric(vertical: 8) : null,
            child: buildLabel(),
          ),
        ),
      if (child != null)
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          height: buttonSize,
          width: buttonSize,
          child: (onLongPress == null)
              ? button
              : FittedBox(
                  child: GestureDetector(
                    onLongPress: _performLongAction,
                    child: button,
                  ),
                ),
        )
    ];

    Widget _buildColumnOrRow(bool isColumn,
        {CrossAxisAlignment? crossAxisAlignment,
        MainAxisAlignment? mainAxisAlignment,
        required List<Widget> children,
        MainAxisSize? mainAxisSize}) {
      return isColumn
          ? Column(
              mainAxisSize: mainAxisSize ?? MainAxisSize.max,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              children: children,
            )
          : Row(
              mainAxisSize: mainAxisSize ?? MainAxisSize.max,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              children: children,
            );
    }

    return _buildColumnOrRow(
      useColumn,
      mainAxisSize: MainAxisSize.min,
      children: switchLabelPosition ? children.reversed.toList() : children,
    );
  }
}
