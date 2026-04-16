import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/pokemon_card.dart';
import '../../owners/models/owner.dart';
import '../../owners/services/owner_service.dart';
import '../../pokemon/models/pokemon.dart';
import '../../pokemon/services/pokemon_service.dart';
import '../../reviewers/models/reviewer.dart';
import '../../reviewers/services/reviewer_service.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _search = TextEditingController();

  Timer? _debounce;
  String _query = '';
  bool _loading = false;
  String? _error;

  List<Pokemon> _pokemons = [];
  List<Owner> _owners = [];
  List<Reviewer> _reviewers = [];

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _searchAll(String rawQuery) async {
    final query = rawQuery.trim();

    if (query.isEmpty) {
      setState(() {
        _query = '';
        _loading = false;
        _error = null;
        _pokemons = [];
        _owners = [];
        _reviewers = [];
      });
      return;
    }

    setState(() {
      _query = query;
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        PokemonService.fetchAll(searchTerm: query),
        OwnerService.fetchAll(searchTerm: query),
        ReviewerService.fetchAll(searchTerm: query),
      ]);

      if (!mounted) return;
      setState(() {
        _pokemons = results[0] as List<Pokemon>;
        _owners = results[1] as List<Owner>;
        _reviewers = results[2] as List<Reviewer>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _searchAll(value);
    });
  }

  int get _totalResults => _pokemons.length + _owners.length + _reviewers.length;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Global Search'),
      ),
      child: RefreshIndicator(
        onRefresh: () => _searchAll(_search.text),
        color: AppColors.primary,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            TextField(
              controller: _search,
              autofocus: true,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search Pokemon, owners, reviewers...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _search.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textMuted),
                        onPressed: () {
                          _search.clear();
                          _searchAll('');
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            if (_query.isEmpty)
              _buildHint()
            else if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 28),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _buildError()
            else if (_totalResults == 0)
              _buildEmpty()
            else ...[
              Text(
                '$_totalResults result(s) for "$_query"',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              if (_pokemons.isNotEmpty) ...[
                _sectionTitle('Pokemon', _pokemons.length),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                const SizedBox(height: 20),
              ],
              if (_owners.isNotEmpty) ...[
                _sectionTitle('Owners', _owners.length),
                const SizedBox(height: 10),
                ..._owners.map(_ownerTile),
                const SizedBox(height: 20),
              ],
              if (_reviewers.isNotEmpty) ...[
                _sectionTitle('Reviewers', _reviewers.length),
                const SizedBox(height: 10),
                ..._reviewers.map(_reviewerTile),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _ownerTile(Owner owner) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/owners/${owner.id}'),
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryDark,
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        owner.fullName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        owner.gym.isEmpty ? 'Unknown gym' : owner.gym,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewerTile(Reviewer reviewer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/reviewers/${reviewer.id}'),
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.info,
                  child: Icon(Icons.rate_review_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    reviewer.fullName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHint() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.tips_and_updates_outlined, color: AppColors.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Type a name to search across Pokemon, owners, and reviewers.',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: AppColors.textMuted),
          SizedBox(height: 8),
          Text(
            'No matches found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Try another keyword.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search failed',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _error ?? 'Unknown error',
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => _searchAll(_search.text),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
