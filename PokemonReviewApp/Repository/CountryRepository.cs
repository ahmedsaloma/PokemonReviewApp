using Microsoft.EntityFrameworkCore;
using PokemonReviewApp.Data;
using PokemonReviewApp.Interface;
using PokemonReviewApp.Models;

namespace PokemonReviewApp.Repository
{
    public class CountryRepository : ICountryRepository
    {
        private readonly DataContext _dataContext;

        public CountryRepository(DataContext dataContext)
        {
            _dataContext = dataContext;
        }
        public bool CountryExists(int id)
        {
           var country = _dataContext.Countries.AsNoTracking().Where(p => p.Id == id).FirstOrDefault();
            return country != null;
        }

        public bool CreateCountry(Country country)
        {
            _dataContext.Countries.Add(country);
            return Save();
        }

        public bool DeleteCountry(Country country)
        {
            _dataContext.Remove(country);
            return Save();
        }

        public ICollection<Country> GetCountries()
        {
            return _dataContext.Countries.ToList();
        }

        public Country GetCountry(int id)
        {
            return _dataContext.Countries.Where(p => p.Id == id).FirstOrDefault();
        }

        public Country GetCountryByOwner(int ownerId)
        {
            return _dataContext.Owners.Where(p => p.Id == ownerId).Select(e => e.Country).FirstOrDefault();
        }

        public ICollection<Owner> GetOwnersFromACountry(int countryId)
        {
            var owners =  _dataContext.Owners.Where(p => p.Country.Id == countryId).ToList();
            return owners;
            
        }

        public bool Save()
        {
           var saved =  _dataContext.SaveChanges();
           return saved > 0 ? true : false;

        }

        public bool UpdateCountry(Country country)
        {
           _dataContext.Update(country);
            return Save();
        }
    }
}
