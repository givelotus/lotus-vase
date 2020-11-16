import 'package:flutter/material.dart';
import 'pager.dart';

class ControlsLayer extends StatelessWidget {
  final double offset;
  final Function onTap;
  final IconData sendIcon;
  final Function onCameraTap;

  ControlsLayer({this.offset, this.onTap, this.cameraIcon, this.onCameraTap}); 

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new _Controls(sendIcon, onCameraTap)
      ],
    );
  }
}

class _Controls extends StatelessWidget {
  final CameraIcon cameraIcon;
  final Function onCameraTap;

  _Controls(this.cameraIcon, this.onCameraTap);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: 35.0,
      left: 20.0,
      child: new SizedBox(
        width: 20.0,
        height: 40.0,
        child: new GestureDetector(
          onTap: onCameraTap,
          child: cameraIcon,
        ),
      ),
    );
  }
}