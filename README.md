# MovieTinder 🎬🔥🤝

## Overview
MovieTinder is a native iOS app that helps groups choose a movie together with less friction.

The experience is simple: everyone reacts to the same set of movies, and the app surfaces the options the group agrees on—so you spend less time debating and more time watching.

---

| Voting | Number of Users | Results |
| ------ | ------ | ------- |
| ![App Main Screen](screenshots/MovieTinder.png) | ![Number of users ](screenshots/NumberOfUsers.png) | ![Results screen](screenshots/Matches.png) |

---

## Using the App

### Set Up Your Environment
- Install **Xcode** on your Mac
- Clone this repository and open the project in Xcode
- Let Xcode resolve packages (if prompted)

### Run the App
- Build and run the app on an iOS Simulator **or** a physical iPhone

### Get Started
- Launch the app
- Start 
- Vote through the movie list
- View the final matched results

---

## Components

### iOS App
The main iOS application target, including:
- UI screens (movie cards / choices / results)
- App state and navigation
- Selection flow (moving through movies, collecting responses)

### Selection / Matching Logic
Core logic that:
- Presents movies to users
- Records responses
- Produces a final set of movies the group matches on

### Tests
- **Unit Tests**: Validate core logic and edge cases
- **UI Tests**: Exercise key user flows end-to-end

---
## Features
- Group movie selection flow
- Simple “decision” interaction (fast choices)
- Results screen showing the group’s matches
- Unit tests + UI tests

---

## Contributors
By: Reese Presnell (@reesepres), Owen Blanchard (@peroblanch), and Huzaifa Mohammad (@Huthaifa-0)

---

## Run on an iPhone (Physical Device)

1. **Clone the repo**
   ```bash
   git clone https://github.com/reesepres/MovieTinder.git
   cd MovieTinder
2. Follow the instructions in this link :
   [Running your app on your device](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device)
