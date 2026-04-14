---
tags: [development, setup]
updated: 2026-04-14
---

# Getting Started

Setup del proyecto Serene desde cero.

## 📋 Requisitos

- macOS 14+ (Sonoma o superior)
- Xcode 15+
- iOS 17+ deployment target
- Cuenta Apple Developer (para device testing)
- Backend Go corriendo localmente o accesible

## 🚀 Setup

### 1. Clonar repo

```bash
git clone https://github.com/tiagofur/serene-ios.git
cd serene-ios
```

### 2. Crear Xcode project

Como hoy sólo tenemos `Package.swift`, hay que crear el `.xcodeproj`:

⚠️ **Pendiente**: La generación del Xcode project necesita hacerse manualmente o vía script.

Pasos manuales:
1. Open Xcode
2. File → New → Project → iOS App
3. Product Name: `Serene`
4. Bundle ID: `com.serene.app` (o tu propio)
5. Interface: SwiftUI
6. Language: Swift
7. Storage: SwiftData
8. Deployment Target: iOS 17.0
9. Drag-and-drop la carpeta `Serene/` en el project navigator

### 3. Configurar Info.plist

Ya viene en `Serene/Info.plist`. Verificar:
- `NSCameraUsageDescription`
- `NSPhotoLibraryUsageDescription`
- `UIAppFonts` (TODO bundlear fuentes)

### 4. Configurar API base URL

`Serene/Services/APIService.swift`:

```swift
enum APIConfig {
    static var baseURL: String {
        #if DEBUG
        return "http://localhost:8080"  // Tu backend Go local
        #else
        return "https://api.serene.app"
        #endif
    }
}
```

### 5. (Opcional) Backend Go

El backend vive en repo separado. Para testing local sin backend:
- App funciona offline-first
- Coach responses caen a fallback local
- Auth no es requerido para testing básico

### 6. Build y run

```bash
# En Xcode
⌘+R  (Run)
```

O CLI (cuando tengamos `xcodeproj`):

```bash
xcodebuild -scheme Serene -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
```

## 📁 Tour del código

Empieza por:
1. `Serene/App/SereneApp.swift` — entry point
2. `Serene/Views/MainTabView.swift` — navigation
3. `Serene/Views/Today/TodayView.swift` — pantalla principal
4. `Serene/ViewModels/TodayViewModel.swift` — lógica core

Ver [[File Structure]] para árbol completo.

## 🎨 Asset bundling pendiente

⚠️ TODOs antes de release:
- [ ] Agregar fuentes DM Serif Display + Plus Jakarta Sans en `Serene/Resources/Fonts/`
- [ ] App icon (1024×1024 + variantes)
- [ ] LaunchScreen background color "LaunchBackground" en xcassets

## 🔗 Relacionados
- [[Build and Run]]
- [[Coding Standards]]
- [[Tech Stack]]
- [[File Structure]]
