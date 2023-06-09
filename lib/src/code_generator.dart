import 'dart:async';

import 'package:http_client_plugin/src/annotations/http.dart';
import 'package:http_client_plugin/src/generators/from_json.dart';
import 'package:tachyon/tachyon.dart';

final RegExp _httpRouteMatcher = RegExp(r'HttpMethod.(get|post|delete|put)');

class HttpClientCodeGenerator extends TachyonPluginCodeGenerator {
  @override
  Future<String> generate(
    FileChangeBuildInfo buildInfo,
    TachyonDeclarationFinder declarationFinder,
    Logger logger,
  ) async {
    final CodeWriter codeWriter = CodeWriter.stringBuffer();
    final List<ClassDeclaration> classDeclarations = buildInfo.compilationUnit.declarations
        .where((CompilationUnitMember declaration) {
          return declaration is ClassDeclaration &&
              declaration.metadata.hasAnnotationWithName(HttpService.name);
        })
        .cast<ClassDeclaration>()
        .toList(growable: false);

    for (final ClassDeclaration classDeclaration in classDeclarations) {
      final String className = classDeclaration.name.lexeme;
      final AnnotationValueExtractor httpClientValueExtractor = AnnotationValueExtractor(
          classDeclaration.metadata.getAnnotationWithName(HttpService.name));

      String httpClientAnnotationPathPrefix = httpClientValueExtractor.getPositionedString(0) ?? '';
      if (httpClientAnnotationPathPrefix.startsWith('/')) {
        httpClientAnnotationPathPrefix = httpClientAnnotationPathPrefix.substring(1);
      }
      if (httpClientAnnotationPathPrefix.endsWith('/')) {
        httpClientAnnotationPathPrefix =
            httpClientAnnotationPathPrefix.substring(0, httpClientAnnotationPathPrefix.length - 1);
      }

      codeWriter
        ..writeln('class _\$${className}Impl extends $className {')
        ..writeln()
        ..writeln("_\$${className}Impl(this._client, [String pathPrefix = '',]): super._() {")
        ..writeln("if (pathPrefix.endsWith('/')) {")
        ..writeln('pathPrefix = pathPrefix.substring(0, pathPrefix.length - 1);')
        ..writeln('}')
        ..writeln(
            '_pathPrefix = ${httpClientAnnotationPathPrefix.isEmpty ? 'pathPrefix' : "'\${pathPrefix}/$httpClientAnnotationPathPrefix'"};')
        ..writeln('}')
        ..writeln()
        ..writeln('late Dio _client;')
        ..writeln('late final String _pathPrefix;')
        ..writeln();

      codeWriter
        ..writeln('@override')
        ..writeln('$className overrideHttpClient(Dio client) {')
        ..writeln('_client = client;')
        ..writeln('return this;')
        ..writeln('}');

      final List<MethodDeclaration> innerHttpClients = <MethodDeclaration>[];

      for (final ClassMember method in classDeclaration.members) {
        if (method is! MethodDeclaration || !method.isGetter) {
          continue;
        }
        final TachyonDartType customDartType = method.returnType.customDartType;
        if (customDartType.name == 'FutureHttpResponse') {
          continue;
        }
        final NamedCompilationUnitMember? returnTypeClassDeclaration = await declarationFinder
            .findClassOrEnum(customDartType.name)
            .then((ClassOrEnumDeclarationMatch? match) => match?.node);
        if (returnTypeClassDeclaration is! ClassDeclaration ||
            !returnTypeClassDeclaration.metadata.hasAnnotationWithName(HttpService.name)) {
          continue;
        }
        innerHttpClients.add(method);
      }

      for (final MethodDeclaration innerHttpClient in innerHttpClients) {
        final TachyonDartType returnType = innerHttpClient.returnType.customDartType;
        codeWriter
          ..writeln()
          ..writeln('@override')
          ..writeln(
              'late final ${returnType.fullTypeName} ${innerHttpClient.name.lexeme} = ${returnType.fullTypeName}(_client, _pathPrefix);')
          ..writeln();
      }

      final List<MethodDeclaration> httpMethods =
          classDeclaration.members.whereType<MethodDeclaration>().where((MethodDeclaration method) {
        return method.isAbstract &&
            method.metadata
                .any((Annotation annotation) => _httpRouteMatcher.hasMatch(annotation.name.name));
      }).toList(growable: false);

      for (final MethodDeclaration method in httpMethods) {
        final AnnotationValueExtractor httpRouteAnnotation = AnnotationValueExtractor(
            method.metadata.firstWhereOrNull(
                (Annotation annotation) => _httpRouteMatcher.hasMatch(annotation.name.name)));

        final Map<String, String> queryParameters = <String, String>{};
        final Map<String, String> pathParameters = <String, String>{};

        final TachyonDartType returnType = method.returnType.customDartType;

        if (returnType.name != 'FutureHttpResult') {
          logger.warning('Expected FutureHttpResult with a generic type');
          continue;
        }

        codeWriter
          ..writeln('@override')
          ..write(returnType.fullTypeName)
          ..write(' ${method.name.lexeme}(');

        bool hasFoundNamedParameter = false;
        for (final FormalParameter parameter
            in method.parameters?.parameters ?? const <FormalParameter>[]) {
          final Annotation? queryParamAnnotation =
              parameter.metadata.getAnnotationWithName(QueryParam.name);
          final AnnotationValueExtractor queryParamAnnotationValueExtractor =
              AnnotationValueExtractor(parameter.metadata.getAnnotationWithName(QueryParam.name));

          final Annotation? pathParamAnnotation =
              parameter.metadata.getAnnotationWithName(PathParam.name);
          final AnnotationValueExtractor queryPathAnnotationValueExtrator =
              AnnotationValueExtractor(parameter.metadata.getAnnotationWithName(PathParam.name));

          if (queryParamAnnotation != null) {
            queryParameters[queryParamAnnotationValueExtractor.getPositionedString(0) ??
                parameter.name!.lexeme] = parameter.name!.lexeme;
          }

          if (pathParamAnnotation != null) {
            pathParameters[queryPathAnnotationValueExtrator.getPositionedString(0) ??
                parameter.name!.lexeme] = parameter.name!.lexeme;
          }

          if (parameter is SimpleFormalParameter || parameter is DefaultFormalParameter) {
            if (!hasFoundNamedParameter && parameter.isNamed) {
              hasFoundNamedParameter = true;
              codeWriter.write('{');
            }

            if (parameter.isNamed) {
              if (parameter.isRequired) {
                codeWriter.write('required ');
              }
            }

            if (parameter is SimpleFormalParameter) {
              codeWriter.write(parameter.type?.toSource() ?? 'dynamic');
            } else if (parameter is DefaultFormalParameter &&
                parameter.parameter is SimpleFormalParameter) {
              final TachyonDartType dartType =
                  (parameter.parameter as SimpleFormalParameter).type.customDartType;
              codeWriter.writeln(dartType.fullTypeName);
            }

            codeWriter
              ..write(' ')
              ..write(parameter.name!.lexeme);

            if (parameter is DefaultFormalParameter && parameter.defaultValue != null) {
              codeWriter.write(' = ${parameter.defaultValue!.toSource()}');
            }
          }
          codeWriter.write(',');
        }

        if (hasFoundNamedParameter) {
          codeWriter.write('}');
        }

        final String httpMethod = httpRouteAnnotation.getNamedConstructorName() ?? '';
        String routePath = httpRouteAnnotation.getPositionedString(0)!;
        if (routePath.isNotEmpty && routePath[0] == '/') {
          routePath = routePath.substring(1);
        }

        codeWriter
          ..writeln(') async {')
          ..writeln('try {')
          ..write("final String path = '\$_pathPrefix/$routePath'");

        if (pathParameters.isEmpty) {
          codeWriter.writeln(';');
        } else {
          codeWriter
            ..write(".replaceAllMapped(RegExp(r':(")
            ..write(pathParameters.keys.join('|'))
            ..write(")')")
            ..writeln(', (Match match) {');

          codeWriter.writeln('return switch (match.group(1)) {');
          for (final MapEntry<String, String> entry in pathParameters.entries) {
            codeWriter.writeln("'${entry.key}' => '\$${entry.value}',");
          }
          codeWriter
            ..writeln("_ => '',")
            ..writeln('};')
            ..writeln('}')
            ..writeln(');');
        }

        codeWriter
          ..write('final Response<dynamic> response = await _client.')
          ..write(httpMethod)
          ..write('(path, ');

        if (method.metadata.hasAnnotationWithName(HttpMultipart.name)) {
          await _writeFormData(
            methodDeclaration: method,
            codeWriter: codeWriter,
            declarationFinder: declarationFinder,
            logger: logger,
            buildInfo: buildInfo,
          );
        } else {
          final FormalParameter? bodyParameter =
              method.parameters?.parameters.firstWhereOrNull((FormalParameter parameter) {
            return parameter.metadata.hasAnnotationWithName(HttpPayload.name);
          });
          if (bodyParameter != null) {
            await _writeHttpPayloadData(
              bodyParameter: bodyParameter,
              codeWriter: codeWriter,
              declarationFinder: declarationFinder,
            );
          }
        }

        if (queryParameters.isNotEmpty) {
          codeWriter.write('queryParameters: <String, String>{');

          for (final MapEntry<String, String> entry in queryParameters.entries) {
            codeWriter.writeln("'${entry.key}': ${entry.value}.toString(),");
          }

          codeWriter.write('},');
        }

        final List<Annotation> httpHeadersAnnotations = method.metadata
            .where((Annotation element) => element.name.name == HttpHeader.name)
            .toList(growable: false);

        if (httpHeadersAnnotations.isNotEmpty) {
          codeWriter
            ..writeln('options: Options(')
            ..writeln('headers: <String, String>{');
          for (final Annotation a in httpHeadersAnnotations) {
            final AnnotationValueExtractor annotationValueExtractor = AnnotationValueExtractor(a);
            codeWriter
              ..writeln(annotationValueExtractor.getPositionedArgument(0)!.toSource())
              ..write(':')
              ..write(annotationValueExtractor.getPositionedArgument(1)!.toSource())
              ..writeln(',');
          }
          codeWriter
            ..write('},')
            ..write('),');
        }

        codeWriter.writeln(');');

        final TachyonDartType dataType = returnType.typeArguments[0];

        codeWriter.write('return HttpResult<${dataType.fullTypeName}>.data(');

        if (dataType.isPrimitive) {
          codeWriter.writeln('response.data as ${dataType.fullTypeName});');
        } else {
          await HttpClientFromJsonGenerator(
            codeWriter: codeWriter,
            dartType: dataType,
            classDeclarationFinder: declarationFinder.findClassOrEnum,
            logger: logger,
          ).execute();
          codeWriter.writeln(');');
        }

        codeWriter
          ..writeln('}') // try { ... }/ on DioException catch (exception) { ... }
          ..writeln('on Exception catch (exception, stackTrace) {')
          ..writeln(
              'return HttpResult<${dataType.fullTypeName}>.failure(exception, stackTrace: stackTrace);')
          ..writeln('}')
          ..writeln('catch (exception) { rethrow; }');

        codeWriter.writeln('}'); // end of method
      }

      codeWriter
        ..writeln('}')
        ..writeln();
    }

    return codeWriter.content;
  }

