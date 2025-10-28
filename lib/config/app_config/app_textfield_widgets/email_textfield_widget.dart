import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:flyaway/config/app_config/app_localization_config/language_service.dart';
import 'package:get/get.dart';

class BlueEmailTextField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final bool autoFocus;
  final String? errorText;
  final Color blueColor;
  final bool showLabel;
  final String hintText;
  final Widget icon;

  const BlueEmailTextField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.autoFocus = false,
    this.errorText,
    this.blueColor = Colors.blue,
    this.showLabel = true,
    required this.hintText,
    required this.icon,
  }) : super(key: key);

  @override
  State<BlueEmailTextField> createState() => _BlueEmailTextFieldState();
}

class _BlueEmailTextFieldState extends State<BlueEmailTextField> {
  bool _isFocused = false;
  late FocusNode _focusNode;
  final LanguageService languageService = Get.put(LanguageService());

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional label
        // if (widget.showLabel) ...[
        //   Text(
        //     'email'.tr,
        //     style: TextStyle(
        //       fontSize: 14,
        //       fontWeight: FontWeight.w600,
        //       color: widget.blueColor,
        //     ),
        //   ),
        //   const SizedBox(height: 8),
        // ],

        // Blue themed email field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: widget.blueColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: widget.textInputAction,
            autofocus: widget.autoFocus,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            validator: _validateEmail,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppFontStyles().FirstFontStyleWidget(
                13.sp,
                Colors.grey,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
                child: widget.icon,
              ),
              filled: true,
              fillColor: _getFillColor(),
              border: _buildBlueBorder(),
              enabledBorder: _buildBlueBorder(),
              focusedBorder: _buildFocusedBlueBorder(),
              errorBorder: _buildErrorBorder(),
              focusedErrorBorder: _buildErrorBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              errorText: widget.errorText,
              errorStyle: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getFillColor() {
    if (!_focusNode.hasFocus) {
      return Colors.grey[50]!;
    }
    return widget.blueColor.withOpacity(0.05);
  }

  OutlineInputBorder _buildBlueBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _isFocused
            ? widget.blueColor
            : widget.blueColor.withOpacity(0.5),
        width: _isFocused ? 2.0 : 1.5,
      ),
    );
  }

  OutlineInputBorder _buildFocusedBlueBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: widget.blueColor, width: 2.5),
    );
  }

  OutlineInputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red, width: _isFocused ? 2.0 : 1.5),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_required'.tr;
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!emailRegex.hasMatch(value)) {
      return 'invalid_email'.tr;
    }

    return null;
  }
}
