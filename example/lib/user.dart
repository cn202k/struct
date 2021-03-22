import 'package:struct/struct.dart';

@struct
typedef User({
  String? id,
  @notEmpty String name,
  Map<int, List<String>>? fog,
  dynamic xxx,
});
