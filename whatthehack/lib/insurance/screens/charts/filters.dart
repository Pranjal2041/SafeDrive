import 'package:whatthehack/insurance/data/dictionary.dart';

removeFilters() {
  data = completeData.sublist(0);
}

filterByType(String type) {
  data = completeData.where((item) => item['type'] == type).toList();
}

filterByCost(int min, int max) {
  data = completeData
      .where((item) => item['cost'] <= max && item['cost'] >= min)
      .toList();
}
