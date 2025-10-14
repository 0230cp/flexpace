import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // return const Center(child: CircularProgressIndicator());
    return const SizedBox(
      // color: Colors.black26,
      width: 200,
      height: 300,
      child: Center(
          child: CircularProgressIndicator(
        color: Color(0xff1770C2),
      )),
    );
  }
}
