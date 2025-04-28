using PokemonReviewApp.Models;

namespace PokemonReviewApp.Interface
{
    public interface IReviewerRepository
    {
        ICollection<Reviewer> GetReviewers();
        Reviewer GetReviewer(int reviewerId);
        ICollection<Review> GetReviewsByReviewer(int reviewerId);
        bool UpdateReviewer(Reviewer reviewer);
        bool DeleteReviewer(Reviewer reviewer);
        bool ReviewerExists(int reviewerId);

        bool Save();
    }
}
