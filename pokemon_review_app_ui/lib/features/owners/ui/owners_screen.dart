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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await OwnerService.fetchAll();
      setState(() { _owners = data; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Trainers & Owners'),
      ),
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
    );
  }
}
