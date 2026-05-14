import 'package:flutter/material.dart';

class EmptySaleWidget
    extends StatelessWidget {

  const EmptySaleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text(
        "No Products Added",
      ),
    );
  }
}