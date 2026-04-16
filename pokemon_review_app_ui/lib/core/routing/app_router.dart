import 'package:go_router/go_router.dart';

// Screens
import '../../features/pokemon/ui/splash_screen.dart';
import '../../features/pokemon/ui/home_screen.dart';
import '../../features/pokemon/ui/pokemon_list_screen.dart';
import '../../features/pokemon/ui/pokemon_detail_screen.dart';
import '../../features/reviews/ui/pokemon_reviews_screen.dart';
import '../../features/reviews/ui/add_review_screen.dart';
import '../../features/categories/ui/categories_screen.dart';
import '../../features/categories/ui/category_pokemon_screen.dart';
import '../../features/owners/ui/owners_screen.dart';
import '../../features/owners/ui/owner_detail_screen.dart';
import '../../features/reviewers/ui/reviewers_screen.dart';
import '../../features/reviewers/ui/reviewer_detail_screen.dart';
import '../../features/countries/ui/countries_screen.dart';
import '../../features/countries/ui/country_detail_screen.dart';
import '../../features/search/ui/global_search_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/register_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      // --- Splash ---
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // --- Auth ---
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // --- Home ---
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const GlobalSearchScreen(),
      ),

      // --- Pokémon ---
      GoRoute(
        path: '/pokemon',
        builder: (context, state) => const PokemonListScreen(),
      ),
      GoRoute(
        path: '/pokemon/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PokemonDetailScreen(pokemonId: id);
        },
      ),
      GoRoute(
        path: '/pokemon/:id/reviews',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PokemonReviewsScreen(pokemonId: id);
        },
      ),
      GoRoute(
        path: '/pokemon/:id/add-review',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AddReviewScreen(pokemonId: id);
        },
      ),

      // --- Categories ---
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/categories/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CategoryPokemonScreen(categoryId: id);
        },
      ),

      // --- Owners ---
      GoRoute(
        path: '/owners',
        builder: (context, state) => const OwnersScreen(),
      ),
      GoRoute(
        path: '/owners/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return OwnerDetailScreen(ownerId: id);
        },
      ),

      // --- Reviewers ---
      GoRoute(
        path: '/reviewers',
        builder: (context, state) => const ReviewersScreen(),
      ),
      GoRoute(
        path: '/reviewers/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ReviewerDetailScreen(reviewerId: id);
        },
      ),

      // --- Countries ---
      GoRoute(
        path: '/countries',
        builder: (context, state) => const CountriesScreen(),
      ),
      GoRoute(
        path: '/countries/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CountryDetailScreen(countryId: id);
        },
      ),
    ],
  );
}
