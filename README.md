# Pokemon Review API

A RESTful Web API built with ASP.NET Core and Entity Framework Core that manages Pokémon, their categories, owners, reviews, and reviewers.

## 📖 Project Description

The Pokémon Review API provides endpoints for managing Pokémon information and user reviews.
It follows clean architecture principles using the Repository Pattern, DTOs, AutoMapper, and Dependency Injection to deliver a scalable and maintainable solution.

This project demonstrates best practices in ASP.NET Core Web API development.

---

## 🏗️ Project Structure

- **Controllers/** – Handle incoming API requests and send appropriate responses.
- **Data/** – Contains the `DataContext.cs` for Entity Framework Core.
- **DTOs/** – Defines Data Transfer Objects for decoupling models and entities.
- **Interfaces/** – Interface contracts for repositories.
- **Models/** – Database entity models.
- **Repositories/** – Concrete implementations of repository interfaces.
- **Mappings/** – AutoMapper profiles for model mapping.

---

## 🛠️ Technologies Used

- ASP.NET Core (.NET 6)
- Entity Framework Core
- AutoMapper
- Swagger (Swashbuckle)
- SQL Server / LocalDB

---

## 🚀 Getting Started

Follow these steps to run the project locally:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ahmedsaloma/PokemonReviewApp.git
   ```

2. **Navigate to the project directory**:
   ```bash
   cd PokemonReviewApp
   ```

3. **Set up the database**:
   Update your `appsettings.json` connection string:
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=PokemonReviewDb;Trusted_Connection=True;"
   }
   ```

4. **Apply migrations** (if necessary):
   ```bash
   dotnet ef database update
   ```

5. **Run the application**:
   ```bash
   dotnet run
   ```

6. **Access the API documentation**:
   Open your browser at:
   ```
   https://localhost:{port}/swagger/index.html
   ```

---

## 📚 Features

- Pokémon Management (Create, Read, Update, Delete)
- Category Assignment
- Owner and Gym Tracking
- Review and Reviewer Management
- AutoMapper Integration
- API Documentation via Swagger

---

## 👤 Author

- **Ahmed Saloma** – [GitHub](https://github.com/ahmedsaloma)

---

## 📄 License

This project is licensed under the MIT License.
You are free to use, modify, and share it.

