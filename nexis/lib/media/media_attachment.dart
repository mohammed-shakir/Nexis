import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nexis/media/file_data.dart';
import 'dart:io';

class FileViewer extends FormBuilderFieldDecoration<List<PlatformFile>> {
  final List<PlatformFile> files;
  final void Function() updateState;

  FileViewer({
    super.key,
    super.name = 'images',
    super.decoration,
    required this.files,
    required this.updateState,
  }) : super(builder: (FormFieldState<List<PlatformFile>?> field) {
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
              state.fileViewer(state.widget.files),
            ],
          ),
        );
      },
    );

  @override
  FormBuilderFieldDecorationState<FileViewer, List<PlatformFile>> createState() => FileViewerState();
}

class FileViewerState extends FormBuilderFieldDecorationState<FileViewer, List<PlatformFile>> {
  Widget fileViewer(List<PlatformFile> files) {
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
                return buildFile(files, index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFile(List<PlatformFile> files, int index) {
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
                  child: (getFileType(files[index].name)[0] == 'image')
                    ? kIsWeb
                        ? Image.memory(files[index].bytes!,
                            fit: BoxFit.cover)
                        : Image.file(File(files[index].path!),
                            fit: BoxFit.cover)
                    : Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: getIcon(files[index].name),
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
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
