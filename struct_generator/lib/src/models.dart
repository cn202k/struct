class LibrarySpec {
  final Iterable<StructSpec> structs;

  LibrarySpec({required this.structs});
}

class StructSpec {
  final String name;
  final Iterable<FieldSpec> fields;

  StructSpec({
    required this.name,
    required this.fields,
  });
}

class FieldSpec {
  final String? name;
  final FieldTypeSpec type;
  final bool isOptional;
  final bool isRequired;
  final bool isNamed;
  final Iterable<ValueValidatorSpec> validators;

  FieldSpec({
    required this.name,
    required this.type,
    required this.isOptional,
    required this.isRequired,
    required this.isNamed,
    required this.validators,
  }) : assert(
          !(!type.isNullable && isOptional && !isRequired),
          "'$name' : non-nullable optional parameter is not allowed",
        );
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
  final bool isStruct;
  final String? url;

  FieldTypeSpec({
    required this.name,
    required this.isNullable,
    required this.isStruct,
    required this.url,
  });
}
