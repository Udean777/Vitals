# Vitals ⚡️

Vitals is an advanced, beautifully designed system monitoring tool for macOS built entirely with **SwiftUI**. With a sleek glassmorphism aesthetic and adaptive Light/Dark mode support, Vitals provides a comprehensive, data-dense dashboard to track your Mac's core performance metrics in real-time.

![Vitals Architecture & UI Concept](https://img.shields.io/badge/UI-Cyberpunk%20%7C%20Glassmorphism-blue) ![Platform](https://img.shields.io/badge/Platform-macOS%2014.0%2B-lightgrey) ![Language](https://img.shields.io/badge/Language-Swift%205.9-orange)

## 🌟 Features

Vitals offers a native, lightweight, and incredibly detailed look into your macOS system state:

*   **📊 Overview Dashboard:** A centralized control panel with quick action buttons (e.g., Free Up RAM, Scan Cache) featuring interactive loading states and visual feedback.
*   **💻 Compute & Memory:** Real-time tracking of CPU load and RAM usage with dynamic stacked bar charts, alongside Thermal and Swap memory diagnostics.
*   **🌐 Network Activity:** Monitor total data sent/received, view network interface details, and see a breakdown of network-heavy processes.
*   **🔋 Advanced Battery Diagnostics:** Track real-time power status, charging percentage, health metrics, and detailed diagnostic parameters.
*   **💾 Storage Breakdown:** In-depth disk usage analyzer with visual stacked bars, purgeable space indicators, and a large files scanner section.
*   **🎛 Menu Bar Popover:** An adaptive, unobtrusive Menu Bar widget for quick glances at CPU, RAM, and Battery without opening the main window. Includes one-click access to the macOS Activity Monitor.
*   **🌓 Adaptive Theme:** Fully supports macOS dynamic themes. Automatically switches between a striking neon-dark mode and a clean, high-contrast light mode.

## 🛠 Tech Stack

*   **Framework:** SwiftUI
*   **Architecture:** MVVM (Model-View-ViewModel) paired with a centralized Dependency Injection (DI) Container for lifecycle management.
*   **Visuals:** `Swift Charts` for data visualization, custom `GeometryReader` layouts for complex stacked bars, and `SF Symbols` for iconography.
*   **System Integration:** Utilizes native macOS APIs (`NSWorkspace`, `ProcessInfo`, etc.) to fetch system statistics.

## 🚀 Getting Started

### Prerequisites
*   macOS 14.0 or later
*   Xcode 15.0 or later
*   Swift 5.9

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

The project follows clean architecture principles to separate UI rendering from business logic:
*   `App/`: Contains the main entry point (`VitalsApp.swift`), global theme configurations (`AppTheme.swift`), and the `DIContainer`.
*   `Presentation/`: The UI layer. Broken down into the `MainWindow` (Dashboard tabs), `MenuBar` (Menu bar extra), and reusable `Components`.
*   `Data/` & `Domain/`: (WIP) Structured to handle system data fetching (`UseCases` and `Repositories`).

## 🔮 Future Roadmap

*   [ ] Connect all mock data endpoints to real native macOS low-level APIs (e.g., `sysctl`, `I/O Kit`).
*   [ ] Add interactive notifications and threshold alerts for high CPU/RAM usage.
*   [ ] Implement actual disk cleaning and RAM purging functionalities (requires elevated privileges).
*   [ ] Extend WidgetKit support for macOS Notification Center widgets.

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
