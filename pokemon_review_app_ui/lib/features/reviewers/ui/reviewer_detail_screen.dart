import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/reviewer.dart';
import '../services/reviewer_service.dart';
import '../../reviews/models/review.dart';
import '../../reviews/services/review_service.dart';
import '../../../shared/widgets/review_card.dart';
import '../../../shared/widgets/state_widgets.dart';

class ReviewerDetailScreen extends StatefulWidget {
  final int reviewerId;
  const ReviewerDetailScreen({super.key, required this.reviewerId});

  @override
  State<ReviewerDetailScreen> createState() => _ReviewerDetailScreenState();
}

class _ReviewerDetailScreenState extends State<ReviewerDetailScreen> {
  Reviewer? _reviewer;
  List<Review> _reviews = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        ReviewerService.fetchById(widget.reviewerId),
        ReviewService.fetchByReviewer(widget.reviewerId),
      ]);
      setState(() {
        _reviewer = results[0] as Reviewer;
        _reviews = results[1] as List<Review>;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_reviewer?.fullName ?? 'Reviewer'),
      ),
      body: _loading
          ? const LoadingIndicator()
          : _error != null
              ? ErrorDisplay(message: _error!, onRetry: _load)
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final r = _reviewer!;
    return Column(
      children: [
        // Profile Header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.info.withValues(alpha: 0.3), AppColors.card],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.info.withValues(alpha: 0.2),
                child: Text(r.firstName.isNotEmpty ? r.firstName[0] : '?',
                    style: const TextStyle(color: AppColors.info, fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.fullName,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.rate_review, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text('${_reviews.length} reviews written',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('Their Reviews',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _reviews.isEmpty
              ? const EmptyState(
                  title: 'No reviews yet',
                  subtitle: 'This reviewer hasn\'t written anything yet.',
                  icon: Icons.rate_review_outlined)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _reviews.length,
                  itemBuilder: (_, i) => ReviewCard(review: _reviews[i]),
                ),
        ),
      ],
    );
  }
}
