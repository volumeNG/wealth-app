import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/presentation/font_sizes.dart';

import '../../colors.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";

class InputField extends StatefulWidget {
  const InputField(
      {super.key,
      required this.inputTitle,
      required this.hintText,
      this.password = false,
      this.focusNode,
      this.prefixIcon,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.isEmail = false,
      this.onChanged});

  final IconData? prefixIcon;
  final String inputTitle;
  final String hintText;
  final bool password;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool? isEmail;
  final keyboardType;

  // final Function? onChanged;
  final void Function(String)? onChanged;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isFocused = false;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isFocused = widget.focusNode?.hasFocus ?? false;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.inputTitle.isNotEmpty
            ? Text(
                widget.inputTitle,
                style: GoogleFonts.poppins(fontSize: text__md),
              )
            : SizedBox.shrink(),
        SizedBox(height: widget.inputTitle != "" ? 5 : 0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: serenityGreen.withOpacity(0.5),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            cursorColor: Colors.black54,
            obscureText: obscureText && widget.password,
            focusNode: widget.focusNode,
            style: GoogleFonts.poppins(fontSize: text__md),
            decoration: InputDecoration(
              hintStyle: GoogleFonts.poppins(
                color: Color(0xff8F8666),
                fontWeight: FontWeight.w400,
                fontSize: text__md,
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: Colors.black)
                  : null,
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Colors.grey),
                borderRadius: BorderRadius.circular(14),
              ),
              suffixIcon: widget.password
                  ? GestureDetector(
                      onTap: () => {_togglePasswordVisibility()},
                      child: Icon(
                        obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    )
                  : null,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: serenityGreen),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
