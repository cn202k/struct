// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StructGenerator
// **************************************************************************

import 'package:struct/src/value_validators.dart';

class User {
  User({
    required this.id,
    required this.name,
    required this.fog,
    required this.xxx,
  }) : assert(() {
          String? error;
          error = notEmpty.test(name);
          assert(error == null, error);

          return true;
        }());

  final String? id;

  final String name;

  final Map<int, List<String>>? fog;

  final dynamic xxx;
}
