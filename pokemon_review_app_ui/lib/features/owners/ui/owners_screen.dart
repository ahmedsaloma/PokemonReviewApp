import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../models/owner.dart';
import '../services/owner_service.dart';
import '../../../shared/widgets/state_widgets.dart';
import '../../../shared/widgets/app_scaffold.dart';

class OwnersScreen extends StatefulWidget {
  const OwnersScreen({super.key});

  @override
  State<OwnersScreen> createState() => _OwnersScreenState();
}

class _OwnersScreenState extends State<OwnersScreen> {
  List<Owner> _owners = [];
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
      final data = await OwnerService.fetchAll(searchTerm: searchTerm);
      setState(() { _owners = data; _loading = false; });
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
        title: const Text('Trainers & Owners'),
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
                hintText: 'Search owners or gyms...',
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
                    : _owners.isEmpty
                        ? const EmptyState(title: 'No owners found', icon: Icons.person)
                        : RefreshIndicator(
                            onRefresh: _load,
                            color: AppColors.primary,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: _owners.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 10),
                              itemBuilder: (_, i) {
                                final owner = _owners[i];
                                return GestureDetector(
                                  onTap: () => context.push('/owners/${owner.id}'),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.card,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: AppColors.primaryDark,
                                          child: Text(
                                            owner.firstName.isNotEmpty ? owner.firstName[0] : '?',
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(owner.fullName,
                                                  style: const TextStyle(
                                                      color: AppColors.textPrimary,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16)),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.sports_kabaddi, size: 14, color: AppColors.textMuted),
                                                  const SizedBox(width: 4),
                                                  Text(owner.gym.isEmpty ? 'Unknown Gym' : owner.gym,
                                                      style: const TextStyle(
                                                          color: AppColors.textMuted, fontSize: 13)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
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
