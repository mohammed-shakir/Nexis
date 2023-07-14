import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../media/media_attachment.dart';
import '../media/media_share.dart';

/// If [multiline] then choose [onSubmittedMultiline] else [onSubmitted]
/// NOTE! [onSubmittedMultiline] and [onSubmitted] have different types

/// Icons will show when appropriate onPressed functions are given, i.e.
/// [onPressedEmoji], [onPressedGif], [onPressedObscureText]
///
/// if [onPressedObscureText] then include [obscureText] otherwise Icon won't show

class InputField extends StatefulWidget {
  /* Functioning */
  final TextEditingController? controller;
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
  final TextInputAction? textInputAction;

  final bool? includeMedia;

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
    this.controller,
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
    this.textInputAction,
    this.includeMedia,
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
  late SharedPreferences prefs;
  late bool gifIconHover = false;
  late bool emojiIconHover = false;
  late bool obscureTextIconHover = false;
  late bool mediaIconHover = false;

  List<PlatformFile> files = [];

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(onChanged);
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void onChanged() {
    if (widget.controllerListenerFunction != null) {
      widget.controllerListenerFunction?.call(widget.controller!.text);
    } else {
      defaultListenerFunction();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void defaultListenerFunction() {
    widget.logger.i(widget.controller?.text);
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
          if (files.isNotEmpty) {
            final List<PlatformFile> sendFiles = [];
            sendFiles.addAll(files);
            MediaShare().uploadFiles(sendFiles, prefs);
            files.clear();
          }
          widget.onSubmittedMultiline!();
        });
      }
    }
  }

  EdgeInsets getContentPadding() {
    bool gif = (widget.onPressedGif != null? true : false);
    bool emoji = (widget.onPressedEmoji != null? true : false);
    bool obscure = (widget.onPressedObscureText != null? true : false);
    bool media = (widget.includeMedia ?? false? true : false);
    double rightPadding = 0.0 + (gif? 40 : 0) + (emoji? 40 : 0) + (obscure? 40 : 0);
    double leftPadding = 5.0 + (media? 40 : 5.0);
    return EdgeInsets.only(right: rightPadding, left: leftPadding, top: 10, bottom: 10);
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
        child: Column(children: [
          if (files.isNotEmpty)
            StatefulBuilder(
              builder: (ctx, set) =>
                FileViewer(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey[750],
                    labelStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                  files: files,
                  updateState: () {
                    setState(() {});
                  },
                ),
            ),
          Stack(children: [
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
              textInputAction: widget.textInputAction,
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
              top: (widget.multiline ?? false)? null : 8.5,
              bottom: (widget.multiline ?? false)? 8.5 : null,
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
            ),
            (widget.includeMedia ?? false)
              ? Positioned(
                  bottom: (widget.multiline ?? false)? 8.5 : null,
                  left: 0,
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        mediaIconHover = true;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        mediaIconHover = false;
                      });
                    },
                    child: IconButton(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                      constraints: const BoxConstraints(maxWidth: 40.0),
                      iconSize: 30.0,
                      onPressed: () async {
                        final file = await MediaShare().selectFile();
                        setState(() {
                          files.addAll(file ?? []);
                          widget.focusNode!.requestFocus();
                        });
                      },
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        Icons.add_box_rounded,
                        color: setColor(mediaIconHover),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          ]),
        ]),
      ),
    );
  }

  OutlineInputBorder buildBorder([include, size, color, context]) {
    include ??= false;
    return OutlineInputBorder(
      borderRadius: files.isEmpty
      ? BorderRadius.circular(size ?? 8)
      : BorderRadius.only(
          bottomLeft: Radius.circular(size ?? 8.0),
          bottomRight: Radius.circular(size ?? 8.0)
        ),
      borderSide: include
          ? BorderSide(
              color: color ?? Theme.of(context).colorScheme.outline,
            )
          : BorderSide.none,
    );
  }
}