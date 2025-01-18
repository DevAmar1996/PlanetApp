# Planet App

## Application Screenshots

Here are some screenshots of the application:

### iPhone Main Screen
<img src="https://github.com/user-attachments/assets/fb644de0-7887-4c34-ad2c-af56a94f0c7c" alt="iPhone Screenshot" width="300"/>

### iPad Main Screen
<img src="https://github.com/user-attachments/assets/ece20ad0-f602-4931-b3d7-77326872522c" alt="iPad Screenshot" width="400"/>

### Mac os Main Screen
<img width="500" alt="Screenshot 2025-01-18 at 12 42 32 AM" src="https://github.com/user-attachments/assets/9099657f-c589-4781-ad7e-c56758dd7a22" />


## Building and Running the Application

### Prerequisites
- Swift 5.0+
- iOS 15.0+
  

### Instructions
1. **Clone the Repository**
   ```bash
   git clone https://github.com/DevAmar1996/PlanetApp.git

2. **Open the project**
  open PlanetsApp.xcodeproj

3. **Build and Run**
   - Select the target device (simulator or real device) and press Cmd + B to build the project.
   - Press Cmd + R to run the project on the selected device.

4. **Running Tests**
   - Unit Tests: Press Cmd + U to run the unit tests.

### Features 
* **Cross-Platform Support**: Runs on iPhone, iPad, and macOS with a responsive UI.
* **Offline Support**: Caches data locally for offline viewing.
* **Dynamic Grid Layout**: Adaptive grid optimized for larger screens like iPad and macOS, utilizing available space efficiently.
* **Combine Integration**: Fetches and processes data using Combine framework.
* **SwiftUI Interface**: Entirely built using SwiftUI for modern and declarative UI design.

### Assumption: Data Flow Management
I began by outlining a clear architecture for managing data flow within the app.
This process was guided by the following principles:

1. **Drawing the Architecture:**
    I visualized the app's architecture, particularly focusing on how data should be fetched and managed efficiently.
   
   <img src="https://github.com/user-attachments/assets/5cac8ffc-c59d-434d-b596-078bf3ea18ec" alt="PlanetsApp Architecture" height="600" width="400"/>

2. **Generic Protocol for Data Fetching:**
    A ```DataFetcher``` protocol was created to abstract the logic of data fetching, making it reusable and type-safe for any ```Encodable``` data.

3. **Data Fetcher Implementations:** Two concrete classes implement the ```DataFetcher``` protocol:
      - OfflineDataFetcher: Retrieves data from local storage.
      - OnlineDataFetcher: Fetches data from a remote API.
   
4. **Repository as a Coordinator:**  A repository layer ```(DataFetcherRepository)``` was introduced to coordinate between the online and offline fetchers. The repository ensures:
       - Seamless Switching: Automatically chooses between online and offline data based on network connectivity.
       - Data Consistency: Updates offline storage when new data is fetched online.

5. **Encodable Support:**
   - All components (```OnlineDataFetcher```, ```OfflineDataFetcher```, and the ```DataFetcherRepository```) operate on generic types conforming to ```Encodable```.
   - This design supports flexibility and allows the app to handle various data models without additional code changes.

### Recommendations for Future Features and Improvements
1. **Pagination Support:**
     Implement pagination to fetch and display planets dynamically as the user scrolls through the list.
2. **Search Functionality:**
     Add a search bar to allow users to find planets by name or other attributes (e.g., climate, population).
3. **Detailed Planet View:**
     Clicking on a planet opens a detailed view with full information about its attributes and associated films, providing a richer user experience.
4. **Favorites Feature:**
   Enable users to mark planets as favorites and store their preferences locally for quick access.
5. **Core Data Integration:**
   Migrate offline storage to Core Data for better data management and scalability.
6. **Localization:**
    Add support for multiple languages, allowing the app to cater to a global audience.
7. **Sorting and Filtering:**
   - Add options to sort planets by attributes like population or name.
   - Allow users to filter planets based on criteria such as climate or terrain.
8. **Push Notifications:**
    Notify users about updates or new planets added to the API.
9. **Interactive Animations:**
   Add smooth animations for transitions between views or when interacting with planets to improve the user experience.








      
