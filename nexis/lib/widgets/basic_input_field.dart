import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

/// If [multiline] then choose [onSubmittedMultiline] else [onSubmitted]
/// NOTE! [onSubmittedMultiline] and [onSubmitted] have different types

/// Icons will show when appropriate onSubmit functions are given, i.e.
/// [onPressedEmoji], [onPressedGif], [onPressedObscureText]
///
/// if [onPressedObscureText] then include [obscureText] otherwise Icon won't show

class InputField extends StatefulWidget {
  /* Functioning */
  final TextEditingController controller;
  final Function(String text)? controllerListenerFunction;
  final FocusNode? focusNode;
  final void Function()? onSubmittedMultiline;
  final Function(String)? onSubmitted;
  final void Function()? onPressedEmoji;
  final void Function()? onPressedGif;
  final void Function()? onPressedObscureText;
  final Logger logger;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final GlobalKey? buttonKey;
  final void Function()? onTap;

  /* Usability */
  final bool? readOnly;
  final int? maxLength;
  final bool? obscureText;

  final bool? multiline;
  final int? maxLines;

  final TextInputType? keyBoardType;

  /* Styling */
  final String? hint;
  final TextStyle? hintStyle;

  final Color? fillColor;
  final Color? hoverColor;

  final double? cursorHeight;
  final double? cursorWidth;
  final Color? cursorColor;

  /// if [Border], set [includeBorder]
  final bool? includeBorder;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;

  final TextStyle? fontStyle;
  final double? fontSize;

  /// [padding] to [Container]
  final EdgeInsets? padding;

  InputField({
    Key? key,
    required this.controller,
    this.controllerListenerFunction,
    this.focusNode,
    this.onSubmittedMultiline,
    this.onSubmitted,
    this.onPressedEmoji,
    this.onPressedGif,
    this.onPressedObscureText,
    this.autovalidateMode,
    this.validator,
    this.buttonKey,
    this.onTap,
    this.readOnly,
    this.maxLength,
    this.obscureText,
    this.multiline,
    this.maxLines,
    this.keyBoardType,
    this.hint,
    this.hintStyle,
    this.fillColor,
    this.hoverColor,
    this.cursorHeight,
    this.cursorWidth,
    this.cursorColor,
    this.includeBorder,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.fontStyle,
    this.fontSize,
    this.padding,
  })  : logger = Logger(),
        super(key: key);

  @override
  State<InputField> createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  late bool gifIconHover = false;
  late bool emojiIconHover = false;
  late bool obscureTextIconHover = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onChanged);
  }

  void onChanged() {
    if (widget.controllerListenerFunction != null) {
      widget.controllerListenerFunction?.call(widget.controller.text);
    } else {
      defaultListenerFunction();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void defaultListenerFunction() {
    widget.logger.i(widget.controller.text);
  }

  Color setColor(bool hover) {
    if (hover) {
      return Colors.white;
    } else {
      return Colors.grey;
    }
  }

  void multilineKeyEvent(event) {
    if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
      if (!event.isShiftPressed) {
        setState(() {
          widget.onSubmittedMultiline!();
        });
      }
    }
  }

  EdgeInsets getContentPadding() {
    bool gif = (widget.onPressedGif != null? true : false);
    bool emoji = (widget.onPressedEmoji != null? true : false);
    bool obscure = (widget.onPressedObscureText != null? true : false);
    double rightPadding = 0.0 + (gif? 40 : 0) + (emoji? 40 : 0) + (obscure? 40 : 0);
    return EdgeInsets.only(right: rightPadding, left: 10, top: 10, bottom: 10);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (widget.multiline ?? false)? multilineKeyEvent : (event) {},
      child: Container(
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Stack(children: [
          TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onSubmitted,
            style: widget.fontStyle ?? Theme.of(context).textTheme.displayMedium,
            cursorColor: widget.cursorColor ?? Colors.white,
            cursorHeight: widget.cursorHeight ?? 20.0,
            cursorWidth: widget.cursorWidth ?? 1.2,
            readOnly: widget.readOnly ?? false,
            obscureText: widget.obscureText ?? false,
            minLines: 1,
            maxLines: (widget.multiline ?? false)? (widget.maxLines ?? 1) : 1,
            keyboardType: widget.keyBoardType ??
              ((widget.multiline ?? false)? TextInputType.multiline : TextInputType.text),
            //textInputAction: TextInputAction.send,
            decoration: InputDecoration(
              hoverColor: widget.hoverColor ?? Colors.transparent,
              hintText: widget.hint,
              hintStyle: widget.hintStyle ?? Theme.of(context).textTheme.labelSmall,
              border: buildBorder(
                widget.includeBorder,
                widget.borderRadius,
                widget.borderColor,
                context
              ),
              focusedBorder: buildBorder(
                widget.includeBorder,
                widget.borderRadius,
                widget.focusedBorderColor,
                context
              ),
              filled: true,
              fillColor: widget.fillColor ?? Colors.blueGrey[750],
              contentPadding: getContentPadding(),
            ),
            onTap: widget.onTap,
            autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
            validator: widget.validator,
          ),
          Positioned(
              bottom: 9,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.onPressedGif != null
                    ? MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            gifIconHover = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            gifIconHover = false;
                          });
                        },
                        child: IconButton(
                          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                          constraints: const BoxConstraints(maxWidth: 40.0),
                          iconSize: 30.0,
                          onPressed: widget.onPressedGif,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.gif_box_rounded,
                            color: setColor(gifIconHover),
                          ),
                        ),
                      )
                    : const SizedBox(),
                  widget.onPressedEmoji != null
                    ? MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            emojiIconHover = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            emojiIconHover = false;
                          });
                        },
                        child: IconButton(
                          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                          constraints: const BoxConstraints(maxWidth: 40.0),
                          iconSize: 30.0,
                          onPressed: widget.onPressedEmoji,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.emoji_emotions,
                            color: setColor(emojiIconHover),
                          ),
                        ),
                      )
                    : const SizedBox(),
                  widget.onPressedObscureText != null && widget.obscureText != null
                    ? MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            obscureTextIconHover = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            obscureTextIconHover = false;
                          });
                        },
                        child: IconButton(
                          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                          constraints: const BoxConstraints(maxWidth: 40.0),
                          iconSize: 30.0,
                          onPressed: widget.onPressedObscureText,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            widget.obscureText!
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: setColor(obscureTextIconHover),
                          ),
                        ),
                      )
                    : const SizedBox(),
                ],
              ),
          )
        ]),
      ),
    );
  }

  OutlineInputBorder buildBorder([include, size, color, context]) {
    include ??= false;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(size ?? 8),
      borderSide: include
          ? BorderSide(
              color: color ?? Theme.of(context).colorScheme.outline,
            )
          : BorderSide.none,
    );
  }
}