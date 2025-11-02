import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:get/get.dart';

class SearchInput extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool autofocus;
  final TextEditingController? controller;
  final double borderRadius;
  final Color focusColor;
  final Color enabledColor;
  final double? height; // Add height control

  const SearchInput({
    super.key,
    this.hintText = 'search_box',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.autofocus = false,
    this.controller,
    this.borderRadius = 16, // Reduced from 28
    this.focusColor = Colors.blue,
    this.enabledColor = Colors.grey,
    this.height, // Optional height
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _searchController = widget.controller ?? TextEditingController();
    _focusNode.addListener(_onFocusChange);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _onClear() {
    setState(() {
      _searchController.clear();
    });
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _searchController.dispose();
    }
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 50.h, // Reasonable default height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        boxShadow: _hasFocus || _searchController.text.isNotEmpty
            ? [
                BoxShadow(
                  color: widget.focusColor.withOpacity(0.15),
                  blurRadius: 8.r, // Reduced blur
                  offset: Offset(0, 2.h), // Reduced offset
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4.r, // Reduced blur
                  offset: Offset(0, 1.h), // Reduced offset
                ),
              ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onTap: widget.onTap,
        style: AppFontStyles().FirstFontStyleWidget(14.sp, Colors.black87),
        decoration: InputDecoration(
          hintText: widget.hintText.tr,
          hintStyle: AppFontStyles().FirstFontStyleWidget(
            13.sp, // Reduced font size
            Colors.grey.shade500,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.only(left: 12.w, right: 8.w), // Reduced margins
            child: Icon(
              Icons.search_rounded,
              color: _hasFocus ? widget.focusColor : Colors.grey.shade600,
              size: 20.w, // Reduced icon size
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? Positioned(
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.sp),
                    child: CircleAvatar(
                      radius: 5.r, // Reduced radius
                      backgroundColor: Colors.grey.shade300,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Colors.grey.shade700,
                          size: 14.w, // Reduced icon size
                        ),
                        onPressed: _onClear,
                      ),
                    ),
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            borderSide: BorderSide(
              color: widget.enabledColor.withOpacity(0.5),
              width: 1.0, // Reduced border width
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            borderSide: BorderSide(
              color: widget.focusColor,
              width: 1.5, // Reduced border width
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h, // Reduced vertical padding
            horizontal: 16.w, // Reduced horizontal padding
          ),
          isDense: true, // This reduces the internal padding
        ),
        onChanged: (value) {
          setState(() {});
          widget.onChanged?.call(value);
        },
        onSubmitted: widget.onSubmitted,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