  Future<void> _writeHttpPayloadData({
    required final FormalParameter bodyParameter,
    required final CodeWriter codeWriter,
    required final TachyonDeclarationFinder declarationFinder,
  }) async {
    final String parameterName = bodyParameter.name!.lexeme;
    TachyonDartType dartType = TachyonDartType.dynamic;

    if (bodyParameter is SimpleFormalParameter) {
      dartType = bodyParameter.type.customDartType;
    } else if (bodyParameter is DefaultFormalParameter &&
        bodyParameter.parameter is SimpleFormalParameter) {
      dartType = (bodyParameter.parameter as SimpleFormalParameter).type.customDartType;
    }

    if (dartType.isPrimitive || dartType.isDynamic || dartType.isCollection) {
      codeWriter.write('data: $parameterName,');
    } else if (dartType.isUri) {
      codeWriter.write('data: $parameterName.toString(),');
    } else if (dartType.isDateTime) {
      codeWriter.write('data: $parameterName.toIso8601String(), ');
    } else {
      final NamedCompilationUnitMember? variableTypeDeclaration = await declarationFinder
          .findClassOrEnum(dartType.name)
          .then((ClassOrEnumDeclarationMatch? match) => match?.node);
      if (variableTypeDeclaration is ClassDeclaration &&
              variableTypeDeclaration.hasMethod('toJson') ||
          variableTypeDeclaration is EnumDeclaration &&
              variableTypeDeclaration.hasMethod('toJson')) {
        codeWriter.write('data: $parameterName.toJson(),');
      }
    }
  }

