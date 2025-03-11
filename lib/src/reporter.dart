import 'dart:io';

import 'package:path/path.dart' as path;

import '../utils.dart';
import 'class_def.dart';
import 'converters/converter.dart';

///
abstract class Reporter {
  factory Reporter.file(
    final String reportDirPath,
    final Converter converter,
  ) =>
      _FileReporter(reportDirPath, converter);

  Future<void> report(final List<ClassDef> text);
}

class _FileReporter implements Reporter {
  final Converter converter;

  _FileReporter(this.reportDirPath, this.converter);

  final String reportDirPath;

  @override
  Future<void> report(final List<ClassDef> defs) async {
    final fileExtension = converter.fileExtension;
    final lastFolder = path.basename(reportDirPath);
    final outputTxtFilePath =
        path.join(reportDirPath, '$lastFolder.$fileExtension');
    var file = File(outputTxtFilePath);

    Logger().info('Creating output file...', onlyVerbose: true);
    file = await file.create(recursive: true);

    final ioSink = file.openWrite();
    final text = converter.convertToText(defs);

    Logger().info('Writing output file...', onlyVerbose: true);

    ioSink.write(text);
    await ioSink.close();

    Logger().success(
      'Created output file: $outputTxtFilePath',
      onlyVerbose: false,
    );
  }
}
