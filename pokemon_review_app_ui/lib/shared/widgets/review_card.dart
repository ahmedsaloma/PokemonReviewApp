import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/reviews/models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onDelete;

  const ReviewCard({super.key, required this.review, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.title,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _ratingColor(review.rating).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: _ratingColor(review.rating)),
                    const SizedBox(width: 4),
                    Text(
                      '${review.rating}',
                      style: TextStyle(
                          color: _ratingColor(review.rating),
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: AppColors.textMuted, size: 20),
                  padding: const EdgeInsets.only(left: 8),
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.text,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Color _ratingColor(int rating) {
    if (rating >= 8) return AppColors.success;
    if (rating >= 5) return AppColors.warning;
    return Colors.redAccent;
  }
}
