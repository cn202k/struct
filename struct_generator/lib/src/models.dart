class LibrarySpec {
  final Iterable<StructSpec> structs;

  LibrarySpec({required this.structs});
}

class StructSpec {
  final String name;
  final Iterable<String> typeParameters;
  final Iterable<FieldSpec> fields;

  StructSpec({
    required this.name,
    required this.typeParameters,
    required this.fields,
  });
}

class FieldSpec {
  final String? name;
  final FieldTypeSpec type;
  final bool isOptional;
  final bool shouldBeMarkedAsRequired;
  final bool isNamed;
  final Iterable<ValueValidatorSpec> validators;

  FieldSpec({
    required this.name,
    required this.type,
    required this.isOptional,
    required this.shouldBeMarkedAsRequired,
    required this.isNamed,
    required this.validators,
  });
}

class ValueValidatorSpec {
  final String source;
  final String? url;

  ValueValidatorSpec({
    required this.source,
    required this.url,
  });
}

class FieldTypeSpec {
  final String? name;
  final bool isNullable;
  final StructSpec? spec;
  final String? url;

  FieldTypeSpec({
    required this.name,
    required this.isNullable,
    required this.spec,
    required this.url,
  });
}
