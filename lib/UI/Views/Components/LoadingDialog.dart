import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocerylister/UI/Styling/Themes/Themes.dart';

class LoadingDialog extends StatefulWidget {
  final Future _showWhile;

  LoadingDialog({Future showWhile}) : _showWhile = showWhile;
  @override
  _LoadingDialogState createState() => _LoadingDialogState(_showWhile);
}

class _LoadingDialogState extends State<LoadingDialog> {
  Future _showWhile;

  _LoadingDialogState(Future showWhile) : _showWhile = showWhile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
            height: 50,
            width: 50,
            child: FutureBuilder(
                future: _showWhile,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Navigator.pop(context, snapshot.data);
                  }
                  return SpinKitFadingCube(color: neutral);
                })));
  }
}
