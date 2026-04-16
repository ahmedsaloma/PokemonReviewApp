using Microsoft.EntityFrameworkCore;
using PokemonReviewApp.Data;
using PokemonReviewApp.Interface;
using PokemonReviewApp.Models;

namespace PokemonReviewApp.Repository
{
    public class ReviewerRepository : IReviewerRepository
    {
        private readonly DataContext _dataContext;

        public ReviewerRepository(DataContext dataContext)
        {
            _dataContext = dataContext;
        }

        public bool DeleteReviewer(Reviewer reviewer)
        {
            _dataContext.Remove(reviewer);
            return Save();
        }

        public Reviewer GetReviewer(int reviewerId)
        {
            return _dataContext.Reviewers.Where(r => r.Id == reviewerId).FirstOrDefault();
        }

        public Reviewer GetReviewerByAppUserId(string appUserId)
        {
            return _dataContext.Reviewers.Where(r => r.AppUserId == appUserId).FirstOrDefault();
        }

        public ICollection<Reviewer> GetReviewers(string? searchTerm = null)
        {
            var query = _dataContext.Reviewers.AsQueryable();

            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                var term = searchTerm.Trim();
                query = query.Where(r =>
                    r.FirstName.Contains(term) ||
                    r.LastName.Contains(term) ||
                    (r.FirstName + " " + r.LastName).Contains(term));
            }

            return query.OrderBy(r => r.Id).ToList();
        }

        public ICollection<Review> GetReviewsByReviewer(int reviewerId)
        {
            return _dataContext.Reviews.Where(r => r.Reviewer.Id == reviewerId).ToList();   
        }

        public bool ReviewerExists(int reviewerId)
        {
           return _dataContext.Reviewers.Any(r => r.Id == reviewerId);  
        }

        public bool Save()
        {
            var saved = _dataContext.SaveChanges();
            return saved > 0 ? true : false;
        }

        public bool UpdateReviewer(Reviewer reviewer)
        {
           _dataContext.Update(reviewer);
            return Save();
        }
    }
}
