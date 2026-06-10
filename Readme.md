# NFT Marketplace
![iOS](https://img.shields.io/badge/iOS-17%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5-orange)
![UIKit](https://img.shields.io/badge/UIKit-Programmatic-black)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green)

iOS marketplace application for browsing and simulated purchasing of NFTs.

Built with **UIKit**, **MVVM**, and a fully programmatic UI. Developed as a collaborative team project during an iOS professional retraining program.

## Preview

<p align="center">
  <img src="https://github.com/user-attachments/assets/4709c703-113f-4a06-a296-dbd81248d21d" width="250"/>
  <img src="https://github.com/user-attachments/assets/545e3afe-9782-4abb-a7ce-728b389f7cba" width="250"/>
  <img src="https://github.com/user-attachments/assets/792d92fd-94e3-4048-95fb-84ad0f661a2a" width="250"/>
  <img src="https://github.com/user-attachments/assets/49da0d75-3c77-494d-9efe-d01a5f8da820" width="250"/>
  <img src="https://github.com/user-attachments/assets/74213fc9-6e27-4302-bd8c-1186dbe60c51" width="250"/>
</p>


## Features

* Browse NFT collections
* View NFT details and author information
* Simulated NFT purchasing flow
* Favorites management
* User rating and profile browsing
* Sorting and filtering support

## Tech Stack

* **UIKit** (programmatic UI)
* **MVVM**
* **URLSession** networking
* **Swift Concurrency / GCD**
* **Dependency Injection**
* **Auto Layout**
* **SPM**

## Architecture

The application follows the **MVVM** architecture to separate presentation logic from UI components and improve maintainability.

Key architectural decisions:

* Feature-based module organization
* Reusable UI components
* Network abstraction layer
* Dependency injection for loose coupling
* Clear separation between presentation, business logic, and networking

## Key Engineering Decisions

- Fully programmatic UI to avoid storyboard limitations and improve scalability
- MVVM chosen to isolate business logic from UI and improve testability
- Network layer abstraction to decouple API models from UI layer

## My Contribution

The project was developed by a team of **4 iOS developers**, where each developer owned a separate feature (epic) and contributed to shared infrastructure and reusable components.

### My Responsibilities

* Built **Catalog** module (list, filtering, pagination)
* Implemented Onboarding flow with persistence
* Integrated networking layer for Catalog screens
* Contributed to shared UI components
* Participated in architectural decisions and code reviews
* Collaborated on common infrastructure

## API

The backend API was provided as part of the educational program and used for training purposes.

## Project Context

This application was created as a **final team project** in an iOS professional retraining program, focused on applying production-like development practices, teamwork, architecture, and feature ownership.

## Installation

1. Clone the repository

```bash
git clone https://github.com/nikolai-eremenko/FakeNFT.git
```

2. Open the project in Xcode

```bash
open FakeNFT.xcodeproj
```

3. Run the app on a simulator or physical device

## Requirements

* iOS 16+
* Xcode 16+
* Swift 5.10+

## Team

Developed by a team of 4 iOS developers.

# Screencast

- [ScreenCast Profile](https://github.com/user-attachments/assets/0332fdd9-2d2a-40c3-9dea-76456a53200c)
- [ScreenCast Catalog](https://github.com/user-attachments/assets/30b9b345-3ceb-4a1e-91cb-68443ffaf8fa)
- [ScreenCast Trash](https://github.com/user-attachments/assets/e99c9973-bbd8-4006-a9e0-b1dbb9bd4849)
- [ScreenCast Stats](https://github.com/user-attachments/assets/0fee0f47-5d81-4eb0-92c6-60aa26b6393f)

## Design

[Figma Design](https://www.figma.com/file/k1LcgXHGTHIeiCv4XuPbND/FakeNFT-(YP)?node-id=96-5542&t=YdNbOI8EcqdYmDeg-0)
