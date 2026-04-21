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
2. **Restore Dependencies:**
   ```bash
   dotnet restore
   ```
3. **Configure the Database Connection:**
   Open `appsettings.json` and update the `DefaultConnection` string so it matches your local SQL Server setup. It usually looks like this:
   `"Data Source=YOUR_SERVER_NAME;Initial Catalog=PokemonReview;Integrated Security=True;Encrypt=False;"`
4. **Apply Database Migrations:**
   Apply migrations to create the database tables.
   ```bash
   dotnet ef database update
   ```
5. **Seed Initial Data:**
   Populate the database with initial Pokemon, reviewers, and categories.
   ```bash
   dotnet run seeddata
   ```
6. **Run the API:**
   ```bash
   dotnet run
   ```
   The API will start up. You can browse to `http://localhost:5219/swagger` to view the Swagger API documentation and verify it's working.

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
   Open `lib/core/constants/api_constants.dart` in the Flutter project. By default, the app is set strictly to `http://127.0.0.1:5219/api/` which ensures it uniformly connects via localhost port-forwarding across any environment.

4. **Running on a Physical Android Device (Crucial Step):**
   When running the app on a real Android phone, the phone cannot natively see your PC's `localhost`. 
   To bridge the connection instantly, **double-click the `link_phone.bat` script** located in the root directory.
   *(This script runs `adb reverse tcp:5219 tcp:5219` to map the phone's loopback to the PC's loopback).*

   > ⚠️ **IMPORTANT NOTE FOR TEAMMATES:** 
   > The `link_phone.bat` file hardcodes the `adb.exe` path to a specific drive (e.g., `D:\Android\sdk\...`). If your Android SDK is installed somewhere else (like `C:\Users\Username\AppData\Local\Android\Sdk`), you **MUST** right-click `link_phone.bat`, select Edit, and change the path to point to your exact `adb.exe` location. If ADB is already in your System Environment Variables, you can change the script to simply say: `adb reverse tcp:5219 tcp:5219`.

5. **Run the App:**
   Ensure the backend is running, the phone is connected, and then run:
   ```bash
   flutter run
   ```

You are all set! Happy coding!
