import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../features/pokemon/models/pokemon.dart';
import '../../../features/categories/models/category.dart';
import '../../../features/pokemon/services/pokemon_service.dart';
import '../../../features/categories/services/category_service.dart';
import '../../../features/countries/models/country.dart';
import '../../../features/countries/services/country_service.dart';
import '../../../shared/widgets/pokemon_card.dart';
import '../../../shared/widgets/state_widgets.dart';
import '../../../shared/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pokemon> _pokemon = [];
  List<Category> _categories = [];
  List<Country> _countries = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        PokemonService.fetchAll(),
        CategoryService.fetchAll(),
        CountryService.fetchAll(),
      ]);
      setState(() {
        _pokemon = results[0] as List<Pokemon>;
        _categories = results[1] as List<Category>;
        _countries = results[2] as List<Country>;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SafeArea(
        child: _loading
            ? const LoadingIndicator()
            : _error != null
                ? ErrorDisplay(message: _error!, onRetry: _loadData)
                : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final featured = _pokemon.take(5).toList();
    final all = _pokemon.take(12).toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      backgroundColor: AppColors.card,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          if (_categories.isNotEmpty) SliverToBoxAdapter(child: _buildCategories()),
          if (_countries.isNotEmpty) SliverToBoxAdapter(child: _buildCountries()),
          SliverToBoxAdapter(child: _buildSectionTitle('Featured Pokémon', '/pokemon')),
          SliverToBoxAdapter(child: _buildFeaturedCarousel(featured)),
          SliverToBoxAdapter(child: _buildSectionTitle('All Pokémon', '/pokemon')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => PokemonCard(
                  pokemon: all[i],
                  onTap: () => context.push('/pokemon/${all[i].id}'),
                ),
                childCount: all.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hey, Trainer! 👋',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                const SizedBox(height: 4),
                const Text('PokéReview',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (mounted) context.go('/login');
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.push('/search'),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Categories',
                  style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => context.go('/categories'),
                child: const Text('See all',
                    style: TextStyle(color: AppColors.primary, fontSize: 13)),
              )
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = _categories[i];
              final color = AppColors.typeColor(cat.name);
              return GestureDetector(
                onTap: () => context.push('/categories/${cat.id}'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.4)),
                  ),
                  child: Text(cat.name,
                      style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCountries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Regions',
                  style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => context.push('/countries'),
                child: const Text('See all',
                    style: TextStyle(color: AppColors.primary, fontSize: 13)),
              )
            ],
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _countries.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final country = _countries[i];
              return GestureDetector(
                onTap: () => context.push('/countries/${country.id}'),
                child: Container(
                  width: 130,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          country.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String route) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => context.go(route),
            child: const Text('See all',
                style: TextStyle(color: AppColors.primary, fontSize: 13)),
          )
        ],
      ),
    );
  }

  Widget _buildFeaturedCarousel(List<Pokemon> featured) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: featured.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => SizedBox(
          width: 140,
          child: PokemonCard(
            pokemon: featured[i],
            onTap: () => context.push('/pokemon/${featured[i].id}'),
          ),
        ),
      ),
    );
  }
}
