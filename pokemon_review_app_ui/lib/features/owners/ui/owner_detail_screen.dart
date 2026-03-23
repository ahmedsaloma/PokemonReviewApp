import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../models/owner.dart';
import '../services/owner_service.dart';
import '../../pokemon/models/pokemon.dart';
import '../../../shared/widgets/pokemon_card.dart';
import '../../../shared/widgets/state_widgets.dart';

class OwnerDetailScreen extends StatefulWidget {
  final int ownerId;
  const OwnerDetailScreen({super.key, required this.ownerId});

  @override
  State<OwnerDetailScreen> createState() => _OwnerDetailScreenState();
}

class _OwnerDetailScreenState extends State<OwnerDetailScreen> {
  Owner? _owner;
  List<Pokemon> _pokemon = [];
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
        OwnerService.fetchById(widget.ownerId),
        OwnerService.fetchOwnerPokemon(widget.ownerId),
      ]);
      setState(() {
        _owner = results[0] as Owner;
        _pokemon = results[1] as List<Pokemon>;
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
        title: Text(_owner?.fullName ?? 'Trainer'),
      ),
      body: _loading
          ? const LoadingIndicator()
          : _error != null
              ? ErrorDisplay(message: _error!, onRetry: _load)
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final o = _owner!;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark.withValues(alpha: 0.6), AppColors.card],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryDark,
                  child: Text(
                    o.firstName.isNotEmpty ? o.firstName[0] : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.fullName,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.sports_kabaddi, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(o.gym.isEmpty ? 'Unknown Gym' : o.gym,
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.catching_pokemon, size: 14, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text('${_pokemon.length} Pokémon owned',
                              style: const TextStyle(color: AppColors.accent, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Text('Pokémon Collection',
                    style: TextStyle(
                        color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${_pokemon.length}',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        _pokemon.isEmpty
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: const EmptyState(
                      title: 'No Pokémon yet',
                      subtitle: 'This trainer has no Pokémon.',
                      icon: Icons.catching_pokemon),
                ))
            : SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => PokemonCard(
                      pokemon: _pokemon[i],
                      onTap: () => context.push('/pokemon/${_pokemon[i].id}'),
                    ),
                    childCount: _pokemon.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                ),
              ),
      ],
    );
  }
}
