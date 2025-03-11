import 'package:analyzer/dart/ast/ast.dart';

import '../utils.dart';
import 'converters/return_type.dart';

/// This class describe method definition
class MethodDef {
  /// Method name
  late final String name;

  /// Type of return value
  late final String returnType;

  /// Is private method?
  late final bool isPrivate;

  /// Is setter?
  late final bool isSetter;

  /// Is getter?
  late final bool isGetter;

  /// Is operator?
  late final bool isOperator;

  MethodDef(final MethodDeclaration declaration) {
    Logger()
        .info('Field processing: ${declaration.toString()}', onlyVerbose: true);
    Logger().info('Parameters: ${declaration.parameters.toString()}',
        onlyVerbose: true);

    returnType = ReturnTypeConverter(
      declaration.returnType?.toString() ?? 'void',
    ).inUml;
    name = declaration.name.lexeme;
    isGetter = declaration.isGetter;
    isSetter = declaration.isSetter;
    isOperator = declaration.isOperator;
    isPrivate = name.startsWith('_');
  }
}
