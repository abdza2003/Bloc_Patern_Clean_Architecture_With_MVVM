part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}
class ChangeProductsStateEvent extends ProductsEvent{
  late final int index;
  late final bool isMarket;
  late final SchoolProducts schoolProducts;
}
class GetAllSchoolProductsEvent extends ProductsEvent{
  late final int childId;
  late final String accessToken;

  GetAllSchoolProductsEvent(this.childId, this.accessToken);
}
class GetInvoicesEvent extends ProductsEvent{
  late final int childId;
  late final String accessToken;
  late final String? from;
  late final String? to;

  GetInvoicesEvent(this.childId, this.accessToken,this.from,this.to);
}
class GetHistoryProductsEvent extends ProductsEvent{
  late final int invoiceId;
  late final String accessToken;

  GetHistoryProductsEvent(this.invoiceId, this.accessToken);
}
class GetAllBannedProductsEvent extends ProductsEvent{
  late final int childId;
  late final String accessToken;

  GetAllBannedProductsEvent(this.childId, this.accessToken);
}
class DeleteBannedProductsEvent extends ProductsEvent{
  late final int productId;
  late final int childId;
  late final String accessToken;

  DeleteBannedProductsEvent(this.productId, this.childId, this.accessToken);
}
class StoreBannedProductsEvent extends ProductsEvent{
  late final SelectedProductsModel selectedProducts;
  late final String accessToken;

  StoreBannedProductsEvent(this.selectedProducts, this.accessToken);
}
class GetSchoolDaysEvent extends ProductsEvent{
  late final int childId;
  late final String accessToken;

  GetSchoolDaysEvent(this.childId, this.accessToken);
}
class GetSchoolProductsByPriceEvent extends ProductsEvent{
  late final int childId;
  late final double? maxPrice;
  late final String accessToken;

  GetSchoolProductsByPriceEvent(this.childId, this.accessToken,this.maxPrice);
}
class GetDayProductsEvent extends ProductsEvent{
  late final int childId;
  late final int dayId;
  late final String accessToken;

  GetDayProductsEvent(this.childId, this.accessToken,this.dayId);
}
class DeleteDayProductEvent extends ProductsEvent{
  late final int productId;
  late final int childId;
  late final int dayId;
  late final String accessToken;

  DeleteDayProductEvent(this.productId, this.childId, this.accessToken,this.dayId);
}
class StoreDayProductsEvent extends ProductsEvent{
  late final SelectedProductsQuantityModel selectedProducts;
  late final String accessToken;

  StoreDayProductsEvent(this.selectedProducts, this.accessToken);
}
class StoreWeekProductsEvent extends ProductsEvent{
  late final SelectedProductsQuantityModel selectedProducts;
  late final String accessToken;

  StoreWeekProductsEvent(this.selectedProducts, this.accessToken);
}

class GetDatedProductsEvent extends ProductsEvent{
  late final String accessToken;
  late final int dayId;

  GetDatedProductsEvent(this.accessToken,this.dayId);
}
class GetBookedProductsEvent extends ProductsEvent{
  late final int childId;
  late final int dayId;
  late final String accessToken;

  GetBookedProductsEvent(this.childId, this.accessToken,this.dayId);
}
class StoreDayBookedProductsEvent extends ProductsEvent{
  late final SelectedProductsQuantityModel selectedProducts;
  late final String accessToken;

  StoreDayBookedProductsEvent(this.selectedProducts, this.accessToken);
}