import 'package:lotosui/view/home/home.dart';
import 'package:lotosui/view/some/info.dart';

final routes = {
  '/home': (context) => const LotosHome(title: 'Lotos UI'),
  '/instrumentInfo': (context) => const LotosInfo(),
};
