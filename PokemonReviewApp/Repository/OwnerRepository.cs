using Microsoft.EntityFrameworkCore;
using PokemonReviewApp.Data;
using PokemonReviewApp.Interface;
using PokemonReviewApp.Models;

namespace PokemonReviewApp.Repository
{
    public class OwnerRepository : IOwnerRepository
    {
        private readonly DataContext _dataContext;

        public OwnerRepository(DataContext dataContext)
        {
            _dataContext = dataContext;
        }

        public bool CreateOwner(Owner owner)
        {
            _dataContext.Owners.Add(owner);
            return Save();
        }

        public bool DeleteOwner(Owner owner)
        {
            _dataContext.Remove(owner);
            return Save();
        }

        public Owner GetOwner(int ownerId)
        {
            return _dataContext.Owners.Where(p => p.Id == ownerId).FirstOrDefault();
        }

        public ICollection<Owner> GetOwnerOfAPokemon(int pokeId)
        {
            var owners = _dataContext.PokemonOwners.Where(p => p.PokemonId == pokeId).Select(p => p.Owner); 
            return owners.ToList();
        }

        public ICollection<Owner> GetOwners(string? searchTerm = null)
        {
            var query = _dataContext.Owners.AsQueryable();

            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                var term = searchTerm.Trim();
                query = query.Where(o =>
                    o.FirstName.Contains(term) ||
                    o.LastName.Contains(term) ||
                    o.Gym.Contains(term) ||
                    (o.FirstName + " " + o.LastName).Contains(term));
            }

            return query.OrderBy(o => o.Id).ToList();
        }

        public ICollection<Pokemon> GetPokemonByOwner(int ownerId)
        {
            var pokemons = _dataContext.PokemonOwners.Where(p => p.OwnerId == ownerId).Select(p => p.Pokemon);
            return pokemons.ToList();
        }

        public bool OwnerExists(int ownerId)
        {
            return _dataContext.Owners.AsNoTracking().Any(p => p.Id == ownerId);
        }

        public bool Save()
        {
            var saved = _dataContext.SaveChanges();
            return saved > 0 ? true : false;
        }

        public bool UpdateOwner(Owner owner)
        {
            _dataContext.Update(owner);
            return Save();
        }
    }
}
