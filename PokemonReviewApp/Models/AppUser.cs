using Microsoft.AspNetCore.Identity;

namespace PokemonReviewApp.Models
{
    public class AppUser : IdentityUser
    {
        public Reviewer Reviewer { get; set; }
    }
}
