import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/product_model.dart';
import 'all_product.dart';

class FirestoreMigrator {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to clear all products from Firestore
  Future<void> clearAllProducts(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final snapshot = await _db.collection('products').get();
      WriteBatch batch = _db.batch();
      int count = 0;

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
        count++;
        if (count >= 450) {
          await batch.commit();
          batch = _db.batch();
          count = 0;
        }
      }

      if (count > 0) {
        await batch.commit();
      }

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("All products cleared successfully."),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to clear products: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Function to migrate all local data to Firestore
  Future<void> startMigration(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final Map<String, List<dynamic>> dataMapping = {
        'BELTS': belts,
        'GLOVES': gloves,
        'HAIR ACCESSORIES': hairAccessories,
        'HATS': hats,
        'JEWELRY': jewelry,
        'SCARVES': scarves,
        'SUNGLASSES': sunglasses,
        'WATCHES': watches,
        'BACKPACKS': backpacks,
        'CLUTCHES': clutches,
        'HANDBAGS': handbags,
        'MESSENGER BAGS': messengerBags,
        'TOTE BAGS': toteBags,
        'TRAVEL BAGS': travelBags,
        'WALLETS': wallets,
        'ACTIVEWEAR': activewear,
        'BLOUSES': blouses,
        'CARDIGANS': cardigans,
        'COATS': coats,
        'DRESSES': dresses,
        'GIRL COLLECTION': girlCollection,
        'HOODIES': hoodies,
        'JACKETS': jackets,
        'JEANS': jeans,
        'JOGGERS': joggers,
        'LEGGINGS': leggings,
        'PANTS': pants,
        'POLOS': polos,
        'SHIRTS': shirts,
        'SKIRT': skirt,
        'SUITS': suits,
        'SWEATSHIRTS': sweatshirts,
        'T-SHIRTS': tShirts,
        'VESTS': vests,
        'FLATS': flats,
        'HEELED': heeled,
        'LOAFERS': loafers,
        'SANDALS': sandals,
        'SLIPPERS': slippers,
        'SNEAKERS': sneakers,
        'SPORTS SHOES': sportsShoes,
        'TOYS': toys,
        'SKINCARE': skincare,
        'MAKEUP': makeup,
        'HAIRCARE': haircare,
        'FRAGRANCES': fragrances,
        'NAIL CARE': nailCare,
        'BEAUTY TOOLS': beautyTools,
        'PERFUMES': perfumesData,
        'BIRTHDAY GIFTS': birthdayGift,
        'BANNERS': bannerData,
        'GENERAL_PRODUCTS': products,
      };

      int totalMigrated = 0;
      int currentBatchCount = 0;
      WriteBatch batch = _db.batch();

      for (var entry in dataMapping.entries) {
        String subCategory = entry.key;
        List<dynamic> items = entry.value;
        String category = _getCategory(subCategory);

        for (var item in items) {
          Map<String, dynamic> rawItem = Map<String, dynamic>.from(item as Map);

          // Data normalization for Banners
          if (subCategory == 'BANNERS') {
            if (rawItem.containsKey('image')) {
              rawItem['images'] = [rawItem['image']];
            }
            if (rawItem.containsKey('subtitle')) {
              rawItem['subCategory'] = rawItem['subtitle'];
            }
            if (rawItem.containsKey('desc')) {
              rawItem['description'] = rawItem['desc'];
            }
          }

          // Use ProductModel to clean and validate data
          ProductModel product = ProductModel.fromMap(rawItem);
          Map<String, dynamic> firestoreData = product.toFirestore();

          // Apply Brand Mapping if brand_id exists
          if (rawItem['brand_id'] != null) {
            firestoreData['brand_name'] = _getBrandName(rawItem['brand_id']);
          }

          firestoreData['category'] = category;
          firestoreData['subCategory'] = subCategory;
          firestoreData['createdAt'] = FieldValue.serverTimestamp();

          DocumentReference docRef = _db.collection('products').doc();
          batch.set(docRef, firestoreData);

          totalMigrated++;
          currentBatchCount++;

          if (currentBatchCount >= 450) {
            await batch.commit();
            batch = _db.batch();
            currentBatchCount = 0;
            debugPrint(
              "Committed batch of 450 items. Total so far: $totalMigrated",
            );
          }
        }
      }

      if (currentBatchCount > 0) {
        await batch.commit();
        debugPrint("Committed final batch. Total migrated: $totalMigrated");
      }

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Success! Migrated $totalMigrated products to Firestore.",
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("Migration error: $e");
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Migration failed: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
          ),
        );
      }
    }
  }

  String _getBrandName(dynamic brandId) {
    int id = 0;
    if (brandId is int) id = brandId;
    if (brandId is String) id = int.tryParse(brandId) ?? 0;

    switch (id) {
      case 0:
        return 'LOUIS VUITTON';
      case 1:
        return 'CHANEL';
      case 2:
        return 'NIKE';
      case 3:
        return 'HERMÈS';
      case 4:
        return 'ZARA';
      case 5:
        return 'ADIDAS';
      case 6:
        return 'UNIQLO';
      case 7:
        return 'GUCCI';
      case 8:
        return 'PRADA';
      case 9:
        return 'H&M';
      default:
        return 'OTHER';
    }
  }

  String _getCategory(String subCategory) {
    if (subCategory == 'BANNERS') return 'BANNERS';
    if ([
      'BACKPACKS',
      'CLUTCHES',
      'HANDBAGS',
      'MESSENGER BAGS',
      'TOTE BAGS',
      'TRAVEL BAGS',
      'WALLETS',
    ].contains(subCategory)) {
      return 'BAGS';
    }
    if ([
      'ACTIVEWEAR',
      'BLOUSES',
      'CARDIGANS',
      'COATS',
      'DRESSES',
      'GIRL COLLECTION',
      'HOODIES',
      'JACKETS',
      'JEANS',
      'JOGGERS',
      'LEGGINGS',
      'PANTS',
      'POLOS',
      'SHIRTS',
      'SKIRT',
      'SUITS',
      'SWEATSHIRTS',
      'T-SHIRTS',
      'VESTS',
    ].contains(subCategory)) {
      return 'CLOTHING';
    }
    if ([
      'BELTS',
      'GLOVES',
      'HAIR ACCESSORIES',
      'HATS',
      'JEWELRY',
      'SCARVES',
      'SUNGLASSES',
      'WATCHES',
    ].contains(subCategory)) {
      return 'ACCESSORIES';
    }
    if ([
      'FLATS',
      'HEELED',
      'LOAFERS',
      'SANDALS',
      'SLIPPERS',
      'SNEAKERS',
      'SPORTS SHOES',
    ].contains(subCategory)) {
      return 'SHOES';
    }
    if ([
      'SKINCARE',
      'MAKEUP',
      'HAIRCARE',
      'FRAGRANCES',
      'NAIL CARE',
      'BEAUTY TOOLS',
      'PERFUMES',
    ].contains(subCategory)) {
      return 'BEAUTY';
    }
    if (['BIRTHDAY GIFTS', 'TOYS'].contains(subCategory)) {
      return 'GIFTS';
    }
    return 'OTHER';
  }
}
