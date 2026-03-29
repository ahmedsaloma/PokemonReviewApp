# Team Setup Guide

Welcome to the **Pokemon Review App** project! Follow these steps to clone the repository and set up the development environment on your local machine.

## Prerequisites

Before starting, ensure you have the following installed on your machine:
- **Git** (to clone the repository)
- **.NET 8 SDK** (for the backend)
- **SQL Server** (for the local database instance)
- **Flutter SDK** (for the frontend app)
- **Android Studio / Xcode** (for running the app on mobile emulators)

---

## 1. Clone the Repository

Open a terminal and run the following commands:
```bash
git clone https://github.com/ahmedsaloma/PokemonReviewApp.git
cd PokemonReviewApp
```

*(Note: Replace the URL above if your team uses a different remote repository URL or SSH).*

---

## 2. Backend Setup (ASP.NET Core API)

The backend requires setting up the database connection and running the API.

1. **Navigate to the API folder:**
   ```bash
   cd PokemonReviewApp
   ```
2. **Configure the Database Connection:**
   Open `appsettings.json` and update the `DefaultConnection` string so it matches your local SQL Server setup. It usually looks like this:
   `"Data Source=YOUR_SERVER_NAME;Initial Catalog=PokemonReview;Integrated Security=True;Encrypt=False;"`
3. **Apply Database Migrations:**
   Apply migrations to create the database tables (this will also trigger the data seeder if configured).
   ```bash
   dotnet ef database update
   ```
4. **Run the API:**
   ```bash
   dotnet run
   ```
   The API will start up. You can browse to `http://localhost:5000/swagger` to view the Swagger API documentation and verify it's working.

---

## 3. Frontend Setup (Flutter App)

The frontend requires installing Flutter packages and pointing the app to the locally running backend.

1. **Open a new terminal and navigate to the UI folder:**
   ```bash
   cd pokemon_review_app_ui
   ```
2. **Install Flutter Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure the API Base URL:**
   Open `lib/core/constants/api_constants.dart` in the Flutter project. Make sure the endpoint matches where your backend is running.
   - If using an **Android Emulator**, use: `http://10.0.2.2:5000`
   - If using an **iOS Simulator** or Web, use: `http://localhost:5000`
4. **Run the App:**
   Start an emulator (or connect a physical device) and run:
   ```bash
   flutter run
   ```

You are all set! Happy coding!
