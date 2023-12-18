import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class MyInputField extends StatelessWidget {
  final Color? hintColor;
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final int? maxLength;
  const MyInputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget,
      this.hintColor,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titileStyle,
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: maxLength,
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    controller: controller,
                    style: subTitileStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: hintColor != null
                          ? subTitileStyle.copyWith(color: hintColor)
                          : subTitileStyle.copyWith(color: Colors.black),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: kBackgroundColor, width: 0),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: kBackgroundColor, width: 0),
                      ),
                      counterText: '', // check input check
                    ),
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
