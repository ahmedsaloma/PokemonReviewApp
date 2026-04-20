using Microsoft.AspNetCore.Identity;
using PokemonReviewApp.Data;
using PokemonReviewApp.Models;

namespace PokemonReviewApp
{
    public class Seed
    {
        private readonly DataContext dataContext;
        private readonly IServiceProvider _serviceProvider;

        public Seed(DataContext context, IServiceProvider serviceProvider)
        {
            this.dataContext = context;
            _serviceProvider = serviceProvider;
        }

        public void SeedDataContext()
        {
            if (!dataContext.PokemonOwners.Any())
            {
                // 1. Define distinct Countries (No duplicates!)
                var kanto = new Country() { Name = "Kanto" };
                var johto = new Country() { Name = "Johto" };
                var saffronCity = new Country() { Name = "Saffron City" };
                var milletTown = new Country() { Name = "Millet Town" };

                // 2. Define distinct Categories (No duplicates!)
                var typeElectric = new Category() { Name = "Electric" };
                var typeWater = new Category() { Name = "Water" };
                var typeLeaf = new Category() { Name = "Leaf" };
                var typeFire = new Category() { Name = "Fire" };
                var typeFlying = new Category() { Name = "Flying" };
                var typePoison = new Category() { Name = "Poison" };
                var typePsychic = new Category() { Name = "Psychic" };
                var typeFighting = new Category() { Name = "Fighting" };
                var typeGhost = new Category() { Name = "Ghost" };
                var typeNormal = new Category() { Name = "Normal" };

                // 3. Define distinct Reviewers for the base Pokemon to prevent duplicate accounts!
                var teddy = new Reviewer() { FirstName = "Teddy", LastName = "Smith" };
                var taylor = new Reviewer() { FirstName = "Taylor", LastName = "Jones" };
                var jessica = new Reviewer() { FirstName = "Jessica", LastName = "McGregor" };

                var pokemonOwners = new List<PokemonOwner>()
                {
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Pikachu",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png",
                            BirthDate = new DateTime(1903,1,1),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeElectric } },
                            Reviews = new List<Review>()
                            {
                                new Review { Title="Pikachu",Text = "Pikachu is the best pokemon, because it is electric", Rating = 5, Reviewer = teddy },
                                new Review { Title="Pikachu", Text = "Pikachu is the best a killing rocks", Rating = 5, Reviewer = taylor },
                                new Review { Title="Pikachu",Text = "Pikachu, pikachu, pikachu", Rating = 1, Reviewer = jessica },
                            }
                        },
                        Owner = new Owner() { FirstName = "Jack", LastName = "London", Gym = "Brocks Gym", Country = kanto }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Squirtle",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png",
                            BirthDate = new DateTime(1903,1,1),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeWater } },
                            Reviews = new List<Review>()
                            {
                                new Review { Title= "Squirtle", Text = "squirtle is the best pokemon, because it is water", Rating = 5, Reviewer = teddy },
                                new Review { Title= "Squirtle",Text = "Squirtle is the best a killing rocks", Rating = 5, Reviewer = taylor },
                                new Review { Title= "Squirtle", Text = "squirtle, squirtle, squirtle", Rating = 1, Reviewer = jessica },
                            }
                        },
                        Owner = new Owner() { FirstName = "Harry", LastName = "Potter", Gym = "Mistys Gym", Country = saffronCity }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Venasuar",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png",
                            BirthDate = new DateTime(1903,1,1),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeLeaf } },
                            Reviews = new List<Review>()
                            {
                                new Review { Title="Venasaur",Text = "Venasaur is the best pokemon, because it is leaf", Rating = 5, Reviewer = teddy },
                                new Review { Title="Venasaur",Text = "Venasuar is the best a killing rocks", Rating = 5, Reviewer = taylor },
                                new Review { Title="Venasaur",Text = "Venasaur, Venasaur, Venasaur", Rating = 1, Reviewer = jessica },
                            }
                        },
                        Owner = new Owner() { FirstName = "Ash", LastName = "Ketchum", Gym = "Ashs Gym", Country = milletTown }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Charizard",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png",
                            BirthDate = new DateTime(1996,2,27),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeFire } },
                            Reviews = new List<Review>() { new Review { Title="Charizard", Text="Powerful fire attacks!", Rating=5, Reviewer = new Reviewer() { FirstName="Gary", LastName="Oak" } } }
                        },
                        Owner = new Owner() { FirstName="Gary", LastName="Oak", Gym="Viridian Gym", Country = kanto }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Blastoise",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/9.png",
                            BirthDate = new DateTime(1996,2,27),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeWater } },
                            Reviews = new List<Review>() { new Review { Title="Blastoise", Text="Great defense and water cannons.", Rating=4, Reviewer = new Reviewer() { FirstName="Blue", LastName="Rival" } } }
                        },
                        Owner = new Owner() { FirstName="Blue", LastName="Rival", Gym="Pallet Gym", Country = kanto }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Pidgeot",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/18.png",
                            BirthDate = new DateTime(1996,2,27),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeFlying } },
                            Reviews = new List<Review>() { new Review { Title="Fast", Text="Incredibly fast pokemon.", Rating=4, Reviewer = new Reviewer() { FirstName="Falkner", LastName="Bird" } } }
                        },
                        Owner = new Owner() { FirstName="Falkner", LastName="Bird", Gym="Violet Gym", Country = johto }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Raichu",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/26.png",
                            BirthDate = new DateTime(1996,2,27),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeElectric } },
                            Reviews = new List<Review>() { new Review { Title="Superior", Text="Better than Pikachu in stats.", Rating=4, Reviewer = new Reviewer() { FirstName="Lt", LastName="Surge" } } }
                        },
                        Owner = new Owner() { FirstName="Lt", LastName="Surge", Gym="Vermilion Gym", Country = kanto }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Nidoking",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/34.png",
                            BirthDate = new DateTime(1996,2,27),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typePoison } },
                            Reviews = new List<Review>() { new Review { Title="Strong", Text="Very bulky and strong.", Rating=5, Reviewer = new Reviewer() { FirstName="Giovanni", LastName="Boss" } } }
                        },
                        Owner = new Owner() { FirstName="Giovanni", LastName="Boss", Gym="Viridian Gym", Country = kanto }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Ninetales",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/38.png",
                            BirthDate = new DateTime(1996,2,27),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeFire } },
                            Reviews = new List<Review>() { new Review { Title="Beautiful", Text="Very majestic.", Rating=5, Reviewer = new Reviewer() { FirstName="Blaine", LastName="Quiz" } } }
                        },
                        Owner = new Owner() { FirstName="Blaine", LastName="Quiz", Gym="Cinnabar Gym", Country = kanto }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Alakazam",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/65.png",
                            BirthDate = new DateTime(1996,2,27),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typePsychic } },
                            Reviews = new List<Review>() { new Review { Title="Smart", Text="IQ over 5000.", Rating=5, Reviewer = new Reviewer() { FirstName="Sabrina", LastName="Psychic" } } }
                        },
                        Owner = new Owner() { FirstName="Sabrina", LastName="Psychic", Gym="Saffron Gym", Country = kanto }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Machamp",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/68.png",
                            BirthDate = new DateTime(1996,2,27),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeFighting } },
                            Reviews = new List<Review>() { new Review { Title="Beast", Text="Can punch a mountain.", Rating=5, Reviewer = new Reviewer() { FirstName="Bruno", LastName="Elite" } } }
                        },
                        Owner = new Owner() { FirstName="Bruno", LastName="Elite", Gym="Indigo Plateau", Country = kanto }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Gengar",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/94.png",
                            BirthDate = new DateTime(1996,2,27),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeGhost } },
                            Reviews = new List<Review>() { new Review { Title="Scary", Text="Hides in shadows.", Rating=4, Reviewer = new Reviewer() { FirstName="Morty", LastName="Ghost" } } }
                        },
                        Owner = new Owner() { FirstName="Morty", LastName="Ghost", Gym="Ecruteak Gym", Country = johto }
                    },
                    new PokemonOwner()
                    {
                        Pokemon = new Pokemon()
                        {
                            Name = "Snorlax",
                            ImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/143.png",
                            BirthDate = new DateTime(1996,2,27),
                            PokemonCategories = new List<PokemonCategory>() { new PokemonCategory { Category = typeNormal } },
                            Reviews = new List<Review>() { new Review { Title="Sleepy", Text="Eats and sleeps all day.", Rating=5, Reviewer = new Reviewer() { FirstName="Red", LastName="Champion" } } }
                        },
                        Owner = new Owner() { FirstName="Red", LastName="Champion", Gym="Mt Silver", Country = johto }
                    }
                };

                dataContext.PokemonOwners.AddRange(pokemonOwners);
                dataContext.SaveChanges();
            }

            // Create AppUser accounts for Reviewers who don't have one
            var reviewersWithoutUsers = dataContext.Reviewers.Where(r => r.AppUserId == null).ToList();
            if (reviewersWithoutUsers.Any())
            {
                var userManager = _serviceProvider.GetRequiredService<UserManager<AppUser>>();
                
                // Using Wait() since SeedDataContext is synchronous
                foreach (var reviewer in reviewersWithoutUsers)
                {
                    var email = $"{reviewer.FirstName.ToLower()}.{reviewer.LastName.ToLower()}@example.com";
                    var user = new AppUser
                    {
                        Email = email,
                        UserName = email,
                        SecurityStamp = Guid.NewGuid().ToString()
                    };

                    var result = userManager.CreateAsync(user, "Password123!").Result;
                    if (result.Succeeded)
                    {
                        reviewer.AppUserId = user.Id;
                    }
                }
                dataContext.SaveChanges();
            }
        }
    }
}