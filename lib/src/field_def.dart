import 'package:analyzer/dart/ast/ast.dart';

import '../utils.dart';

/// This class describe field definition
import 'converters/return_type.dart';

/// This class describe field definition
class FieldDef {
  /// Field name
  late final String name;

  /// Field type
  late final String type;

  /// Is private field?
  late final bool isPrivate;

  FieldDef(final FieldDeclaration declaration) {
    final fields = declaration.fields;
    final nameLexeme = fields.variables.first.name.lexeme;

    Logger().info('inferred tyoe is ${fields.runtimeType.toString()}',
        onlyVerbose: true);

    type = ReturnTypeConverter(
      fields.type?.toString() ?? fields.runtimeType.toString(),
    ).inUml;
    isPrivate = nameLexeme.startsWith('_');
    name = nameLexeme.replaceAll(
      RegExp(r'_'),
      '',
    );
  }

  @override
  String toString() {
    return '''FieledDef {
      name: $name,
      type: $type,
      isPrivate: $isPrivate,\n}''';
  }
}
