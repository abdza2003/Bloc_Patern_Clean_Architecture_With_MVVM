import 'package:school_cafteria/features/products/data/models/selected_products_model.dart';
import '../../../../core/network/api.dart';
import '../../../../core/network/common_response.dart';
import '../models/selected_products_quantity_model.dart';

abstract class ProductsRemoteDataSource {
  Future<dynamic> getAllBannedProducts(int childId, String accessToken);
  Future<dynamic> getAllSchoolProducts(int childId, String accessToken);
  Future<dynamic> storeBannedProducts(
      SelectedProductsModel selectedProductsModel, String accessToken);
  Future<dynamic> deleteBannedProducts(
      int productId, int childId, String accessToken);

  Future<dynamic> getSchoolDays(int childId, String accessToken);
  Future<dynamic> getSchoolProductsByPrice(
      int childId, String accessToken, double? maxPrice);
  Future<dynamic> getDayProducts(int childId, String accessToken, int dayId);
  Future<dynamic> deleteDayProduct(
      int productId, int childId, String accessToken, int dayId);
  Future<dynamic> storeDayProducts(
      SelectedProductsQuantityModel selectedProducts, String accessToken);
  Future<dynamic> storeWeekProducts(
      SelectedProductsQuantityModel selectedProducts, String accessToken);

  Future<dynamic> getInvoices(
      int childId, String accessToken, String? from, String? to);
  Future<dynamic> getHistoryProducts(int invoiceId, String accessToken);

  Future<dynamic> getDatedProducts(String accessToken, int dayId);
  Future<dynamic> getBookedProducts(int childId, String accessToken, int dayId);
  Future<dynamic> storeDayBookedProducts(
      SelectedProductsQuantityModel selectedProducts, String accessToken);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  @override
  Future deleteBannedProducts(int productId, int childId, String accessToken) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['student_id'] = childId;
    return Network()
        .postAuthData(data, "/student/delete-banned-product", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getAllBannedProducts(int childId, String accessToken) {
    return Network()
        .getAuthData("/student/banned-products/$childId", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getAllSchoolProducts(int childId, String accessToken) {
    return Network()
        .getAuthData("/school/get-products/$childId", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future storeBannedProducts(
      SelectedProductsModel selectedProductsModel, String accessToken) {
    return Network()
        .postAuthData(selectedProductsModel.toJson(),
            "/student/store-banned-products", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future deleteDayProduct(
      int productId, int childId, String accessToken, int dayId) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['student_id'] = childId;
    data['day_id'] = dayId;
    return Network()
        .postAuthData(data, "/student/delete-product-by-day", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getSchoolProductsByPrice(
      int childId, String accessToken, double? maxPrice) {
    return Network()
        .getAuthData("/school/get-products/$childId/$maxPrice", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getDayProducts(int childId, String accessToken, int dayId) {
    return Network()
        .getAuthData(
            "/student/get-products-by-day/$childId/$dayId", accessToken)
        .then((dynamic response) {
      print('=========#####get day product ------- $response');
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getSchoolDays(int childId, String accessToken) {
    return Network()
        .getAuthData("/student/get-days/$childId", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future storeDayProducts(
      SelectedProductsQuantityModel selectedProducts, String accessToken) {
    return Network()
        .postAuthData(selectedProducts.toJson(), "/student/store-day-products",
            accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future storeWeekProducts(
      SelectedProductsQuantityModel selectedProducts, String accessToken) {
    return Network()
        .postAuthData(selectedProducts.toJson(),
            "/student/store-weekly-products", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getHistoryProducts(int invoiceId, String accessToken) {
    return Network()
        .getAuthData("/user/get-invoice-products/$invoiceId", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getInvoices(
      int childId, String accessToken, String? from, String? to) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = childId;
    data['from'] = from;
    data['to'] = to;
    return Network()
        .postAuthData(data, "/user/get-history", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getBookedProducts(int childId, String accessToken, int dayId) {
    return Network()
        .getAuthData(
            "/student/get-booked-products/$childId/$dayId", accessToken)
        .then((dynamic response) {
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future getDatedProducts(String accessToken, int dayId) {
    return Network()
        .getAuthData("/school/get-dated-product/$dayId", accessToken)
        .then((dynamic response) {
      print('============######$response');
      return CommonResponse<dynamic>.fromJson(response);
    });
  }

  @override
  Future storeDayBookedProducts(
      SelectedProductsQuantityModel selectedProducts, String accessToken) {
    return Network()
        .postAuthData(selectedProducts.toJson(),
            "/student/store-dated-products", accessToken)
        .then((dynamic response) {
      print('=====@#######%%%%% $response');
      return CommonResponse<dynamic>.fromJson(response);
    });
  }
}
