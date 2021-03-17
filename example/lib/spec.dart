import 'package:struct/struct.dart';

@struct
typedef Person(
  @length(max: 20) String name, {
  @notEmpty int age,
  required int home,
  int? nullable,
  required int? nullableReq,
});

@struct
typedef User({
  String id,
  String name,
});
