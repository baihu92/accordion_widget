import 'package:flutter/material.dart';

class AccordionWidget extends StatefulWidget {
  final Text title;
  final Widget child;
  final Color color;
  final double height;
  final bool initiallyExpanded;
  final AccordionWidgetIconLocation iconLocation;

  AccordionWidget({
    @required this.title,
    @required this.child,
    this.initiallyExpanded = false,
    this.color,
    this.height,
    this.iconLocation = AccordionWidgetIconLocation.Right,
  });

  @override
  _AccordionWidgetState createState() => _AccordionWidgetState();
}

class _AccordionWidgetState extends State<AccordionWidget>
    with SingleTickerProviderStateMixin {
  final Duration _duration = Duration(milliseconds: 200);
  final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;

  Widget _trailing;
  bool _isExpanded = false;

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
  }

  @override
  void initState() {
    _controller = AnimationController(duration: _duration, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;

    _trailing = RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more, color: Colors.blue),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : widget.child,
    );
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final children = List<Widget>();

    switch (widget.iconLocation){
      case AccordionWidgetIconLocation.Left:
        children
          ..add(SizedBox(width: 16))
          ..add(_trailing)
          ..add(SizedBox(width: 16))
          ..add(widget.title);
        break;
      case AccordionWidgetIconLocation.Right:
        children
          ..add(SizedBox(width: 16))
          ..add(Expanded(child: widget.title))
          ..add(SizedBox(width: 16))
          ..add(_trailing)
          ..add(SizedBox(width: 16));
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          color: widget.color,
          child: InkWell(
            child: Container(
              height: widget.height ?? 60,
              child: Row(
                children: children,
              ),
            ),
            onTap: _handleTap,
          ),
        ),
        ClipRect(
          child: Align(
            heightFactor: _heightFactor.value,
            child: Container(
              child: child,
              color: widget.color,
            ),
          ),
        ),
      ],
    );
  }
}

enum AccordionWidgetIconLocation { Left, Right }
