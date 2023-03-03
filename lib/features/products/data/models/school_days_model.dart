import 'package:school_cafteria/features/products/domain/entities/school_days.dart';

class SchoolDaysModel extends SchoolDays {

  SchoolDaysModel({
    super.dayId,
    super.dayName,
    super.productsCount,
    super.productsPrice,
  });
  SchoolDaysModel.fromJson(Map<String, dynamic> json) {
    dayId = json['day_id'];
    dayName = json['day_name'];
    productsCount = json['products_count'];
    productsPrice = json['products_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['day_id'] = dayId;
    data['day_name'] = dayName;
    data['products_count'] = productsCount;
    data['products_price'] = productsPrice;
    return data;
  }

}
