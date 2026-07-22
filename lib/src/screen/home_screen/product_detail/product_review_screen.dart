import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/navigator_extension.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/profile_manager.dart';
import 'package:shopping_app/manager/review_manager.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../model/review_model.dart';
import '../../../widget/write_review_bottom_sheet.dart';

class ProductReviewScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductReviewScreen({super.key, required this.product});

  @override
  State<ProductReviewScreen> createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  int _selectedFilter = 0;

  final List<ReviewModel> _dummyReviews = [
    ReviewModel(
      id: "1",
      userName: "Sophea Rath",
      userImage: "https://i.pravatar.cc/150?u=sophea",
      rating: 5.0,
      comment: "Absolutely love the quality of this product! It exceeded my expectations. The material feels premium and the fit is perfect.",
      date: DateTime.now().subtract(const Duration(days: 2)),
      images: ["https://picsum.photos/200/300?random=1", "https://picsum.photos/200/300?random=2"],
    ),
    ReviewModel(
      id: "2",
      userName: "Chanlina Kim",
      userImage: "https://i.pravatar.cc/150?u=lina",
      rating: 4.0,
      comment: "Good product, but delivery took a bit longer than expected. Otherwise, I'm happy with the purchase.",
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ReviewModel(
      id: "3",
      userName: "Dara Sovann",
      userImage: "https://i.pravatar.cc/150?u=dara",
      rating: 5.0,
      comment: "The colors are exactly as shown in the pictures. Very comfortable to wear all day long.",
      date: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    ReviewManager().addListener(_onReviewsChanged);
  }

  @override
  void dispose() {
    ReviewManager().removeListener(_onReviewsChanged);
    super.dispose();
  }

  void _onReviewsChanged() {
    if (mounted) setState(() {});
  }

  List<ReviewModel> get _allReviews {
    final localReviews = ReviewManager().getReviews(widget.product['id'].toString());
    return [...localReviews, ..._dummyReviews];
  }

  List<ReviewModel> get _filteredReviews {
    if (_selectedFilter == 0) return _allReviews;
    final targetRating = 6 - _selectedFilter;
    return _allReviews.where((r) => r.rating.toInt() == targetRating).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkMode : AppColor.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final reviews = _filteredReviews;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: TextWidget(
          "Reviews".tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildRatingSummary(isDark),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildFilterChips(isDark),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildReviewCard(reviews[index], isDark),
                childCount: reviews.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(context, isDark),
    );
  }

  Widget _buildRatingSummary(bool isDark) {
    final rating = widget.product['rating'] ?? '4.8';
    final totalReviews = widget.product['reviews'] ?? '24';
    
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              rating.toString(),
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 4),
            TextWidget(
              "{0} reviews".trArgs([totalReviews.toString()]),
              color: isDark ? Colors.white54 : Colors.black54,
              fontSize: 14,
            ),
          ],
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            children: [
              _buildRatingProgressRow("5", 0.8, isDark),
              _buildRatingProgressRow("4", 0.15, isDark),
              _buildRatingProgressRow("3", 0.05, isDark),
              _buildRatingProgressRow("2", 0.0, isDark),
              _buildRatingProgressRow("1", 0.0, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingProgressRow(String label, double progress, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          TextWidget(
            label,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = ["All", "5 Stars", "4 Stars", "3 Stars", "2 Stars", "1 Stars"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilter == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: isSelected 
                  ? AppColor.primaryColor 
                  : (isDark ? Colors.white10 : Colors.grey[100]),
              borderRadius: BorderRadius.circular(20),
              minimumSize: Size.zero,
              onPressed: () => setState(() => _selectedFilter = index),
              child: TextWidget(
                filters[index].tr,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? Colors.white 
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review, bool isDark) {
    final subTextColor = isDark ? Colors.white54 : Colors.black54;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(review.userImage),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      review.userName,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    TextWidget(
                      "${review.date.day}/${review.date.month}/${review.date.year}",
                      fontSize: 12,
                      color: subTextColor,
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star_rounded,
                    color: index < review.rating ? Colors.orange : Colors.grey[300],
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextWidget(
            review.comment,
            fontSize: 14,
            lineHeight: 1.5,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          if (review.images != null && review.images!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(review.images![index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkMode : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 10),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(16),
        onPressed: () async {
          final isLoggedIn = await AuthService.isLoggedIn();
          if (!mounted) return;
          if (!isLoggedIn) {
            Go.to(LoginScreen());
            return;
          }
          if (context.mounted) {
            _showWriteReviewSheet(context);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.pencil_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            TextWidget(
              "Write a Review".tr,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _showWriteReviewSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WriteReviewBottomSheet(
        onSubmit: (rating, comment) {
          final profile = ProfileManager();
          final newReview = ReviewModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userName: profile.name,
            userImage: profile.picture,
            rating: rating,
            comment: comment,
            date: DateTime.now(),
          );
          ReviewManager().addReview(widget.product['id'].toString(), newReview);
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: TextWidget(
                  "Review submitted successfully!".tr,
                  color: Colors.white,
                ),
                backgroundColor: AppColor.successGreen,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}


