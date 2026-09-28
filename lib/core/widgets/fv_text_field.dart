import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class FVTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;

  const FVTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.focusNode,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.inputFormatters,
    this.autovalidateMode,
  });

  @override
  State<FVTextField> createState() => _FVTextFieldState();
}

class _FVTextFieldState extends State<FVTextField> {
  late FocusNode _focus;
  bool _isInternalFocus = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focus = widget.focusNode!;
    } else {
      _focus = FocusNode();
      _isInternalFocus = true;
    }
    _focused = _focus.hasFocus;
    _focus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted && _focused != _focus.hasFocus) {
      setState(() => _focused = _focus.hasFocus);
    }
  }

  @override
  void didUpdateWidget(covariant FVTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      if (_isInternalFocus) {
        _focus.removeListener(_handleFocusChange);
        _focus.dispose();
      }
      if (widget.focusNode != null) {
        _focus = widget.focusNode!;
        _isInternalFocus = false;
      } else {
        _focus = FocusNode();
        _isInternalFocus = true;
      }
      _focus.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_handleFocusChange);
    if (_isInternalFocus) {
      _focus.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppTypography.labelMedium.copyWith(
            color: _focused ? AppColors.primary : AppColors.textSecondary,
          ),
          child: Text(widget.label),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .22),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const [],
          ),
          child: TextFormField(
            focusNode: _focus,
            controller: widget.controller,
            obscureText: widget.isPassword,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            autovalidateMode: widget.autovalidateMode,
            onChanged: widget.onChanged,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            style: AppTypography.bodyMedium,
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: widget.errorText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
