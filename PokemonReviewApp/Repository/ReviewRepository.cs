using Microsoft.EntityFrameworkCore;
using PokemonReviewApp.Data;
using PokemonReviewApp.Interface;
using PokemonReviewApp.Models;

namespace PokemonReviewApp.Repository
{
    public class ReviewRepository : IReviewRepository
    {
        private readonly DataContext _dataContext;

        public ReviewRepository(DataContext dataContext)
        {
            _dataContext = dataContext;
        }

        public bool CreateReview(Review review)
        {
            _dataContext.Add(review);
            return save();
        }

        public bool DeleteReview(Review review)
        {
            _dataContext.Remove(review);
            return save();
        }

        public bool DeleteReviews(List<Review> reviews)
        {
            _dataContext.RemoveRange(reviews);
            return save();
        }

        public Review GetReview(int reviewId)
        {
            return _dataContext.Reviews.Where(r => r.Id == reviewId).FirstOrDefault();
            
        }

        public ICollection<Review> GetReviews()
        {
            return _dataContext.Reviews.ToList();
        }

        public ICollection<Review> GetReviewsOfAPokemon(int pokeId)
        {
            var reviews = _dataContext.Reviews.Where(r => r.Pokemon.Id == pokeId).ToList(); 
            return reviews;
            
        }

        public bool ReviewExists(int reviewId)
        {
            return _dataContext.Reviews.Any(r  => r.Id == reviewId);    
        }

        public bool save()
        {
            var saved = _dataContext.SaveChanges();
            return saved > 0 ? true : false;
        }

        public bool UpdateReview(Review review)
        {
            _dataContext.Update(review);
            return save();
        }
    }
}
