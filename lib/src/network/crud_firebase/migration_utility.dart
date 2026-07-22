import 'package:shared_preferences/shared_preferences.dart';
import '../../model/product_model.dart';
import '../../screen/list_url.dart' as static_data;
import 'firestore_service.dart';

class MigrationUtility {
  final FirestoreService _service = FirestoreService();

  Future<void> migrateAllProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool migrationDone = prefs.getBool('migration_done') ?? false;

    if (migrationDone) {
      print('Migration already completed previously. Skipping.');
      return;
    }

    print('Starting comprehensive migration...');
    
    final List<ProductModel> allProductsToUpload = [];

    // Accessories
    allProductsToUpload.addAll(_mapToModels(static_data.belts, 'belts'));
    allProductsToUpload.addAll(_mapToModels(static_data.gloves, 'gloves'));
    allProductsToUpload.addAll(_mapToModels(static_data.hairAccessories, 'hairAccessories'));
    allProductsToUpload.addAll(_mapToModels(static_data.hats, 'hats'));
    allProductsToUpload.addAll(_mapToModels(static_data.jewelry, 'jewelry'));
    allProductsToUpload.addAll(_mapToModels(static_data.scarves, 'scarves'));
    allProductsToUpload.addAll(_mapToModels(static_data.sunglasses, 'sunglasses'));
    allProductsToUpload.addAll(_mapToModels(static_data.watches, 'watches'));

    // Bags
    allProductsToUpload.addAll(_mapToModels(static_data.bags, 'bags'));
    allProductsToUpload.addAll(_mapToModels(static_data.backpacks, 'backpacks'));
    allProductsToUpload.addAll(_mapToModels(static_data.clutches, 'clutches'));
    allProductsToUpload.addAll(_mapToModels(static_data.handbags, 'handbags'));
    allProductsToUpload.addAll(_mapToModels(static_data.messengerBags, 'messengerBags'));
    allProductsToUpload.addAll(_mapToModels(static_data.toteBags, 'toteBags'));
    allProductsToUpload.addAll(_mapToModels(static_data.travelBags, 'travelBags'));
    allProductsToUpload.addAll(_mapToModels(static_data.wallets, 'wallets'));

    // Clothing
    allProductsToUpload.addAll(_mapToModels(static_data.clothes, 'clothes'));
    allProductsToUpload.addAll(_mapToModels(static_data.activewear, 'activewear'));
    allProductsToUpload.addAll(_mapToModels(static_data.blouses, 'blouses'));
    allProductsToUpload.addAll(_mapToModels(static_data.cardigans, 'cardigans'));
    allProductsToUpload.addAll(_mapToModels(static_data.coats, 'coats'));
    allProductsToUpload.addAll(_mapToModels(static_data.dresses, 'dresses'));
    allProductsToUpload.addAll(_mapToModels(static_data.girlCollection, 'girlCollection'));
    allProductsToUpload.addAll(_mapToModels(static_data.hoodies, 'hoodies'));
    allProductsToUpload.addAll(_mapToModels(static_data.jackets, 'jackets'));
    allProductsToUpload.addAll(_mapToModels(static_data.jeans, 'jeans'));
    allProductsToUpload.addAll(_mapToModels(static_data.joggers, 'joggers'));
    allProductsToUpload.addAll(_mapToModels(static_data.leggings, 'leggings'));
    allProductsToUpload.addAll(_mapToModels(static_data.pants, 'pants'));
    allProductsToUpload.addAll(_mapToModels(static_data.polos, 'polos'));
    allProductsToUpload.addAll(_mapToModels(static_data.shirts, 'shirts'));
    allProductsToUpload.addAll(_mapToModels(static_data.shorts, 'shorts'));
    allProductsToUpload.addAll(_mapToModels(static_data.skirt, 'skirt'));
    allProductsToUpload.addAll(_mapToModels(static_data.suits, 'suits'));
    allProductsToUpload.addAll(_mapToModels(static_data.sweatshirts, 'sweatshirts'));
    allProductsToUpload.addAll(_mapToModels(static_data.tShirts, 'tShirts'));
    allProductsToUpload.addAll(_mapToModels(static_data.vests, 'vests'));

