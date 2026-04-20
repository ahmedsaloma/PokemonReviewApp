namespace PokemonReviewApp.Dto
{
    public class PokemonDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string? ImageUrl { get; set; }

        public DateTime BirthDate { get; set; }
    }
}
