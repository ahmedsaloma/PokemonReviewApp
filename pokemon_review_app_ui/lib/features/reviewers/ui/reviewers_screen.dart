import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../models/reviewer.dart';
import '../services/reviewer_service.dart';
import '../../../shared/widgets/state_widgets.dart';
import '../../../shared/widgets/app_scaffold.dart';

class ReviewersScreen extends StatefulWidget {
  const ReviewersScreen({super.key});

  @override
  State<ReviewersScreen> createState() => _ReviewersScreenState();
}

class _ReviewersScreenState extends State<ReviewersScreen> {
  List<Reviewer> _reviewers = [];
  bool _loading = true;
  String? _error;
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load({String? searchTerm}) async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await ReviewerService.fetchAll(searchTerm: searchTerm);
      setState(() { _reviewers = data; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _onSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _load(searchTerm: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Reviewers'),
      ),
      child: Column(
        children: [
          // 🔍 Search Bar (Stay here always to keep focus)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _search,
              onChanged: _onSearch,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search reviewers...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _search.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textMuted),
                        onPressed: () {
                          _search.clear();
                          _load();
                        },
                      )
                    : null,
              ),
            ),
          ),
          
          // 📋 Results, Loading, or Error
          Expanded(
            child: _loading
                ? const LoadingIndicator()
                : _error != null
                    ? ErrorDisplay(message: _error!, onRetry: _load)
                    : _reviewers.isEmpty
                        ? const EmptyState(title: 'No reviewers yet', icon: Icons.rate_review)
                        : RefreshIndicator(
                            onRefresh: _load,
                            color: AppColors.primary,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: _reviewers.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 10),
                              itemBuilder: (_, i) {
                                final r = _reviewers[i];
                                final colors = [
                                  AppColors.info, AppColors.success, AppColors.warning,
                                  AppColors.primary, const Color(0xFFB967CE)
                                ];
                                final color = colors[i % colors.length];
                                return GestureDetector(
                                  onTap: () => context.push('/reviewers/${r.id}'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.card,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: color.withValues(alpha: 0.2),
                                          child: Text(
                                            r.firstName.isNotEmpty ? r.firstName[0] : '?',
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(r.fullName,
                                                  style: const TextStyle(
                                                      color: AppColors.textPrimary,
                                                      fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 3),
                                              const Text('Tap to see reviews',
                                                  style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: color.withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.rate_review_rounded, color: color, size: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
