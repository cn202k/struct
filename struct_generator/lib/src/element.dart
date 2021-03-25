import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

class TypedefElement {
  final FunctionTypeAliasElement element;

  TypedefElement(this.element);

  String identifier() => element.name;

  Iterable<TypedefParameterElement> parameters() =>
      element.function.parameters.map((it) => TypedefParameterElement(it));

  Iterable<String> typeParameters() {
    return element.typeParameters.map(
      (type) {
        final name = type.name;
        final DartType? bound = type.bound;
        return bound != null ? '$name extends $bound' : name;
      },
    );
  }
}

enum ParameterKind {
  NamedOptional,
  UnnamedOptional,
  NamedRequired,
  UnnamedRequired,
}

extension ParameterKindMethods on ParameterKind {
  bool isOptional() =>
      this == ParameterKind.NamedOptional ||
      this == ParameterKind.UnnamedOptional;

  bool isNamed() =>
      this == ParameterKind.NamedOptional ||
      this == ParameterKind.NamedRequired;
}

class TypedefParameterElement {
  final ParameterElement element;

  TypedefParameterElement(this.element);

  ParameterKind kind() {
    final isNamed = element.isNamed;
    final isOptional = element.isOptional;
    if (isNamed && isOptional) return ParameterKind.NamedOptional;
    if (!isNamed && isOptional) return ParameterKind.UnnamedOptional;
    if (isNamed && !isOptional) return ParameterKind.NamedRequired;
    return ParameterKind.UnnamedRequired;
  }

  String identifier() => element.name;

  Iterable<TypedefParameterAnnotation> findAnnotationsOf(Type type) {
    return element.metadata.where((it) {
      final DartObject? value = it.computeConstantValue();
      return value != null &&
          TypeChecker.fromRuntime(type)
              .isAssignableFrom(value.type.element);
    }).map((it) => TypedefParameterAnnotation(it));
  }

  String? uri() => element.source?.uri?.toString();

  bool isMarkedAsRequired() => element.isRequiredNamed;

  TypedefParameterTypeElement type() =>
      TypedefParameterTypeElement(element);
}

class TypedefParameterAnnotation {
  final ElementAnnotation _annotation;

  TypedefParameterAnnotation(this._annotation);

  String source() => _annotation.toSource();

  String? uri() => _annotation.element.source?.uri?.toString();
}

class TypedefParameterTypeElement {
  final ParameterElement _element;

  TypedefParameterTypeElement(this._element);

  Element get element => _element.type.element;

  bool isNullable() {
    final DartType? type = _element.type;
    if (type == null) return false;
    return type.nullabilitySuffix == NullabilitySuffix.question;
  }

  // TODO; Support function type
  String? source() {
    final source = _element.source.contents.data
        .substring(0, _element.nameOffset)
        .trim();
    return _type.firstMatch(source)?.group(0);
  }

  String? uri() => _element.type?.element?.source?.uri?.toString();
}

final _typeParams = r'<(\w|\?|,|<|>|\(|\)|\s)+>';
final _identifier = r'\w+';
final _nullSuffix = r'\?';
final _spaces = r'\s*';
final _typedType = [
  _identifier,
  '($_typeParams)?',
  '$_nullSuffix?',
].join(_spaces);

final _type = RegExp('$_typedType\$');
