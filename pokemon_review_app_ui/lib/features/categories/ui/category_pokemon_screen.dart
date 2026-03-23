import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../pokemon/models/pokemon.dart';
import '../../categories/services/category_service.dart';
import '../../../shared/widgets/pokemon_card.dart';
import '../../../shared/widgets/state_widgets.dart';

class CategoryPokemonScreen extends StatefulWidget {
  final int categoryId;
  const CategoryPokemonScreen({super.key, required this.categoryId});

  @override
  State<CategoryPokemonScreen> createState() => _CategoryPokemonScreenState();
}

class _CategoryPokemonScreenState extends State<CategoryPokemonScreen> {
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
      final data = await CategoryService.fetchPokemonByCategory(widget.categoryId);
      setState(() { _pokemon = data; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pokémon by Type'),
      ),
      body: _loading
          ? const LoadingIndicator()
          : _error != null
              ? ErrorDisplay(message: _error!, onRetry: _load)
              : _pokemon.isEmpty
                  ? const EmptyState(
                      title: 'No Pokémon in this type',
                      icon: Icons.catching_pokemon)
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _pokemon.length,
                      itemBuilder: (_, i) => PokemonCard(
                        pokemon: _pokemon[i],
                        onTap: () => context.push('/pokemon/${_pokemon[i].id}'),
                      ),
                    ),
    );
  }
}
