# Project Summary

## Overview
This project includes a video showcasing the app’s highlights and features, along with an overview diagram.
Images included below video included in the project

## Overall Flow
The architecture ensures **scalability**, **testability**, and **efficient resource management**.

### **Dependency Injection & Testability**
- `RecipeApp` initializes `DataService` and injects it into `RecipeMainView`.
- `RecipeMainView` sets up `RecipeFavoritesViewModel`, providing it with `DataService` as a dependency.
- `RecipeMainView` also injects `RecipeFavoritesViewModel` into `RecipeListView`, ensuring seamless data flow.
- `RecipeListView` has a **binding** to `RecipeListViewModel`, responsible for handling API requests.

### **Testing with Mocks for Testability**
- `RecipeListViewModel` is designed with **Dependency Injection (DI)**, allowing it to use an `HTTPClient`.
- This approach enables **mock API injection** for testing, supporting `async/await` with a custom `Result` type.
- In tests, a **mock API client** is injected to simulate real API responses without making network calls.

### **Image Caching with `CachedImageView`** for Resource Management
- Before fetching an image from the API, `CachedImageView` checks if a cached version exists.
- If the image is found in the cache, it is **immediately displayed** to improve performance.
- If not, the image is **fetched from the API** and stored in the cache for future use.

### **Scroll to Top** Functionality
Implemented using `ScrollViewReader` and a custom `ScrollToTopButton`. I used `GeometryReader` to detect how far the user has scrolled to show and hide the button.

### **Snackbar Notifications**
`SnackbarViewPresenter` displays a `SnackbarView` when a recipe is favorited and saves it to `FavoritesViewModel`. The results are shown in `RecipeFavoritesView`, where a binding exists between `FavoritesViewModel` and `FavoritesView`.

### **Recipe List & Navigation**
- Each row in `RecipeListView` consists of a `RecipeCardView`, which has closures for button actions:
  - `viewWeb` navigates to a `WebContainer` that loads a `WKWebView`.
  - `viewVideo` uses the same `WebContainer` but loads a YouTube URL.
  - If there is no URL, the button for that cell will not be shown.
  
### **Search Functionality**
- The search filters the `RecipeResult`.
- `CategoryButton` is a reusable component that categorizes searches by region. I fetch the cuisine from the `RecipeViewModel` and use a `Set` to prevent duplicates.
- The filtered results are populated in the `CategoryButton`.
- `CardContent` is divided into `MainContent` and `ButtonContent`, handling all UI for the cards and managing the favoriting functionality, which is handled by `RecipeFavoritesViewModel`.

### **Favoriting & Recipe Management**
- `RecipeFavoritesViewModel` manages the favorite recipes by adding/removing them using `DataService`.
- Tapping on a `RecipeListRow` navigates to `RecipeDetailView`.
- If `RecipeDetailView` had its own data, I would have used a `RecipeDetailViewModel`. The ability to swipe to delete is supported, with `RecipeFavoritesViewModel` checking that no other deletions are in progress before removing items via `DataService`.
  
### **Dynamic Layout for Different Screen Sizes**
- Used `HorizontalSizeClass` and `VerticalSizeClass` to make cells dynamic for different orientations.
- The app also supports Dark Mode.

### **API Integration**
- `RecipeListView` makes an API call to fetch recipe data. `RecipeService` handles the API call through DI.

## Focus Areas
I prioritized the following aspects in the `RecipeListView`:
- **Seamless navigation** via button actions.
- **Efficient image caching** to improve performance.
- **Favoriting and unfavoriting** recipes while persisting data with **SwiftData**.
- Mocking the API for **testability**.
- Structuring the app using the **MVVM** pattern with `@ObservableObject`.
- Implementing a **thread-safe image caching system** using an `actor`.
- Making `DataService` generic for future data types.
- Adding **MatchedGeometryEffect** for smooth transitions in `RecipeDetailView`.

## Time Spent
- **Total**: Approximately **3 days** (not full-time).
- **Focus Areas**:
  - **Dependency Injection & Testing**: Ensured maintainability and testability.
  - **Dynamic UI Handling**: Adjusted `WebView` behavior when URLs were missing or invalid.

## Trade-offs & Decisions
- **RecipeDetailView Data Extraction**:
  - Attempted to extract additional details from the website but found filtering too complex, so I abandoned the approach.
  
- **Loading States in `WKWebView`**:
  - Initially implemented loading states with a spinner, but removed it due to issues with `WKWebViewDelegate` not stopping the loading state correctly.
  
- **Pagination**:
  - Considered adding pagination, but data was limited, and there was no support for limit/offset from the API. Pagination could be easily added by checking the next `RecipeResult` and loading more data.

## Weakest Part of the Project
- **UI Improvements**: The button styling and overall aesthetics could be enhanced.
- **Test Coverage**: Additional test coverage is needed for further reliability.
- **Animations**: Animations could be refined for a smoother user experience.

## Additional Information
- Created **unit tests** for API, `DataService`, and ViewModels.
- Followed **SOLID principles** and **Dependency Injection (DI)** using `StateObject`.

  
<p align="center">
<img src="https://github.com/user-attachments/assets/b3c40965-5312-49a7-a211-9ad324938f4d" alt="MainScreen" width="200">
<img src="https://github.com/user-attachments/assets/8393d391-1814-4555-9fb8-00eb5a50e54c" alt="Categories" width="200">
<img src="https://github.com/user-attachments/assets/83423e63-359c-4109-8e48-537c25ef12f0" alt="Categories Filtering" width="200">
<img src="https://github.com/user-attachments/assets/a0b2033d-a462-4844-b94b-621d83dc26af" alt="Search" width="200">
<img src="https://github.com/user-attachments/assets//bec92465-c817-4c28-8903-479fda72dfce" alt="DetailScreen" width ="200">
<img src="https://github.com/user-attachments/assets//e39ec412-d8b0-468a-bb96-07b46427bb59" alt="FavoritesView" width ="200">
<img src="https://github.com/user-attachments/assets/d1de1bf6-b375-4cd2-bf1d-3a2fdfd3bcae" alt="favoritesToggle" width ="300">
<img src="https://github.com/user-attachments/assets/03a5ef2b-aa64-4ffc-b572-81aa39d47ea1" alt="video" width ="300">
<img src="https://github.com/user-attachments/assets/e96a33ab-c207-4622-b2d3-23721bc0be75" alt="Landscape" width ="400">
</p> 





