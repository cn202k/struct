import 'package:struct/struct.dart';

@struct
typedef Person(
  String name, {
  int age,
  required int home,
  int? nullable,
  required int? nullableReq,
});
