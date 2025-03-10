part of 'converter.dart';

final class PlantUmlConverter implements Converter {
  PlantUmlConverter();

  @override
  String convertToText(final List<ClassDef> defs) {
    final stringBuffer = StringBuffer('@startuml\n\n');

// apply dark theme
    stringBuffer.write('skinparam backgroundColor #000000\n\n');
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
      result.write(
        '${method.isPrivate ? privateAccessModifier : publicAccessModifier}'
        '${method.isGetter || method.isSetter ? '«' : ''}'
        '${method.isGetter ? 'get' : ''}'
        '${method.isGetter && method.isSetter ? '/' : ''}'
        '${method.isSetter ? 'set' : ''}'
        '${method.isGetter || method.isSetter ? '»' : ''}'
        '${method.name}(): '
        '${method.returnType}\n',
      );
    }

    return result.toString();
  }

  @override
  String convertFields(final ClassDef def) {
    final result = StringBuffer();
    for (final field in def.fields) {
      result.write(
        '${field.isPrivate ? privateAccessModifier : publicAccessModifier}'
        '${field.name}:'
        ' ${field.type}\n',
      );
    }
    return result.toString();
  }

  @override
  String convertStartClass(final ClassDef def) {
    if (def.extendsOf != null) {
      return 'class ${def.name} extends <font color=yellow>${def.extendsOf}</font> {\n';
    }
    if (def.implementsOf.isNotEmpty) {
      return 'class ${def.name} implements <font color=yellow>${def.implementsOf.toList().toString()}</font> {\n';
    }
    return 'interface ${def.name} {\n';
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
