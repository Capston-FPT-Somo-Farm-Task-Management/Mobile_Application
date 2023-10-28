import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget});

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
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    controller: controller,
                    style: subTitileStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitileStyle.copyWith(color: Colors.black),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: kBackgroundColor, width: 0),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: kBackgroundColor, width: 0),
                      ),
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