  Future<void> _writeFormData({
    required final MethodDeclaration methodDeclaration,
    required final CodeWriter codeWriter,
    required final TachyonDeclarationFinder declarationFinder,
    required final Logger logger,
    required final FileChangeBuildInfo buildInfo,
  }) async {
    bool formFieldAnnotationMatcher(Annotation annotation) =>
        annotation.name.name.startsWith(HttpFormField.name);

    final List<FormalParameter> formFieldsParameters =
        methodDeclaration.parameters?.parameters.where((FormalParameter parameter) {
              return parameter.metadata.firstWhereOrNull(formFieldAnnotationMatcher) != null;
            }).toList(growable: false) ??
            const <FormalParameter>[];

    codeWriter
      ..writeln('data: await (() async {')
      ..writeln('final FormData data = FormData.fromMap({');

    for (final FormalParameter parameter in formFieldsParameters) {
      final AnnotationValueExtractor annotationValueExtractor =
          AnnotationValueExtractor(parameter.metadata.firstWhere(formFieldAnnotationMatcher));

      final String parameterName = parameter.name!.lexeme;
      final String formFieldName = annotationValueExtractor.getString('name') ?? parameterName;
      final bool isFile = annotationValueExtractor.getNamedConstructorName() == 'file';

      TachyonDartType dartType = TachyonDartType.dynamic;
      if (parameter is SimpleFormalParameter) {
        dartType = parameter.type.customDartType;
      } else if (parameter is DefaultFormalParameter &&
          parameter.parameter is SimpleFormalParameter) {
        dartType = (parameter.parameter as SimpleFormalParameter).type.customDartType;
      }

      if (isFile) {
        if (dartType.isString) {
          codeWriter.write("'$formFieldName': await MultipartFile.fromFile($parameterName");

          final String? fileName = annotationValueExtractor.getString('fileName');
          if (fileName != null) {
            codeWriter.writeln(", filename: '$fileName'");
          }

          codeWriter.writeln('),');
        } else {
          logger
            ..warning('Only a "String" type is valid for a form file field.')
            ..warning(parameter.toSource());
        }

        continue;
      }

      if (dartType.isPrimitive || dartType.isCollection) {
        codeWriter.writeln("'$formFieldName': $parameterName,");
      } else if (dartType.isUri) {
        codeWriter.writeln("'$formFieldName', '\$$parameterName.toString()',");
      } else if (dartType.isDateTime) {
        codeWriter.writeln("'$formFieldName', '\$$parameterName.toIso8601String()',");
      } else {
        final NamedCompilationUnitMember? variableTypeDeclaration = await declarationFinder
            .findClassOrEnum(dartType.name)
            .then((ClassOrEnumDeclarationMatch? match) => match?.node);
        if (variableTypeDeclaration is ClassDeclaration &&
                variableTypeDeclaration.hasMethod('toJson') ||
            variableTypeDeclaration is EnumDeclaration &&
                variableTypeDeclaration.hasMethod('toJson')) {
          codeWriter.write("'$formFieldName': $parameterName.toJson(),");
        }
      }
    }

    final AnnotationValueExtractor multipartAnnotationValueExtractor = AnnotationValueExtractor(
        methodDeclaration.metadata.getAnnotationWithName(HttpMultipart.name));

    codeWriter
      ..write('}, ')
      ..write('ListFormat.')
      ..write(multipartAnnotationValueExtractor.getEnumValue('listFormat') ?? 'multi')
      ..writeln(');')
      ..writeln('return data;')
      ..writeln('})(),');
  }
}
