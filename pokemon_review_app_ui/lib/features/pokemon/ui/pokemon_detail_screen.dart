import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../../../shared/widgets/state_widgets.dart';

class PokemonDetailScreen extends StatefulWidget {
  final int pokemonId;
  const PokemonDetailScreen({super.key, required this.pokemonId});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  Pokemon? _pokemon;
  double? _rating;
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
        PokemonService.fetchById(widget.pokemonId),
        PokemonService.fetchRating(widget.pokemonId),
      ]);
      setState(() {
        _pokemon = results[0] as Pokemon;
        _rating = results[1] as double;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  String get _spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemonId}.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading
          ? const LoadingIndicator()
          : _error != null
              ? ErrorDisplay(message: _error!, onRetry: _load)
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final p = _pokemon!;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppColors.primaryDark,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(p.name,
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primaryDark, AppColors.background],
                ),
              ),
              child: Center(
                child: Image.network(
                  _spriteUrl,
                  height: 200,
                  errorBuilder: (_, _a, _b) =>
                      const Icon(Icons.catching_pokemon, size: 100, color: AppColors.primary),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.rate_review_outlined, color: AppColors.accent),
              onPressed: () => context.push('/pokemon/${p.id}/add-review'),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Row
                Row(
                  children: [
                    _statChip(Icons.tag, '#${p.id.toString().padLeft(3, '0')}', AppColors.info),
                    const SizedBox(width: 10),
                    _statChip(Icons.star_rounded, _rating != null ? _rating!.toStringAsFixed(1) : 'N/A', AppColors.accent),
                    const SizedBox(width: 10),
                    _statChip(Icons.cake_outlined, _formatDate(p.birthDate), AppColors.success),
                  ],
                ),
                const SizedBox(height: 24),
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/pokemon/${p.id}/reviews'),
                        icon: const Icon(Icons.reviews_outlined),
                        label: const Text('View Reviews'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.push('/pokemon/${p.id}/add-review'),
                        icon: const Icon(Icons.add, color: AppColors.accent),
                        label: const Text('Add Review',
                            style: TextStyle(color: AppColors.accent)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.accent),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.black12),
                const SizedBox(height: 8),
                const Text('About',
                    style: TextStyle(
                        color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _infoRow('Name', p.name),
                _infoRow('Pokédex No.', '#${p.id.toString().padLeft(3, '0')}'),
                _infoRow('Birthday', _formatDate(p.birthDate)),
                _infoRow('Rating', _rating != null ? '${_rating!.toStringAsFixed(1)} / 10' : 'Not rated yet'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          )
        ],
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
