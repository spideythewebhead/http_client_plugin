import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:http_client_plugin/src/annotations/http.dart';
import 'package:tachyon/tachyon.dart';

class HttpClientAssistContributor extends Object
    with AssistContributorMixin
    implements AssistContributor {
  HttpClientAssistContributor(this.targetFilePath);

  final String targetFilePath;

  late final DartAssistRequest assistRequest;

  @override
  late final AssistCollector collector;

  AnalysisSession get _session => assistRequest.result.session;

  @override
  Future<void> computeAssists(
    covariant DartAssistRequest request,
    AssistCollector collector,
  ) async {
    assistRequest = request;
    this.collector = collector;
    final ChangeBuilder changeBuilder = ChangeBuilder(session: _session);

    final ClassCollectorAstVisitor visitor = ClassCollectorAstVisitor(
      matcher: (ClassDeclaration node) => node.metadata.hasAnnotationWithName(HttpService.name),
    );
    assistRequest.result.unit.visitChildren(visitor);

    if (visitor.matchedNodes.isEmpty) {
      return;
    }

    await changeBuilder.addDartFileEdit(targetFilePath, (DartFileEditBuilder fileEditBuilder) {
      for (final ClassDeclaration classDeclaration in visitor.matchedNodes) {
        final String className = classDeclaration.name.lexeme;

        if (classDeclaration.abstractKeyword == null) {
          fileEditBuilder.addInsertion(
            classDeclaration.classKeyword.offset,
            (DartEditBuilder builder) => builder.write('abstract '),
          );
        }

        final ConstructorDeclaration? privateConstructor =
            classDeclaration.members.firstWhereOrNull((ClassMember member) {
          return member is ConstructorDeclaration &&
              member.factoryKeyword == null &&
              member.name?.lexeme == '_';
        }) as ConstructorDeclaration?;

        if (privateConstructor != null) {
          fileEditBuilder.addReplacement(
            SourceRange(privateConstructor.offset, privateConstructor.length),
            (DartEditBuilder builder) => builder.write('$className._();'),
          );
        } else {
          fileEditBuilder.addInsertion(
            2 + classDeclaration.leftBracket.offset,
            (DartEditBuilder builder) {
              builder
                ..writeln('  $className._();')
                ..writeln();
            },
          );
        }

        final ConstructorDeclaration? factoryConstructor =
            classDeclaration.members.firstWhereOrNull((ClassMember member) {
          return member is ConstructorDeclaration &&
              member.factoryKeyword != null &&
              member.name == null;
        }) as ConstructorDeclaration?;

        if (factoryConstructor != null) {
          fileEditBuilder.addReplacement(
            SourceRange(factoryConstructor.offset, factoryConstructor.length),
            (DartEditBuilder builder) {
              builder
                ..writeln('factory $className(')
                ..writeln('    Dio client, [')
                ..writeln('    String pathPrefix,')
                ..write('  ]) = _\$${className}Impl;');
            },
          );
        } else {
          fileEditBuilder.addInsertion(
            2 + classDeclaration.leftBracket.offset,
            (DartEditBuilder builder) {
              builder
                ..writeln('  factory $className(')
                ..writeln('    Dio client, [')
                ..writeln('    String pathPrefix,')
                ..writeln('  ]) = _\$${className}Impl;')
                ..writeln();
            },
          );
        }

        final MethodDeclaration? overrideHttpClientMethod =
            classDeclaration.members.firstWhereOrNull((ClassMember member) {
          return member is MethodDeclaration && member.name.lexeme == 'overrideHttpClient';
        }) as MethodDeclaration?;

        if (overrideHttpClientMethod != null) {
          fileEditBuilder.addReplacement(
            SourceRange(
              overrideHttpClientMethod.offset,
              overrideHttpClientMethod.length,
            ),
            (DartEditBuilder builder) {
              builder.write('$className overrideHttpClient(Dio client);');
            },
          );
        } else {
          int offset = classDeclaration.rightBracket.offset;
          if (factoryConstructor != null) {
            offset = 1 + factoryConstructor.offset + factoryConstructor.length;
          } else if (privateConstructor != null) {
            offset = 1 + privateConstructor.offset + privateConstructor.length;
          }
          fileEditBuilder.addInsertion(
            offset,
            (DartEditBuilder builder) {
              builder
                ..writeln()
                ..writeln('  $className overrideHttpClient(Dio client);');
            },
          );
        }
      }
    });

    addAssist(
      const AssistKind(
        'httpClientPluginAssist',
        1000,
        'Generate http services',
      ),
      changeBuilder,
    );
  }
}
