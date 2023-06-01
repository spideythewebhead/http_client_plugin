import 'package:http_client_plugin/src/generators/generator.dart';
import 'package:tachyon/tachyon.dart';

class HttpClientFromJsonGenerator implements Generator {
  HttpClientFromJsonGenerator({
    required CodeWriter codeWriter,
    required TachyonDartType dartType,
    required ClassOrEnumDeclarationFinder classDeclarationFinder,
    required Logger? logger,
  })  : _codeWriter = codeWriter,
        _dartType = dartType,
        _classOrEnumDeclarationFinder = classDeclarationFinder,
        _logger = logger;

  final CodeWriter _codeWriter;
  final TachyonDartType _dartType;
  final ClassOrEnumDeclarationFinder _classOrEnumDeclarationFinder;
  final Logger? _logger;

  @override
  Future<void> execute() async {
    await _parse(
      dartType: _dartType,
      depthIndex: 0,
      parentVariableName: 'response.data!',
    );
  }

  void _writeNullableCheck({
    required final String variableName,
    Expression? defaultValue,
  }) {
    final String optionalConst =
        (defaultValue is TypedLiteral || defaultValue is MethodInvocation) ? 'const' : '';
    _codeWriter.write('$variableName == null ? $optionalConst $defaultValue : ');
  }

  Future<void> _parse({
    required final TachyonDartType dartType,
    required final int depthIndex,
    required final String parentVariableName,
    final Expression? defaultValue,
  }) async {
    if (dartType.isList) {
      if (dartType.isNullable || defaultValue != null) {
        _writeNullableCheck(
          variableName: parentVariableName,
          defaultValue: defaultValue,
        );
      }
      await _parseList(
        dartType: dartType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      return;
    }

    if (dartType.isMap) {
      if (dartType.isNullable || defaultValue != null) {
        _writeNullableCheck(
          variableName: parentVariableName,
          defaultValue: defaultValue,
        );
      }
      await _parseMap(
        dartType: dartType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      return;
    }

    if (!dartType.isPrimitive && (dartType.isNullable || defaultValue != null)) {
      _writeNullableCheck(
        variableName: parentVariableName,
        defaultValue: defaultValue,
      );
    }

    await _parsePrimary(
      dartType: dartType,
      parentVariableName: parentVariableName,
    );

    if (dartType.isPrimitive && defaultValue != null) {
      if (dartType.isNullable) {
        _logger?.warning('Declared a nullable type ${dartType.fullTypeName} with default');
      } else {
        _codeWriter.writeln('?');
      }
      _codeWriter.write(' ?? $defaultValue');
    }
  }

  Future<void> _parsePrimary({
    required final TachyonDartType dartType,
    required final String parentVariableName,
  }) async {
    if (dartType.isVoid) {
      _codeWriter.writeln('null');
      return;
    }

    if (dartType.isDynamic) {
      _codeWriter.writeln(parentVariableName);
      return;
    }

    if (dartType.isPrimitive) {
      _codeWriter.write('$parentVariableName as ${dartType.fullTypeName}');
      return;
    }

    final NamedCompilationUnitMember? typeDeclarationNode =
        await _classOrEnumDeclarationFinder(dartType.name)
            .then((ClassOrEnumDeclarationMatch? match) => match?.node);

    if (typeDeclarationNode is ClassDeclaration && typeDeclarationNode.hasFactory('fromJson') ||
        typeDeclarationNode is EnumDeclaration && typeDeclarationNode.hasFactory('fromJson')) {
      _codeWriter.write('${dartType.name}.fromJson($parentVariableName)');
      return;
    }

    _logger?.warning('No "fromJson" factory found for type "${dartType.name}"');

    _codeWriter.write('jsonConverterRegistrant.find(${dartType.name})'
        ".fromJson($parentVariableName, $parentVariableName, '') as ${dartType.name}");
  }

  Future<void> _parseList({
    required final TachyonDartType dartType,
    required final String parentVariableName,
    required final int depthIndex,
  }) async {
    final String fullType = dartType.typeArguments[0].fullTypeName;
    _codeWriter.write('<$fullType>[');

    final String loopVariableName = 'i$depthIndex';
    _codeWriter
        .writeln('for (final dynamic $loopVariableName in ($parentVariableName as List<dynamic>))');

    await _parse(
      dartType: dartType.typeArguments[0],
      parentVariableName: loopVariableName,
      depthIndex: 1 + depthIndex,
    );

    _codeWriter.writeln(']');
  }

  Future<void> _parseMap({
    required final TachyonDartType dartType,
    required final String parentVariableName,
    required final int depthIndex,
  }) async {
    if (!dartType.typeArguments[0].isString) {
      _logger?.error(
          'Key of type "${dartType.typeArguments[0].fullTypeName}" can not be used as a map key in json conversion');
      return;
    }

    final String secondArgumentFullType = dartType.typeArguments[1].fullTypeName;
    _codeWriter.write('<String, $secondArgumentFullType>{');

    final String loopVariableName = 'e$depthIndex';
    _codeWriter
      ..writeln(
          'for (final MapEntry<dynamic, dynamic> $loopVariableName in ($parentVariableName as Map<dynamic, dynamic>).entries)')
      ..write('$loopVariableName.key as String: ');

    await _parse(
      dartType: dartType.typeArguments[1],
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
    );

    _codeWriter.writeln('}');
  }
}
