import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:struct/struct.dart';
import 'package:struct_generator/src/models.dart';

LibrarySpec parse(LibraryReader lib) => LibrarySpec(
      structs: lib.allElements
          .map(_toStructElement)
          .whereType<_StructElement>()
          .map(_parseStruct),
    );

StructSpec _parseStruct(_StructElement structElement) {
  final element = structElement.element;
  if (element is! FunctionTypeAliasElement) {
    throw InvalidGenerationSourceError(
      "@struct can be used only for function type aliases",
      element: element,
    );
  }
  return StructSpec(
    name: element.name,
    fields: element.function.parameters.map(_parseStructFields),
  );
}

DartObject? _findStructAnnotation(Element element) =>
    const TypeChecker.fromRuntime(Struct).firstAnnotationOfExact(element);

_StructElement? _toStructElement(Element element) {
  if (element is GenericFunctionTypeElement) {
    final type = element.enclosingElement;
    if (type is FunctionTypeAliasElement) {
      final annotation = _findStructAnnotation(type);
      if (annotation == null) return null;
      return _StructElement(type, annotation);
    }
  }
  final annotation = _findStructAnnotation(element);
  if (annotation == null) return null;
  return _StructElement(element, annotation);
}

bool _isStructElement(Element element) =>
    _toStructElement(element) != null;

class _StructElement {
  final Element element;
  final DartObject annotation;

  _StructElement(this.element, this.annotation);
}

FieldSpec _parseStructFields(ParameterElement element) {
  final type = _parseFieldType(element);
  final isNamed = element.isNamed;
  final isOptional = element.isOptionalPositional || isNamed;
  final isRequired =
      element.isRequiredNamed || (isNamed && !type.isNullable);
  if (!type.isNullable && isOptional && !isRequired) {
    throw InvalidGenerationSourceError(
      "@struct can't has non-nullable optional parameter(s)",
      element: element,
    );
  }
  return FieldSpec(
    name: element.name,
    isOptional: isOptional,
    isNamed: element.isNamed,
    isRequired: isRequired,
    type: type,
    validators: _parseValueValidators(element),
  );
}

Iterable<ValueValidatorSpec> _parseValueValidators(
  ParameterElement element,
) =>
    element.metadata.where((it) {
      final DartObject? value = it.computeConstantValue();
      return value != null &&
          const TypeChecker.fromRuntime(ValueValidator)
              .isAssignableFrom(value.type.element);
    }).map((it) => ValueValidatorSpec(
          source: it.toSource().replaceFirst('@', ''),
          url: _parseElementUri(it.element),
        ));

FieldTypeSpec _parseFieldType(ParameterElement element) {
  final name = _parseParameterType(element);
  final isNullable = _isNullableType(name);
  final uri = _parseElementUri(element.type.element);
  final maybeStruct = _toStructElement(element.type.element);
  final spec = maybeStruct != null ? _parseStruct(maybeStruct) : null;
  return FieldTypeSpec(
    name: name,
    isNullable: isNullable,
    spec: spec,
    url: uri,
  );
}

String? _parseElementUri(Element element) {
  final uri = element.source.uri;
  if (_isCoreLibrary(uri)) return null;
  return uri.toString();
}

bool _isCoreLibrary(Uri uri) => uri.toString().startsWith('dart:core');

final _starOrBracketOrBrace = RegExp(r'\*|\[|\]|\{|\}|(required)');
final _whitespaces = RegExp(r'\s+');

String _parseParameterType(ParameterElement element) {
  final tokens = element
      .getDisplayString(withNullability: true)
      .replaceAll(_starOrBracketOrBrace, '')
      .split(_whitespaces);
  tokens.removeLast();
  return tokens.join(' ');
}

bool _isNullableType(String type) => type.endsWith('?');
