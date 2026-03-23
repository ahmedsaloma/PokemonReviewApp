import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../reviews/services/review_service.dart';
import '../../reviewers/models/reviewer.dart';
import '../../reviewers/services/reviewer_service.dart';
import '../../../shared/widgets/state_widgets.dart';

class AddReviewScreen extends StatefulWidget {
  final int pokemonId;
  const AddReviewScreen({super.key, required this.pokemonId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _textCtrl = TextEditingController();
  int _rating = 5;
  int? _selectedReviewerId;
  List<Reviewer> _reviewers = [];
  bool _saving = false;
  bool _loadingReviewers = true;

  @override
  void initState() {
    super.initState();
    _loadReviewers();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadReviewers() async {
    try {
      final data = await ReviewerService.fetchAll();
      setState(() { _reviewers = data; _loadingReviewers = false; });
    } catch (e) {
      setState(() => _loadingReviewers = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedReviewerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a reviewer'), backgroundColor: Colors.orange));
      return;
    }
    setState(() => _saving = true);
    try {
      await ReviewService.create(
        title: _titleCtrl.text.trim(),
        text: _textCtrl.text.trim(),
        rating: _rating,
        reviewerId: _selectedReviewerId!,
        pokemonId: widget.pokemonId,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted! 🎉'), backgroundColor: AppColors.success));
        context.pop();
      }
    } catch (e) {
      setState(() => _saving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add a Review'),
      ),
      body: _loadingReviewers
          ? const LoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Reviewer',
                        style: TextStyle(
                            color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _selectedReviewerId,
                      dropdownColor: AppColors.card,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(hintText: 'Select reviewer'),
                      items: _reviewers
                          .map((r) => DropdownMenuItem(value: r.id, child: Text(r.fullName)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedReviewerId = v),
                    ),
                    const SizedBox(height: 20),
                    const Text('Title',
                        style: TextStyle(
                            color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(hintText: 'e.g. Amazing Pokémon!'),
                      validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 20),
                    const Text('Your Review',
                        style: TextStyle(
                            color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _textCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      maxLines: 5,
                      decoration: const InputDecoration(hintText: 'Share your thoughts...'),
                      validator: (v) => v == null || v.isEmpty ? 'Review text is required' : null,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text('Rating',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        const Spacer(),
                        const Icon(Icons.star_rounded, color: AppColors.accent, size: 20),
                        const SizedBox(width: 4),
                        Text('$_rating / 10',
                            style: const TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                    Slider(
                      value: _rating.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.card,
                      onChanged: (v) => setState(() => _rating = v.round()),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _submit,
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('Submit Review'),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
