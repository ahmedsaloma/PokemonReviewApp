import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../../../shared/widgets/pokemon_card.dart';
import '../../../shared/widgets/state_widgets.dart';
import '../../../shared/widgets/app_scaffold.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List<Pokemon> _all = [];
  List<Pokemon> _filtered = [];
  bool _loading = true;
  String? _error;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await PokemonService.fetchAll();
      setState(() { _all = data; _filtered = data; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = _all
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('All Pokémon'),
      ),
      child: _loading
          ? const LoadingIndicator()
          : _error != null
              ? ErrorDisplay(message: _error!, onRetry: _load)
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: TextField(
                        controller: _search,
                        onChanged: _onSearch,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search Pokémon...',
                          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                          suffixIcon: _search.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: AppColors.textMuted),
                                  onPressed: () {
                                    _search.clear();
                                    _onSearch('');
                                  })
                              : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _filtered.isEmpty
                          ? const EmptyState(
                              title: 'No Pokémon found',
                              subtitle: 'Try a different name',
                              icon: Icons.catching_pokemon)
                          : RefreshIndicator(
                              onRefresh: _load,
                              color: AppColors.primary,
                              child: GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: _filtered.length,
                                itemBuilder: (_, i) => PokemonCard(
                                  pokemon: _filtered[i],
                                  onTap: () => context.push('/pokemon/${_filtered[i].id}'),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}
