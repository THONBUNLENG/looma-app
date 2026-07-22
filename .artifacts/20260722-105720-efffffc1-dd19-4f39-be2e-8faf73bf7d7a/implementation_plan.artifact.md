# Add New Product to Belts Category

The user wants to add a new product model to the `Product` collection. Based on the existing codebase, this involves updating the static data in `list_url.dart`, which is then used by `MigrationUtility` to upload data to Firestore.

## Proposed Changes

### Data Layer

#### [list_url.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/list_url.dart)

- Add the new belt product to the `belts` list.

```dart
final List<Map<String, dynamic>> belts = [
  {
    'images': [
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-initiales-monogram-shadow-40mm-reversible-belt--M4917V_PM2_Front%20view.png?wid=1090&hei=1090',
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-initiales-monogram-shadow-40mm-reversible-belt--M4917V_PM1_Worn%20view.png?wid=1090&hei=1090',
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-initiales-monogram-shadow-40mm-reversible-belt--M4917V_PM1_Detail%20view.png?wid=1090&hei=1090',
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-initiales-monogram-shadow-40mm-reversible-belt--M4917V_PM1_Other%20view.png?wid=1090&hei=1090',
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-initiales-monogram-shadow-40mm-reversible-belt--M4917V_PM1_Cropped%20worn%20view.png?wid=1090&hei=1090',
    ],
    'name':'belts',
    'id':1,
    'title': 'Premium Leather Belt',
    'price': '\$35.00',
    'size':false,
    'color':false,
    'discount':false,
    'rating': false,
    'sold': '2.4k',
    'reviews': false,
    'stock_status': 'in_stock',
    'is_favorite': false,
    'brand_id': 0,
    'sku': null,
    'description':
        'High-quality genuine leather belt with a sleek silver buckle. Perfect for both formal suits and casual jeans, providing durability and style.',
  },
  // ... existing belts
];
```

## Verification Plan

### Manual Verification
- Verify that `ProductModel.fromMap` correctly handles the new fields like `stock_status`, `brand_id`, etc., if they are added to the model later. Currently, `ProductModel` only picks up a subset of these fields.
- Confirm that the new product appears in the application after migration (if the user runs the migration utility).
