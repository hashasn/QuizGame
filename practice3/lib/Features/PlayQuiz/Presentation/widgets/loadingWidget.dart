import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String s;
  const LoadingWidget({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(s),
          )
        ],
      ),
    ));
  }
}
