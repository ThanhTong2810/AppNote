import 'package:app_note/utils/utils.dart';
import 'package:flutter/material.dart';

class FadeContainer extends StatefulWidget {
  final Widget child;

  const FadeContainer({Key key, this.child}) : super(key: key);

  @override
  _FadeContainerState createState() => _FadeContainerState();
}

class _FadeContainerState extends State<FadeContainer> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    /// Activate opacity animation
    onWidgetBuildDone(() {
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(seconds: 2),
      child: widget.child,
    );
  }
}
