import 'package:flutter/material.dart';

class CounterTextAnimationWidget extends ImplicitlyAnimatedWidget {
  final int value;
  final TextStyle textStyle;

  const CounterTextAnimationWidget({
    Key? key,
    required this.value,
    required this.textStyle,
    required Duration duration,
  }) : super(key: key, duration: duration);

  @override
  _CounterTextAnimationWidgetState createState() =>
      _CounterTextAnimationWidgetState();
}

class _CounterTextAnimationWidgetState
    extends AnimatedWidgetBaseState<CounterTextAnimationWidget> {
  IntTween? _counterTween;

  @override
  Widget build(BuildContext context) {
    final value = _counterTween?.evaluate(animation) ?? widget.value;
    return Text(
      "$value تومان",
      style: widget.textStyle,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _counterTween = visitor(
      _counterTween,
      widget.value,
          (dynamic value) => IntTween(begin: value as int),
    ) as IntTween?;
  }
}
