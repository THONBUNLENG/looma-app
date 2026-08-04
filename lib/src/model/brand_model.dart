class BrandModel {
  final String name;
  final String logo;
  final String description;
  final List<String> categories;

  const BrandModel({
    required this.name,
    required this.logo,
    required this.description,
    this.categories = const [],
  });
}

final List<BrandModel> featuredBrands = [
  const BrandModel(
    name: 'Louis Vuitton',
    logo: 'assets/image/lv.png',
    description: 'Famous luxury fashion house offering high-end apparel, bags, and accessories.',
    categories: ['WOMAN', 'MAN', 'BAG', 'SHOES'],
  ),
  const BrandModel(
    name: 'Chanel',
    logo: 'assets/image/chanel.png',
    description: 'Iconic French luxury brand known for timeless elegance, haute couture, and tweed suits.',
    categories: ['WOMAN', 'BAG', 'SHOES'],
  ),
  const BrandModel(
    name: 'Nike',
    logo: 'assets/icon/i_buy_item/nike.png',
    description: 'Global leader in athletic footwear, sportswear, and active clothing.',
    categories: ['MAN', 'WOMAN', 'SHOES'],
  ),
  const BrandModel(
    name: 'Hermès',
    logo: 'assets/image/hermès.png',
    description: 'High-end luxury goods maker celebrated for elite craftsmanship and ready-to-wear fashion.',
    categories: ['WOMAN', 'MAN', 'BAG'],
  ),
  const BrandModel(
    name: 'Zara',
    logo: 'assets/icon/i_buy_item/zara.png',
    description: 'Fast-fashion giant providing trendy, runway-inspired clothing at accessible prices.',
    categories: ['WOMAN', 'MAN', 'SHOES'],
  ),
  const BrandModel(
    name: 'Adidas',
    logo: 'assets/icon/i_buy_item/adidas.png',
    description: 'Major international sportswear brand focused on athletic shoes, streetwear, and training gear.',
    categories: ['MAN', 'WOMAN', 'SHOES'],
  ),
  const BrandModel(
    name: 'Uniqlo',
    logo: 'assets/icon/i_buy_item/uniqlo.png',
    description: 'Japanese casual wear retailer focused on high-quality, affordable everyday basics and innovative fabrics.',
    categories: ['MAN', 'WOMAN'],
  ),
  const BrandModel(
    name: 'Gucci',
    logo: 'assets/image/gucci.png',
    description: 'Renowned Italian luxury fashion house famous for bold style and modern chic designs.',
    categories: ['WOMAN', 'MAN', 'BAG', 'SHOES'],
  ),
  const BrandModel(
    name: 'Prada',
    logo: 'assets/image/prada.png',
    description: 'High-fashion Italian brand recognized for sleek, minimalist, and sophisticated styles.',
    categories: ['WOMAN', 'MAN', 'BAG', 'SHOES'],
  ),
  const BrandModel(
    name: 'H&M',
    logo: 'assets/icon/i_buy_item/h&m.png',
    description: 'Popular global retailer offering affordable, fast-fashion clothing for men, women, and children.',
    categories: ['WOMAN', 'MAN', 'SHOES'],
  ),
];
