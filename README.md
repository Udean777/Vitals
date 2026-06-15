# Vitals ⚡️

Vitals is an advanced, beautifully designed system monitoring tool for macOS built entirely with **SwiftUI**. With a sleek glassmorphism aesthetic and adaptive Light/Dark mode support, Vitals provides a comprehensive, data-dense dashboard to track your Mac's core performance metrics in real-time.

![Vitals Architecture & UI Concept](https://img.shields.io/badge/UI-Cyberpunk%20%7C%20Glassmorphism-blue) ![Platform](https://img.shields.io/badge/Platform-macOS%2014.0%2B-lightgrey) ![Language](https://img.shields.io/badge/Language-Swift%206-orange)

## 🌟 Features

Vitals offers a native, lightweight, and incredibly detailed look into your macOS system state:

*   **📊 Overview Dashboard:** A centralized control panel with real-time CPU, RAM, Swap, Disk I/O, and Battery cards, alongside interactive quick action buttons (Free Up RAM, Scan Cache) with visual feedback.
*   **💻 Compute & Memory:** Real-time tracking of CPU load and RAM usage with dynamic stacked bar charts, Thermal diagnostics, Swap usage, and a live Active Process table with Force Quit support.
*   **🌐 Network Activity:** Monitor live download/upload speeds with animated charts, view network interface details including Local & Public IP, and see a breakdown of per-app network usage.
*   **🔋 Advanced Battery Diagnostics:** Track real-time power status, charging percentage, health metrics, detailed diagnostic parameters, persistent 7-day battery history chart, and a live Top Energy Impact app breakdown.
*   **💾 Storage Breakdown:** In-depth disk usage analyzer with visual stacked bars, developer cache scanner, and a large files finder.
*   **🎛 Menu Bar Popover:** An adaptive, unobtrusive Menu Bar widget for quick glances at CPU, RAM, and Battery without opening the main window. Includes Top Processes, Developer Workload tracking, and one-click access to Activity Monitor.
*   **🔔 Smart Alerts:** Custom CPU and Battery threshold notifications via macOS Notification Center.
*   **📤 Export Report:** One-click system snapshot export to a `.txt` file via native macOS Save Panel.
*   **🌓 Adaptive Theme:** Fully supports macOS dynamic themes. Automatically switches between a striking neon-dark mode and a clean, high-contrast light mode.

## 🛠 Tech Stack

*   **Framework:** SwiftUI
*   **Concurrency:** Swift 6 Strict Concurrency (`nonisolated`, `@unchecked Sendable`, `DispatchQueue` locking)
*   **Architecture:** Clean Architecture (Domain / Data / Presentation) with a centralized Dependency Injection (DI) Container.
*   **Visuals:** `Swift Charts` for data visualization, custom `GeometryReader` layouts for stacked bars, and `SF Symbols` for iconography.
*   **System Integration:** Native macOS low-level APIs — `sysctl`, `IOKit`, `vm_statistics64`, `ioreg`, `top`, `lsof` — for accurate real-time metrics.

## 🚀 Getting Started

### Prerequisites
*   macOS 14.0 or later
*   Xcode 16.0 or later
*   Swift 6

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/vitals.git
    cd vitals
    ```
2.  **Open in Xcode**
    ```bash
    open Vitals.xcodeproj
    ```
3.  **Build and Run**
    Select your Mac as the run destination and hit `Cmd + R` to build and launch the app.

## 🏗 Architecture & Code Structure

The project follows Clean Architecture principles to strictly separate UI rendering from business logic:

*   `App/`: Main entry point (`VitalsApp.swift`), `DIContainer` for dependency injection, and global configurations.
*   `Domain/`: Pure Swift business logic — `Entities`, `Interfaces` (protocols), and `UseCases`. Zero framework dependencies.
*   `Data/`: Concrete implementations of all repositories using native macOS system APIs.
*   `Presentation/`: The UI layer — `MainWindow` (Dashboard tabs), `MenuBar` (Menu Bar Extra), reusable `Components`, and the app `Theme`.

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