    // Shoes
    allProductsToUpload.addAll(_mapToModels(static_data.shoes, 'shoes'));
    allProductsToUpload.addAll(_mapToModels(static_data.shoesBoots, 'shoesBoots'));
    allProductsToUpload.addAll(_mapToModels(static_data.flats, 'flats'));
    allProductsToUpload.addAll(_mapToModels(static_data.heeled, 'heeled'));
    allProductsToUpload.addAll(_mapToModels(static_data.loafers, 'loafers'));
    allProductsToUpload.addAll(_mapToModels(static_data.sandals, 'sandals'));
    allProductsToUpload.addAll(_mapToModels(static_data.slippers, 'slippers'));
    allProductsToUpload.addAll(_mapToModels(static_data.sneakers, 'sneakers'));
    allProductsToUpload.addAll(_mapToModels(static_data.sportsShoes, 'sportsShoes'));

    // Beauty & Others
    allProductsToUpload.addAll(_mapToModels(static_data.perfumesData, 'perfumes'));
    allProductsToUpload.addAll(_mapToModels(static_data.cosmeticsData, 'cosmetics'));
    allProductsToUpload.addAll(_mapToModels(static_data.skincare, 'skincare'));
    allProductsToUpload.addAll(_mapToModels(static_data.makeup, 'makeup'));
    allProductsToUpload.addAll(_mapToModels(static_data.haircare, 'haircare'));
    allProductsToUpload.addAll(_mapToModels(static_data.fragrances, 'fragrances'));
    allProductsToUpload.addAll(_mapToModels(static_data.nailCare, 'nailCare'));
    allProductsToUpload.addAll(_mapToModels(static_data.beautyTools, 'beautyTools'));
    allProductsToUpload.addAll(_mapToModels(static_data.toys, 'toys'));
    allProductsToUpload.addAll(_mapToModels(static_data.gift, 'gift'));

    // Lingerie & Extras
    allProductsToUpload.addAll(_mapToModels(static_data.bodysuitProduct, 'bodysuits'));
    allProductsToUpload.addAll(_mapToModels(static_data.nightwearProducts, 'nightwear'));
    allProductsToUpload.addAll(_mapToModels(static_data.pantyProducts, 'panties'));
    allProductsToUpload.addAll(_mapToModels(static_data.shapewearProducts, 'shapewear'));
    allProductsToUpload.addAll(_mapToModels(static_data.sockProducts, 'socks'));
    allProductsToUpload.addAll(_mapToModels(static_data.tightsProducts, 'tights'));
    allProductsToUpload.addAll(_mapToModels(static_data.discoverProducts, 'discover'));
    allProductsToUpload.addAll(_mapToModels(static_data.justForYouData, 'justForYou'));

    // Gifts
    allProductsToUpload.addAll(_mapToModels(static_data.birthdayGift, 'birthdayGift'));
    allProductsToUpload.addAll(_mapToModels(static_data.anniversaryGift, 'anniversaryGift'));
    allProductsToUpload.addAll(_mapToModels(static_data.weddingGift, 'weddingGift'));
    allProductsToUpload.addAll(_mapToModels(static_data.babyGift, 'babyGift'));
    allProductsToUpload.addAll(_mapToModels(static_data.valentineGift, 'valentineGift'));
    allProductsToUpload.addAll(_mapToModels(static_data.graduationGift, 'graduationGift'));
    allProductsToUpload.addAll(_mapToModels(static_data.personalizedGift, 'personalizedGift'));

    print('Total products to migrate: ${allProductsToUpload.length}');
    
    await _service.uploadBatchProducts(allProductsToUpload);
    
    await prefs.setBool('migration_done', true);
    print('Migration complete!');
  }

  List<ProductModel> _mapToModels(List<Map<String, dynamic>> data, String category) {
    return data.map((item) {
      final map = Map<String, dynamic>.from(item);
      map['category'] = category;
      return ProductModel.fromMap(map);
    }).toList();
  }
}
