part of 'converter.dart';

final class PlantUmlConverter implements Converter {
  PlantUmlConverter();

  @override
  String convertToText(final List<ClassDef> defs) {
    final stringBuffer = StringBuffer('@startuml\n\n');

// apply dark theme
    stringBuffer.write('skinparam backgroundColor #000000\n\n');
    stringBuffer.write('skinparam {\n');
    stringBuffer.write('    ClassStereotypeFontColor #FFD700\n');
    stringBuffer.write('    ClassStereotypeFontSize 12\n');
    stringBuffer.write('    ClassStereotypeFontStyle bold\n');
    stringBuffer.write('}\n');
    stringBuffer.write('skinparam class {\n');
    stringBuffer.write('    BackgroundColor #333333\n');
    stringBuffer.write('    BorderColor #000000\n');
    stringBuffer.write('    ArrowColor #FFFFFF\n');
    stringBuffer.write('    FontColor #D3D3D3\n');
    stringBuffer.write('}\n');
    stringBuffer.write('skinparam classAttribute {\n');
    stringBuffer.write('    FontColor #D3D3D\n');
    stringBuffer.write('}\n');

    for (final def in defs) {
      stringBuffer.write(def.isAbstract ? 'abstract ' : '');
      stringBuffer.write(convertStartClass(def));
      stringBuffer.write(convertFields(def));
      stringBuffer.write(methodsDivider);
      stringBuffer.write(convertMethods(def));
      stringBuffer.write(convertEndClass(def));
      stringBuffer.write(convertExtends(def));
      stringBuffer.write(convertDependencies(def));
      stringBuffer.write(convertImplements(def));
    }

    stringBuffer.write('@enduml');
    return stringBuffer.toString();
  }

  @override
  String get fileExtension => 'puml';

  @override
  String convertMethods(final ClassDef def) {
    final result = StringBuffer();

    for (final method in def.methods) {
      String returnType = method.returnType;
      if (method.returnType.contains('ValueListenable') ||
          method.returnType.contains('ValueNotifier')) {
        returnType = '${returnType.wrapWithColor(FontColor.listenableType)}';
      } else if (method.returnType == 'Future<void>') {
        returnType =
            '${'Future<'.wrapWithColor(FontColor.type)}${'void'.wrapWithColor(FontColor.keyword)}${'>'.wrapWithColor(FontColor.type)}';
      } else if (method.returnType == 'void') {
        returnType = '${'void'.wrapWithColor(FontColor.keyword)}';
      } else {
        returnType = '${method.returnType.wrapWithColor(FontColor.type)}';
      }

      result.write(
        '${method.isPrivate ? privateAccessModifier : publicAccessModifier}'
        //'${method.isGetter || method.isSetter ? '«' : ''}'
        '${method.isGetter ? '${'get'.wrapWithColor(FontColor.keyword)} ' : ''}'
        // '${method.isGetter && method.isSetter ? '/' : ''}'
        '${method.isSetter ? '${'set'.wrapWithColor(FontColor.keyword)} ' : ''}'
        '${method.isGetter || method.isSetter ? '${method.name.wrapWithColor(FontColor.function)} => ' : '${method.name.wrapWithColor(FontColor.function)}(${method.parameters.replaceAll('(', '').replaceAll(')', '')}${'):'.wrapWithColor(FontColor.function)} '}'
        '$returnType\n',
      );
    }

    return result.toString();
  }

  @override
  String convertFields(final ClassDef def) {
    final result = StringBuffer();
    for (final field in def.fields) {
      String type = field.type;
      if (field.type.contains('ValueListenable') ||
          field.type.contains('ValueNotifier')) {
        type = '${type.wrapWithColor(FontColor.listenableType)}';
      } else {
        type = '${field.type.wrapWithColor(FontColor.type)}';
      }
      result.write(
        '${field.isPrivate ? privateAccessModifier : publicAccessModifier}'
        '${field.name}:'
        ' $type\n',
      );
    }
    return result.toString();
  }

  @override
  String convertStartClass(final ClassDef def) {
    if (def.extendsOf != null) {
      return 'class ${def.name} <<${def.extendsOf}>> {\n';
    }
    if (def.implementsOf.isNotEmpty) {
      return 'class ${def.name} <<${def.implementsOf.toList().toString()}>> {\n';
    }
    return 'class ${def.name} {\n';
  }

  @override
  String convertEndClass(final ClassDef def) => '}\n';

  @override
  String get methodsDivider => '---\n';

  @override
  String convertExtends(final ClassDef classDef) {
    if (classDef.extendsOf != null) {
      return '${classDef.extendsOf} <|-- ${classDef.name}\n';
    }
    return '';
  }

  @override
  String convertDependencies(final ClassDef def) {
    final result = StringBuffer();
    for (final dep in def.deps) {
      result.write('${def.name} ..> $dep\n');
    }
    return result.toString();
  }

  @override
  String convertImplements(final ClassDef def) {
    final result = StringBuffer();
    for (final implementOf in def.implementsOf) {
      result.write('${def.name} ..|> $implementOf\n');
    }
    return result.toString();
  }

  @override
  final privateAccessModifier = '-';
  @override
  final publicAccessModifier = '+';
}
