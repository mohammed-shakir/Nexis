import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

typedef FileViewerBuilder = Widget Function(
  List<PlatformFile>? files,
  FormFieldSetter<List<PlatformFile>> filesSetter,
);

class TypeSelector {
  final FileType type;
  final Widget selector;

  const TypeSelector({required this.type, required this.selector});
}

class FileViewer extends FormBuilderFieldDecoration<List<PlatformFile>> {
  /// If set to true, a thumbnail of image files will be shown; else the default
  /// icon will be displayed depending on file type
  final bool previewImages;

  /// Allowed file extensions for files to be selected
  final List<String>? allowedExtensions;

  /// If you want to track picking status, for example, because some files may take some time to be
  /// cached (particularly those picked from cloud providers), you may want to set [onFileLoading] handler
  /// that will give you the current status of picking.
  final void Function(FilePickerStatus)? onFileLoading;

  /// If [withData] is set, picked files will have its byte data immediately available on memory as [Uint8List]
  /// which can be useful if you are picking it for server upload or similar.
  final bool withData;

  /// If [withReadStream] is set, picked files will have its byte data available as a [Stream<List<int>>]
  /// which can be useful for uploading and processing large files.
  final bool withReadStream;

  late List<PlatformFile> files;
  final void Function() updateState;

  FileViewer({
    super.key,
    required super.name,
    super.validator,
    super.decoration,
    super.onChanged,
    super.valueTransformer,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.focusNode,
    this.withData = kIsWeb,
    this.withReadStream = false,
    this.previewImages = true,
    this.allowedExtensions,
    this.onFileLoading,
    required this.files,
    required this.updateState,
  }) : super(
          builder: (FormFieldState<List<PlatformFile>?> field) {
            final state = field as FileViewerState;

            return InputDecorator(
              decoration: state.decoration.copyWith(
                counterText: null,
                border: const UnderlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)
                  ),
                ),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 3),
                  state.fileViewer(state.widget.files,
                      (files) => state._setFiles(files ?? [], field)),
                ],
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<FileViewer, List<PlatformFile>>
      createState() => FileViewerState();
}

class FileViewerState extends FormBuilderFieldDecorationState<
    FileViewer, List<PlatformFile>> {
  static const imageFileExts = [
    'gif',
    'jpg',
    'jpeg',
    'png',
    'webp',
    'bmp',
    'dib',
    'wbmp',
  ];

  //List<PlatformFile> _files = [];

  @override
  void initState() {
    super.initState();
    //_files = widget.files;
  }

  void _setFiles(
      List<PlatformFile> files, FormFieldState<List<PlatformFile>?> field) {
    setState(() => widget.files = files);
    field.didChange(widget.files);
  }

  Widget fileViewer(List<PlatformFile> files, FormFieldSetter<List<PlatformFile>> setter) {
    final scrollController = ScrollController();
    return SizedBox(
      height: 180,
      child: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: Theme(
          data: Theme.of(context).copyWith(
            scrollbarTheme: ScrollbarThemeData(
              crossAxisMargin: -2.0,
              thumbColor: MaterialStateProperty.all(Theme.of(context).colorScheme.tertiary),
            ),
          ),
          child: Scrollbar(
            controller: scrollController,
            thickness: 5.0,
            child: ListView.separated(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: files.length,
              padding: const EdgeInsets.symmetric(vertical: 5),
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              itemBuilder: (context, index) {
                return buildFile(files, setter, index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFile(List<PlatformFile> files, FormFieldSetter<List<PlatformFile>> setter, int index) {
    return Container(
      height: 180,
      width: 180,
      margin: const EdgeInsets.only(right: 2),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: 160,
            width: 160,
            alignment: Alignment.center,
            child: ListView(
              children: [
                Container(
                  height: 130,
                  width: 130,
                  alignment: Alignment.center,
                  child: (imageFileExts.contains(
                              files[index].extension!.toLowerCase()) &&
                          widget.previewImages)
                      ? widget.withData
                          ? Image.memory(files[index].bytes!,
                              fit: BoxFit.cover)
                          : Image.file(File(files[index].path!),
                              fit: BoxFit.cover)
                      : Container(
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Icon(
                            getIconData(files[index].extension!),
                            color: Colors.white,
                            size: 56,
                          ),
                        ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Text(
                    files[index].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                      fontFamily: 'Arial',
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (enabled)
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  files.removeAt(index);
                  setter.call([...files]);
                  widget.updateState();
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  height: 22,
                  width: 22,
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData getIconData(String fileExtension) {
    final lowerCaseFileExt = fileExtension.toLowerCase();
    if (imageFileExts.contains(lowerCaseFileExt)) return Icons.image;

    switch (lowerCaseFileExt) {
      case 'doc':
      case 'docx':
        return CommunityMaterialIcons.file_word;
      case 'log':
        return CommunityMaterialIcons.script_text;
      case 'pdf':
        return CommunityMaterialIcons.file_pdf;
      case 'txt':
        return CommunityMaterialIcons.script_text;
      case 'xls':
      case 'xlsx':
        return CommunityMaterialIcons.file_excel;
      default:
        return Icons.insert_drive_file;
    }
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
