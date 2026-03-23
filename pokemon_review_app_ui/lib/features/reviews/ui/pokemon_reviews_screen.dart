import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../reviews/models/review.dart';
import '../../reviews/services/review_service.dart';
import '../../../shared/widgets/review_card.dart';
import '../../../shared/widgets/state_widgets.dart';

class PokemonReviewsScreen extends StatefulWidget {
  final int pokemonId;
  const PokemonReviewsScreen({super.key, required this.pokemonId});

  @override
  State<PokemonReviewsScreen> createState() => _PokemonReviewsScreenState();
}

class _PokemonReviewsScreenState extends State<PokemonReviewsScreen> {
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
      final data = await ReviewService.fetchByPokemon(widget.pokemonId);
      setState(() { _reviews = data; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _delete(int reviewId) async {
    try {
      await ReviewService.delete(reviewId);
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e'), backgroundColor: Colors.red));
    }
  }

  double get _avgRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) / _reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reviews'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.accent),
            onPressed: () => context.push('/pokemon/${widget.pokemonId}/add-review'),
          )
        ],
      ),
      body: _loading
          ? const LoadingIndicator()
          : _error != null
              ? ErrorDisplay(message: _error!, onRetry: _load)
              : Column(
                  children: [
                    if (_reviews.isNotEmpty) _buildSummaryCard(),
                    Expanded(
                      child: _reviews.isEmpty
                          ? const EmptyState(
                              title: 'No reviews yet',
                              subtitle: 'Be the first to review this Pokémon!',
                              icon: Icons.rate_review_outlined)
                          : RefreshIndicator(
                              onRefresh: _load,
                              color: AppColors.primary,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _reviews.length,
                                itemBuilder: (_, i) => ReviewCard(
                                  review: _reviews[i],
                                  onDelete: () => _delete(_reviews[i].id),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/pokemon/${widget.pokemonId}/add-review'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Review'),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.3), AppColors.card],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Average Rating',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.accent, size: 28),
                  const SizedBox(width: 6),
                  Text(
                    _avgRating.toStringAsFixed(1),
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(' / 10',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                ],
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Total Reviews', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              Text('${_reviews.length}',
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}
