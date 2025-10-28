import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputAction textInputAction;
  final bool autoFocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final bool isRequired;
  final String? errorText;
  final FocusNode? focusNode;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.isRequired = false,
    this.errorText,
    this.focusNode,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;

    // Add focus listener if focusNode is provided
    widget.focusNode?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode?.hasFocus ?? false;
    });
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        if (widget.labelText.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              text: widget.labelText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Text Field
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          obscureText: _isObscured,
          textInputAction: widget.textInputAction,
          autofocus: widget.autoFocus,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: () {
            setState(() {
              _isFocused = true;
            });
          },
          onTapOutside: (event) {
            setState(() {
              _isFocused = false;
            });
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            filled: true,
            fillColor: _getFillColor(context),
            border: _getBorder(),
            enabledBorder: _getBorder(),
            focusedBorder: _getFocusedBorder(),
            errorBorder: _getErrorBorder(),
            focusedErrorBorder: _getErrorBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            errorText: widget.errorText,
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    // For password fields, show toggle visibility icon
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      );
    }

    // Return custom suffix icon if provided
    return widget.suffixIcon;
  }

  Color _getFillColor(BuildContext context) {
    if (!widget.enabled) return Colors.grey[100]!;
    return _isFocused
        ? Theme.of(context).primaryColor.withOpacity(0.05)
        : Colors.grey[50]!;
  }

  OutlineInputBorder _getBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey[300]!,
        width: 1.5,
      ),
    );
  }

  OutlineInputBorder _getFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _getErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1.5,
      ),
    );
  }
}