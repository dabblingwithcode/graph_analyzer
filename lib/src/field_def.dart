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
    final variable = declaration.fields.variables.first;
    final element = variable.declaredElement;
    String? inferredType;
    if (element != null) {
      Logger().info('declaredElement of $nameLexeme is not null',
          onlyVerbose: true);
      inferredType = element.type.runtimeType.toString();
    }
    Logger().info('inferred type of $nameLexeme is is $inferredType',
        onlyVerbose: true);

    type = ReturnTypeConverter(
      fields.type?.toString() ?? inferredType ?? 'dynamic',
    ).inUml;
    Logger().info('type of $nameLexeme is is $type', onlyVerbose: true);
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
