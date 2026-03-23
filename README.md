# Pokemon Review App

A full-stack project consisting of an ASP.NET Core Web API for the backend and a Flutter application for the frontend.

## 🏗️ Project Structure

The repository is organized into two main parts: the backend API and the frontend UI.

### 1. Backend (`PokemonReviewApp/`)
A RESTful Web API built with ASP.NET Core and Entity Framework Core that manages Pokémon, their categories, owners, reviews, and reviewers. It follows clean architecture principles using the Repository Pattern, DTOs, AutoMapper, and Dependency Injection.

**Key Directories:**
- `Controllers/` – Handle incoming API requests and send appropriate responses.
- `Data/` – Contains the `DataContext.cs` for Entity Framework Core.
- `Dto/` – Defines Data Transfer Objects for decoupling models and entities.
- `Interface/` – Interface contracts for repositories.
- `Models/` – Database entity models.
- `Repository/` – Concrete implementations of repository interfaces.
- `Helper/` – AutoMapper profiles and other utilities.

**Technologies Used:**
- ASP.NET Core
- Entity Framework Core
- AutoMapper
- Swagger (Swashbuckle)
- SQL Server

### 2. Frontend (`pokemon_review_app_ui/`)
A cross-platform mobile application built with Flutter, designed to consume the ASP.NET Core API. It uses a feature-first clean architecture to manage state, routing, and UI components.

**Key Directories:**
- `lib/core/` – Core functionalities used across the app, such as constants, API configurations, routing logic, and themes.
- `lib/features/` – The core domains of the application, broken down by feature:
  - `pokemon/` – Browsing and viewing details about Pokémon.
  - `categories/` – Different types and categories of Pokémon.
  - `countries/` – Regions related to Pokémon owners.
  - `owners/` – Information about trainers and gym leaders.
  - `reviewers/` – Registered users who provide reviews.
  - `reviews/` – The reviews written about Pokémon.
- `lib/shared/` – Reusable UI widgets and custom components shared across multiple features.

**Technologies Used:**
- Flutter & Dart
- HTTP integrations for API calls

---

## 🚀 Getting Started

Follow these steps to run the project locally.

### Backend Setup

1. **Navigate to the API directory**:
   ```bash
   cd PokemonReviewApp
   ```
2. **Set up the database connection**:
   Update `appsettings.json` with your SQL Server connection string.
3. **Apply migrations** (if necessary, or it will auto-seed based on your `Program.cs`):
   ```bash
   dotnet ef database update
   ```
4. **Run the API**:
   ```bash
   dotnet run
   ```
   The Swagger UI will be accessible to interact with the API endpoints.

### Frontend Setup

1. **Navigate to the Flutter directory**:
   ```bash
   cd pokemon_review_app_ui
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Configure the base URL**:
   Ensure `lib/core/constants/api_constants.dart` points to your local running backend API (e.g., `http://10.0.2.2:5000` for Android emulator or `http://localhost:5000` for iOS/Web).
4. **Run the Flutter app**:
   ```bash
   flutter run
   ```

---

## 👤 Author
- **Ahmed Saloma** – [GitHub](https://github.com/ahmedsaloma)

## 📄 License
This project is licensed under the MIT License.
