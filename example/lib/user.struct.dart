// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StructGenerator
// **************************************************************************

import 'package:example/user.dart';
import 'package:struct/src/value_validators.dart';

class User<T extends List<String>> {
  User(
      {this.id,
      required this.tags,
      required this.name,
      this.fog,
      required this.xxx})
      : assert(() {
          String? error;
          error = notEmpty.test(name);
          assert(error == null, error);

          return true;
        }());

  final String? id;

  final T tags;

  final String name;

  final Map<int, List<String>>? fog;

  final dynamic xxx;
}
