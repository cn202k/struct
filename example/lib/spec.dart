import 'package:example/user.dart';
import 'package:struct/struct.dart';

// @struct
// typedef Person(
//   @length(max: 20) String name,
//   Calculator calc, {
//   User user,
//   @notEmpty int age,
//   required int home,
//   int? nullable,
//   required int? nullableReq,
// });

@struct
typedef Person(User user);
