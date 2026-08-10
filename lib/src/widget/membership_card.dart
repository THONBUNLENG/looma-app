import 'package:flutter/material.dart';
import '../network/datastor/membership_service.dart';
import 'text_widget.dart';

class MembershipCard extends StatelessWidget {
  final MemberLevel level;
  final String membershipId;
  final double totalSpent;
  final VoidCallback? onTap;

  const MembershipCard({
    super.key,
    required this.level,
    required this.membershipId,
    required this.totalSpent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColors(),
          ),
          boxShadow: [
            BoxShadow(
              color: level.color.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background patterns
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "LOOMA GROUP",
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withValues(alpha: 0.8),
                            letterSpacing: 2,
                          ),
                          const SizedBox(height: 4),
                          TextWidget(
                            level.label,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      _getLevelIcon(),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "Membership ID",
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          TextWidget(
                            membershipId,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextWidget(
                            totalSpent > 0 ? "Total Spent" : "Status",
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          TextWidget(
                            totalSpent > 0 
                                ? "\$${totalSpent.toStringAsFixed(2)}"
                                : "No Purchase",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            if (onTap != null)
              Positioned(
                right: 12,
                bottom: 12,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Color> _getGradientColors() {
    switch (level) {
      case MemberLevel.online:
        return [const Color(0xFFD9904D), const Color(0xFFB36B2B)];
      case MemberLevel.silver:
        return [const Color(0xFF8E8E93), const Color(0xFF636366)];
      case MemberLevel.gold:
        return [const Color(0xFFFBC02D), const Color(0xFFF9A825)];
      case MemberLevel.platinum:
        return [const Color(0xFF2C2C2E), Colors.black];
    }
  }

  Widget _getLevelIcon() {
    IconData icon;
    switch (level) {
      case MemberLevel.online:
        icon = Icons.language;
        break;
      case MemberLevel.silver:
        icon = Icons.workspace_premium;
        break;
      case MemberLevel.gold:
        icon = Icons.stars;
        break;
      case MemberLevel.platinum:
        icon = Icons.diamond;
        break;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
