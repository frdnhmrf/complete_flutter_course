import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  final _products = kTestProducts;

  List<Product> getProductList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<List<Product>> fetchPrdouctsList() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_products);
  }

  Stream<List<Product>> watchPrdouctsList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchPrdouctsList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}

final productRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productRepositoryProvider);
  return productsRepository.watchPrdouctsList();
});

final productsListFutureProvider = FutureProvider<List<Product>>((ref) {
  final productsRepository = ref.watch(productRepositoryProvider);
  return productsRepository.fetchPrdouctsList();
});

final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProduct(id);
});
