import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeProductsRepository makeProductsRepository() =>
      FakeProductsRepository(addDelay: false);
  group(
    "Fake Product Repository",
    () {
      testWidgets('getProductList ...', (tester) async {
        final productRepository = makeProductsRepository();
        expect(productRepository.getProductList(), kTestProducts);
      });
      test("get Product List", () {
        final productRepository = makeProductsRepository();
        expect(productRepository.getProductList(), kTestProducts);
      });

      test('get data 1 return data', () {
        final productRepository = makeProductsRepository();
        expect(
          productRepository.getProduct('1'),
          kTestProducts[0],
        );
      });

      test('get data 100 return null', () {
        final productRepository = makeProductsRepository();
        expect(
          productRepository.getProduct('100'),
          null,
        );
      });

      test('Fetch Product List return global list', () async {
        final productsRepository = makeProductsRepository();
        expect(
          await productsRepository.fetchPrdouctsList(),
          kTestProducts,
        );
      });

      test('watchProductsList emits global list', () {
        final productsRepository = makeProductsRepository();
        expect(
          productsRepository.watchProductsList(),
          emits(kTestProducts),
        );
      });

      test('watchProduct(1) emit first item', () {
        final productsRepository = makeProductsRepository();
        expect(
          productsRepository.watchProduct('1'),
          emits(kTestProducts[0]),
        );
      });

      test('watchProduct(100) emit null', () {
        final productsRepository = makeProductsRepository();
        expect(
          productsRepository.watchProduct('100'),
          emits(null),
        );
      });
    },
  );
}
