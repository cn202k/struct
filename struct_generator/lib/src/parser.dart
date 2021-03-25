import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:struct/struct.dart';
import 'package:struct_generator/src/element.dart';
import 'package:struct_generator/src/models.dart';

class Parser {
  LibrarySpec parse(LibraryReader lib) => LibrarySpec(
        structs: lib
            .annotatedWith(const TypeChecker.fromRuntime(Struct))
            .map(_struct),
      );

  StructSpec _struct(AnnotatedElement annotatedElement) {
    final element = annotatedElement.element;
    if (element is! FunctionTypeAliasElement) {
      throw InvalidGenerationSourceError(
        "@struct can be used only for function type aliases",
        element: element,
      );
    }
    final typedefElement = TypedefElement(element);
    return StructSpec(
      name: typedefElement.identifier(),
      typeParameters: typedefElement.typeParameters(),
      fields: typedefElement.parameters().map(_structField),
    );
  }

  FieldSpec _structField(TypedefParameterElement param) {
    final kind = param.kind();
    final type = param.type();
    if (kind == ParameterKind.UnnamedOptional && !type.isNullable()) {
      throw InvalidGenerationSourceError(
        "@struct can't has non-nullable optional parameter(s)",
        element: param.element,
      );
    }
    return FieldSpec(
      name: param.identifier(),
      isOptional: kind.isOptional(),
      isNamed: kind.isNamed(),
      shouldBeMarkedAsRequired: param.isMarkedAsRequired() ||
          (kind == ParameterKind.NamedOptional && !type.isNullable()),
      validators:
          param.findAnnotationsOf(ValueValidator).map(_valueValidator),
      type: FieldTypeSpec(
        name: type.source(),
        isNullable: type.isNullable(),
        spec: null,
        url: _resolveTypeUri(type),
      ),
    );
  }

  String? _resolveTypeUri(TypedefParameterTypeElement type) {
    final uri = type.uri();
    if (uri == null) return null;
    if (uri.startsWith('dart:core')) return null;
    return uri;
  }

  StructSpec? _tryObtainChildStruct(TypedefParameterTypeElement type) {
    final element = type.element;
    if (element is! GenericFunctionTypeElement) return null;
    final maybeTypedef = element.enclosingElement;
    if (maybeTypedef is! FunctionTypeAliasElement) return null;
    return null;
  }

  ValueValidatorSpec _valueValidator(
      TypedefParameterAnnotation annotation) {
    return ValueValidatorSpec(
      source: annotation.source().replaceFirst('@', ''),
      url: annotation.uri(),
    );
  }
}
