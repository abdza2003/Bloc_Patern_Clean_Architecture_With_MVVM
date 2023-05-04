import 'package:dartz/dartz.dart';
import 'package:school_cafteria/features/products/domain/entities/selected_products_quantity.dart';
import 'package:school_cafteria/features/products/domain/repositories/products_repository.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/selected_products_model.dart';
import '../../data/models/selected_products_quantity_model.dart';

class StoreWeekProductsUsecase {
  final ProductsRepository repository;

  StoreWeekProductsUsecase(this.repository);

  Future<Either<Failure, Unit>> call(SelectedProductsQuantityModel selectedProducts,String accessToken) async {
    return await repository.storeWeekProducts(selectedProducts,accessToken);
  }
}
