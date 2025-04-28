using Microsoft.EntityFrameworkCore;
using PokemonReviewApp.Data;
using PokemonReviewApp.Interface;
using PokemonReviewApp.Models;

namespace PokemonReviewApp.Repository
{
    public class CategoryRepository : ICategoryRepository
    {
        private readonly DataContext _dataContext;

        public CategoryRepository(DataContext dataContext)
        {
            _dataContext = dataContext;
        }
        public bool CategoryExists(int id)
        {
            var category = _dataContext.Categories.AsNoTracking().Where(p => p.Id == id).FirstOrDefault();
            return category != null;
            
        }

        public ICollection<Category> GetCategories()
        {
            var categories = _dataContext.Categories.ToList();
            return categories;

        }

        public Category GetCategory(int id)
        {
            var category = _dataContext.Categories.Where(p => p.Id == id).FirstOrDefault();
            return category;
        }

        public ICollection<Pokemon> GetPokemonByCategory(int categoryId)
        {
            var pokemons = _dataContext.PokemonCategories.Where(p => p.CategoryId == categoryId).Select(e => e.Pokemon).ToList();
            return pokemons;

        }

        public bool CreateCategory(Category category)
        {
            _dataContext.Categories.Add(category);
            return Save();
        }

        public bool Save()
        {
            var saved = _dataContext.SaveChanges();
            return saved > 0 ? true : false;
        }

        public bool UpdateCategory(Category category)
        {
           _dataContext.Update(category);
            return Save();
        }

        public bool DeleteCategory(Category category)
        {
            _dataContext.Remove(category);
            return Save();
        }
    }


}
