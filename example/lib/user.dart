import 'package:struct/struct.dart';

@struct
typedef User<T extends List<String>>({
  String? id,
  T tags,
  @notEmpty String name,
  Map<int, List<String>>? fog,
  dynamic xxx,
});
