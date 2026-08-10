class SouvenirModel {
  final String id;
  final String title;
  final String imagePath;
  final int pointCost;
  final String description;

  SouvenirModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.pointCost,
    this.description = "",
  });
}

final List<SouvenirModel> sampleSouvenirs = [
  SouvenirModel(
    id: "s1",
    title: "LOOMA Logo Mug",
    imagePath: "https://www.britishmuseumshoponline.org/media/catalog/product/k/2/k27650-british__museum_classic__mug_3.jpg?optimize=medium&bg-color=255,255,255&fit=bounds&height=&width=", // Ensure these assets exist or use placeholders
    pointCost: 100,
    description: "High-quality ceramic mug with LOOMA logo.",
  ),
  SouvenirModel(
    id: "s2",
    title: "LOOMA T-Shirt",
    imagePath: "https://www.mrporter.com/variants/images/1647597316914869/in/w2000_q60.jpg",
    pointCost: 250,
    description: "Premium cotton T-Shirt with embroidered logo.",
  ),
  SouvenirModel(
    id: "s3",
    title: "LOOMA Tote Bag",
    imagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI3JGgp9wSQvOBmNMBVPU1lNP1t5SL1pfC4oX1FW1WTQUpeNA1TeNFu5ow&s=10",
    pointCost: 150,
    description: "Eco-friendly canvas tote bag.",
  ),
  SouvenirModel(
    id: "s4",
    title: "LOOMA Cap",
    imagePath: "https://kompsos.co/cdn/shop/files/Maldives-Souvenir-Daddy-Cap-Navy-Blue-Kompsos.png?v=1773792151",
    pointCost: 120,
    description: "Stylish adjustable baseball cap.",
  ),
  SouvenirModel(
    id: "s5",
    title: "LOOMA Keychain LV",
    imagePath: "https://my.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-cute-kitten-bag-charm--M03512_PM2_Front%20view.jpg",
    pointCost: 350,
    description: "Metal keychain with engraved LOOMA emblem.",
  ),
  SouvenirModel(
    id: "s6",
    title: "LOOMA Water Bottle LV",
    imagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhLmdRjE0F_kulsbBpDp3M9IAD8-FAXpULoMa6kJrJjjmEZcao0i0HXpQH&s=10",
    pointCost: 400,
    description: "Insulated stainless steel water bottle, keeps drinks cold for 24 hours.",
  ),
  SouvenirModel(
    id: "s7",
    title: "LOOMA Notebook",
    imagePath: "https://sc04.alicdn.com/kf/Ha1748612788346ed925bab809cbe76e52.png",
    pointCost: 90,
    description: "A5 hardcover notebook with dotted pages and elastic closure.",
  ),
  SouvenirModel(
    id: "s8",
    title: "LOOMA Hoodie",
    imagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZnTeFTAgNO4pFVws8MzxUJqn57gipSsyvFa44UfWkNQ&s=10",
    pointCost: 400,
    description: "Cozy fleece-lined hoodie with printed LOOMA wordmark.",
  ),
  SouvenirModel(
    id: "s9",
    title: "LOOMA Pin Badge Set",
    imagePath: "https://eluxive.com/cdn/shop/products/DSC_0323_7ef19ad5-10ae-4407-a2ae-034b76e2592f_1500x.jpg?v=1504659275",
    pointCost: 60,
    description: "Set of 3 enamel pins featuring the LOOMA logo and mascot.",
  ),
  SouvenirModel(
    id: "s10",
    title: "LOOMA Phone Case",
    imagePath: "https://ucasespot.com/wp-content/uploads/2026/04/multicolor-monogram-LV-iPhone-case2-600x600.jpg",
    pointCost: 180,
    description: "Shockproof phone case with subtle LOOMA branding.",
  ),
  SouvenirModel(
    id: "s11",
    title: "LOOMA Sticker Pack",
    imagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTR8FPDfAZrKjegAEBjn-skUuWjHwDsx9MIeat9LT8zNvSMgXYDoKWd6Aw&s=10",
    pointCost: 30,
    description: "Pack of 10 vinyl stickers, weatherproof and fade-resistant.",
  ),
  SouvenirModel(
    id: "s12",
    title: "LOOMA Backpack",
    imagePath: "https://my.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-keeper--M2A052_PM1_Back%20view.jpg",
    pointCost: 500,
    description: "Durable laptop backpack with padded straps and multiple compartments.",
  ),
  SouvenirModel(
    id: "s13",
    title: "LOOMA Umbrella",
    imagePath: "https://www.adcomarketing.com/images/thumbs/0063021_luxury-mini-umbrella-with-gift-box_625.jpeg",
    pointCost: 220,
    description: "Windproof compact umbrella with automatic open/close.",
  ),
  SouvenirModel(
    id: "s14",
    title: "LOOMA Socks",
    imagePath: "https://www.organic-socks.com/cdn/shop/products/Royal_Box_800x.jpg?v=1567503093",
    pointCost: 70,
    description: "Comfortable cotton-blend socks with woven LOOMA logo.",
  ),
  SouvenirModel(
    id: "s15",
    title: "LOOMA Wireless Earbuds APPLE",
    imagePath: "https://drhead.ae/upload/dev2fun.imagecompress/webp/iblock/2ad/qclenlu86mz9gfoo79lq5i5ijw37s4ue/Apple_AirPods_Max_5.webp",
    pointCost: 600,
    description: "Bluetooth earbuds with charging case and LOOMA branding.",
  ),
  SouvenirModel(
    id: "s16",
    title: "LOOMA Beanie",
    imagePath: "https://copenhagensouvenir.com/image/a7d11550-9cb4-43b6-bcb8-2bbef0c1e54d/070825_0.png/small",
    pointCost: 110,
    description: "Warm knit beanie with embroidered LOOMA patch.",
  ),
  SouvenirModel(
    id: "s17",
    title: "LOOMA Desk Lamp",
    imagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvWzXZdKZlWmLY2Nsznqx7UaF1__c0GoUobEyN355XyQ&s",
    pointCost: 300,
    description: "LED desk lamp with adjustable brightness and USB charging port.",
  ),
  SouvenirModel(
    id: "s18",
    title: "LOOMA Card Holder",
    imagePath: "https://m.media-amazon.com/images/I/71rGcmLJwDL._AC_UY1000_.jpg",
    pointCost: 80,
    description: "Slim leather card holder with embossed LOOMA logo.",
  ),
  SouvenirModel(
    id: "s19",
    title: "LOOMA Power Bank",
    imagePath: "https://yachendigital.com/wp-content/uploads/2026/07/apple-watch-powerbank.png",
    pointCost: 350,
    description: "10,0000mAh portable power bank with dual USB output.",
  ),
  SouvenirModel(
    id: "s20",
    title: "LOOMA Limited Edition Jacket",
    imagePath: "https://maisonspecial.co.jp/cdn/shop/files/KHK_0605df73-c8b8-420e-94e1-9ab8be0c2767_1500x.jpg?v=1739601368",
    pointCost: 800,
    description: "Limited edition windbreaker jacket, exclusive members-only design.",
  ),
];
