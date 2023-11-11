import 'package:flutter/material.dart';

class SelectableTextWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function onTap;
  final GlobalKey keyGlobal;

  SelectableTextWidget({
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.keyGlobal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function(),
      child: Container(
        key: keyGlobal,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: isSelected ? 2 : 0,
              color: isSelected ? Colors.green : Colors.transparent,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: isSelected ? Colors.green : Colors.black,
          ),
        ),
      ),
    );
  }
}
