import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({
    super.key,
    this.index,
  });
  final int? index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: index != null
          ? Center(
              child: Text(
                index.toString(),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            )
          : null,
    );
  }
}
