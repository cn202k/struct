import 'package:code_builder/code_builder.dart';
import 'package:struct_generator/src/models.dart';

class StructClassTemplate {
  final StructSpec _struct;

  StructClassTemplate(this._struct);

  Class inflate() => Class(
        (klass) => klass
          ..name = _struct.name
          ..types.addAll(_struct.typeParameters.map((it) => refer(it)))
          ..fields.addAll(_struct.fields.map((it) => _Field(it).inflate()))
          ..constructors.add(_Constructor(_struct).inflate()),
      );
}

class _Field {
  final FieldSpec _field;

  _Field(this._field);

  Field inflate() => Field(
        (field) => field
          ..name = _field.name
          ..modifier = FieldModifier.final$
          ..type = refer(_field.type.name),
      );
}

class _Constructor {
  final StructSpec _struct;

  _Constructor(this._struct);

  Parameter _inflateParameter(FieldSpec field) => Parameter(
        (param) => param
          ..name = field.name
          ..toThis = true
          ..named = field.isNamed
          ..required = field.shouldBeMarkedAsRequired,
      );

  Constructor inflate() => Constructor(
        (ctor) {
          final assertionCode =
              _needsAssertion() ? _assertionCode() : null;
          ctor
            ..constant = assertionCode == null
            ..requiredParameters.addAll(_struct.fields
                .where((it) => !it.isOptional)
                .map(_inflateParameter))
            ..optionalParameters.addAll(_struct.fields
                .where((it) => it.isOptional)
                .map(_inflateParameter));
          if (assertionCode != null) {
            ctor.initializers.add(Code(assertionCode));
          }
        },
      );

  String _assertionCode() {
    final codes = <String>[];

    for (final field in _struct.fields) {
      for (final validator in field.validators) {
        codes.add('''
        error = ${validator.source}.test(${field.name});
        assert(error == null, error);
        ''');
      }
    }
    return '''
    assert(() {
      String? error;
      ${codes.join()}
      return true;
    }())
    ''';
  }

  bool _needsAssertion() =>
      _struct.fields.any((it) => it.validators.isNotEmpty);
}
