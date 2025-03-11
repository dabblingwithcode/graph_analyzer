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
    Logger()
        .info('Field processing: ${declaration.toString()}', onlyVerbose: true);
    final fields = declaration.fields;
    final nameLexeme = fields.variables.first.name.lexeme;
    final variable = declaration.fields.variables.first;
    final element = variable.declaredElement;
    String? inferredType;
    if (element != null) {
      inferredType = element.type.getDisplayString(withNullability: true);
      ;
      Logger().info('inferred type of $nameLexeme is  $inferredType',
          onlyVerbose: true);
    }

    type = ReturnTypeConverter(
      fields.type?.toString() ?? variable.initializer?.toString() ?? 'dynamic',
    ).inUml;
    Logger().info('type of $nameLexeme is is $type', onlyVerbose: true);

    isPrivate = nameLexeme.startsWith('_');
    name = nameLexeme;
    // name = nameLexeme.replaceAll(
    //   RegExp(r'_'),
    //   '',
    // );
  }

  @override
  String toString() {
    return '''FieldDef {
      name: $name,
      type: $type,
      isPrivate: $isPrivate,\n}''';
  }
}
