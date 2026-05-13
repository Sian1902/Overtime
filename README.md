# OverTime – Sports Scores & Fixtures (MVP)

**OverTime** is an iOS MVP (Model-View-Presenter) app that delivers real‑time league standings, upcoming fixtures, latest results, and team information for **football, basketball, cricket, and tennis**. The app features a clean onboarding flow, persistent favorites using Core Data, and a modular architecture built for easy testing and maintenance.

## MVP Architecture Overview

The app follows the **Model‑View‑Presenter (MVP)** pattern with a dedicated **Router** for navigation and a **Dependency Container** for object creation.

- **Model** – Data layer: API response models (`League`, `Fixture`, `Team`), Core Data entities, and service classes (`SportsAPIManager`, `DatabaseManager`).  
- **View** – Passive `UIViewController` that displays data and forwards user actions to the Presenter.  
- **Presenter** – Contains all business logic, fetches data from services, formats it, and tells the View what to show.  
- **Router** – Handles all navigation and screen creation, decoupling the navigation logic from the Presenter.  
- **Dependency Container** – Central factory that builds modules with their dependencies.

### Component Diagram

```mermaid
graph TB
    subgraph Presentation
        View[View Controllers]
        Presenter[Presenters]
    end

    subgraph Domain
        Router[App Router]
        Container[Dependency Container]
    end

    subgraph Data
        API[SportsAPIManager]
        DB[DatabaseManager]
        UD[UserDefaultsManager]
    end

    View --> Presenter
    Presenter --> Router
    Router --> Container
    Container -.-> View
    Presenter --> API
    Presenter --> DB
    Presenter --> UD
```
## Onboarding Flow

```mermaid
    sequenceDiagram
    participant Root as RootContainerViewController
    participant Router as AppRouter
    participant Container as DependencyContainer
    participant OnbVC as OnboardingViewController
    participant Presenter as OnboardingPresenter
    participant UD as UserDefaultsManager

    Root->>Router: showSplash() → showOnboarding()
    Router->>Container: makeOnboardingViewController(router:)
    Container->>OnbVC: init(presenter:)
    Container->>Presenter: init(router:storage:)
    Router->>Root: transition(to: OnbVC)
    OnbVC->>Presenter: attachView(self)
    OnbVC->>Presenter: viewDidLoad()
    Presenter->>OnbVC: displayPage(0), hideGetStarted()
    Note over OnbVC: user swipes to last page
    OnbVC->>Presenter: didChangePage(to: lastIndex)
    Presenter->>OnbVC: showGetStarted()
    OnbVC->>Presenter: didTapGetStarted()
    Presenter->>UD: hasSeenOnboarding = true
    Presenter->>Router: showMainTabBar()
    Router->>Root: transition(to: MainTabBar)
```
## Adding a League to Favorites 

```mermaid
sequenceDiagram
    participant User
    participant LeagueVC as LeagueViewController
    participant Presenter as AllLeaguesPresenter
    participant DB as DatabaseManager
    participant API as SportsAPIManager

    User->>LeagueVC: tap heart button
    LeagueVC->>Presenter: toggleFavorite(at: index)
    Presenter->>Presenter: get league at index
    Presenter->>DB: isLeagueFavorite(with: key)
    alt Not favorite
        Presenter->>DB: save(league)
        DB-->>Presenter: success
        Presenter->>LeagueVC: updateFavoriteButton(isFavorite: true)
    else Already favorite
        Presenter->>DB: delete(by: key)
        DB-->>Presenter: success
        Presenter->>LeagueVC: updateFavoriteButton(isFavorite: false)
    end
```
### League Fetch Flow 

```mermaid
flowchart LR
    User[User selects sport] --> VC[SportsCollectionViewController]
    VC --> Presenter[SportsPresenter]
    Presenter --> Router[AppRouter]
    Router --> LeagueVC[LeagueViewController]
    LeagueVC --> LeaguePresenter[AllLeaguesPresenter]
    LeaguePresenter --> API[SportsAPIManager]
    API --> Network[AllSportsAPI]
    Network --> API
    API --> LeaguePresenter
    LeaguePresenter --> LeagueVC
    LeagueVC --> User
```
## Details Screen

```mermaid
flowchart TD
    subgraph LeagueDetails
        LDView[DetailsViewController]
        LDPresenter[LeagueDetailsPresenter]
        LDAPI[SportsAPIManager]
        LDDatabase[DatabaseManager]
    end
    
    subgraph TeamDetails
        TDView[DetailsViewController]
        TDPresenter[TeamDetailsPresenter]
        TDAPI[SportsAPIManager]
    end
    
    LDView -->|user taps team| LDPresenter
    LDPresenter -->|didSelectTeam| Router[AppRouter]
    Router -->|showTeamDetails| TDView
    TDView --> TDPresenter
    TDPresenter --> TDAPI
    LDPresenter --> LDAPI
    LDPresenter --> LDDatabase
```
## Dependency Injection Container Mapping

```mermaid
classDiagram
    class DependencyContainer {
        +makeSplashViewController(router)
        +makeOnboardingViewController(router)
        +makeMainTabBarController(router)
        +makeSportsViewController(router)
        +makeFavoritesViewController(router)
        +makeTeamDetailsViewController(router, team, sport)
    }
    
    class AppRouter {
        +showSplash()
        +showOnboarding()
        +showMainTabBar()
        +showLeagues(sport, navigationController)
        +showLeagueDetails(league, sport, navigationController)
        +showTeamDetails(team, sport, navigationController)
    }
    
    class SportsPresenter {
        +attachView(view)
        +didSelectedSport(at, navigationController)
    }
    
    class AllLeaguesPresenter {
        +attachView(view)
        +loadLeagues()
        +toggleFavorite(at)
    }
    
    class FavoritesPresenter {
        +attachView(view)
        +loadLeagues()
        +toggleFavorite(at)
    }
    
    DependencyContainer --> AppRouter : creates
    AppRouter --> DependencyContainer : uses
    AppRouter --> SportsPresenter : creates via container
    AppRouter --> AllLeaguesPresenter : creates via container
    AppRouter --> FavoritesPresenter : creates via container
```
## Network Request Parallel Execution

```mermaid
sequenceDiagram
    participant VC as DetailsViewController
    participant Presenter as LeagueDetailsPresenter
    participant API as SportsAPIManager
    participant Group as DispatchGroup
    
    VC->>Presenter: viewDidLoad()
    Presenter->>VC: showLoading()
    
    par Upcoming Fixtures
        Presenter->>API: fetchUpcomingFixtures(leagueId)
        API-->>Presenter: upcomingFixtures
    and Latest Fixtures
        Presenter->>API: fetchLatestFixtures(leagueId)
        API-->>Presenter: latestFixtures
    and Teams
        Presenter->>API: fetchTeams(leagueId)
        API-->>Presenter: teams
    end
    
    Note over Presenter,Group: dispatchGroup.notify
    Presenter->>VC: hideLoading()
    Presenter->>VC: reloadData()
``` 
## Requirements

* iOS 15.0+
* Xcode 13.7+
* Swift 5.0+

## Tech Stack & Libraries

* **Architecture:** MVP (Model-View-Presenter) with programmatic routing
* **UI:** UIKit (Programmatic / Storyboards - *update this based on your app*)
* **Networking:** Native `Alamofire` 
* **Local Storage:** CoreData (Favorites), `UserDefaults` (Onboarding state)
* **Concurrency:** `DispatchGroup` for parallel API fetching

