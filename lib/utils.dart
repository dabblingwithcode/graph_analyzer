class Logger {
  const Logger._();

  factory Logger() => const Logger._();

  static bool _verboseMode = false;

  void activateVerbose() => _verboseMode = true;

  void error(final String text, {final bool onlyVerbose = true}) {
    if (_verboseMode || !onlyVerbose) {
      print(wrapRed(text));
    }
  }

  void info(final String text, {final bool onlyVerbose = true}) {
    if (_verboseMode || !onlyVerbose) {
      print(wrapBlue(text));
    }
  }

  void success(final String text, {final bool onlyVerbose = true}) {
    if (_verboseMode || !onlyVerbose) {
      print(wrapGreen(text));
    }
  }

  void regular(final String text, {final bool onlyVerbose = true}) {
    if (_verboseMode || !onlyVerbose) {
      print(text);
    }
  }
}

String wrapRed(final String text) {
  return '\x1B[31m$text\x1B[0m';
}

String wrapGreen(final String text) {
  return '\x1B[32m$text\x1B[0m';
}

String wrapBlue(final String text) {
  return '\x1B[34m$text\x1B[0m';
}

extension ColorWrap on String {
  String wrapWithColor(final FontColor color) {
    return '<font color=${color.value}>$this</font>';
  }
}

enum FontColor {
  listenableType('#ffd700'),
  functionArgument('#f4665b'),
  function('#6fa8dc'),
  type('#faff00'),
  keyword('#c36dfd');

  final String value;

  const FontColor(this.value);
}
