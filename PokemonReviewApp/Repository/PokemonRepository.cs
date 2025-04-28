using Microsoft.EntityFrameworkCore;
using PokemonReviewApp.Data;
using PokemonReviewApp.Interface;
using PokemonReviewApp.Models;

namespace PokemonReviewApp.Repository
{
    public class PokemonRepository : IPokemonRepository
    {
        private readonly DataContext _dataContext;

        public PokemonRepository( DataContext dataContext)
        {
           _dataContext = dataContext;
        }

        public bool CreatePokemon(int ownerId, int categoryId, Pokemon pokemon)
        {
           var pokemonOwner = _dataContext.Owners.Where(o => o.Id == ownerId).FirstOrDefault();
            var category = _dataContext.Categories.Where(c => c.Id == categoryId).FirstOrDefault();

            var PokemonOwner = new PokemonOwner()
            {
                Owner = pokemonOwner,
                Pokemon = pokemon
            };
            _dataContext.Add(PokemonOwner);

            var pokemonCategory = new PokemonCategory()
            {
                Category = category,
                Pokemon = pokemon

            };
            _dataContext.Add(pokemonCategory);
            _dataContext.Add(pokemon);
             return Save();

        }

        public bool DeletePokemon(Pokemon pokemon)
        {
            _dataContext.Remove(pokemon);
            return Save();
        }

        public Pokemon GetPokemon(int id)
        {
           var Pokemon = _dataContext.Pokemon.Where(p => p.Id == id).FirstOrDefault();
           return Pokemon;
        }

        public Pokemon GetPokemon(string name)
        {
            var Pokemon = _dataContext.Pokemon.Where(p => p.Name == name).FirstOrDefault();
            return Pokemon;
        }

        public decimal GetPokemonRating(int pokeId)
        {
            var review = _dataContext.Reviews.Where(p => p.Id == pokeId);

            if (review.Count() <= 0)

            {
                return 0;
            }
            return ((decimal)review.Sum(p => p.Rating)) / review.Count();
        }

        public ICollection<Pokemon> GetPokemons()
        {
          return  _dataContext.Pokemon.OrderBy(P => P.Id).ToList();
        }

        public bool PokemonExists(int pokeId)
        {
            var Pokemon = _dataContext.Pokemon.AsNoTracking().Where(p => p.Id == pokeId).FirstOrDefault();

            return Pokemon != null;
        }

        public bool Save()
        {
            var saved =_dataContext.SaveChanges();
            return saved > 0 ? true : false;
            
        }

        public bool UpdatePokemon( Pokemon pokemon)
        {
            _dataContext.Update(pokemon);
            return Save();
        }
    }
}
