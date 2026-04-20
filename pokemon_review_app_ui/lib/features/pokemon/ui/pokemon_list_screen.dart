import 'dart:async';
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
  List<Pokemon> _pokemons = [];
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
      final data = await PokemonService.fetchAll(searchTerm: searchTerm);
      setState(() { _pokemons = data; _loading = false; });
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
        backgroundColor: AppColors.background,
        title: const Text('All Pokémon'),
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
                hintText: 'Search Pokémon...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _search.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textMuted),
                        onPressed: () {
                          _search.clear();
                          _load();
                        })
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
                    : _pokemons.isEmpty
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
                              itemCount: _pokemons.length,
                              itemBuilder: (_, i) => PokemonCard(
                                pokemon: _pokemons[i],
                                onTap: () => context.push('/pokemon/${_pokemons[i].id}'),
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
