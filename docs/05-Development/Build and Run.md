---
tags: [development, build]
updated: 2026-04-14
---

# Build and Run

Cómo compilar y correr la app localmente.

## 📋 Pre-requisitos

Ver [[Getting Started]] para setup inicial.

## ▶️ Run en simulator

### Vía Xcode (recomendado)
1. Open `Serene.xcodeproj`
2. Select scheme `Serene`
3. Select destination: simulator (iPhone 15 Pro recommended)
4. ⌘+R

### Vía CLI
```bash
xcodebuild -scheme Serene \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  -configuration Debug \
  build

xcrun simctl boot "iPhone 15 Pro"
xcrun simctl install booted ./build/Build/Products/Debug-iphonesimulator/Serene.app
xcrun simctl launch booted com.serene.app
```

## 📱 Run en device

1. Conectar iPhone físico vía USB
2. Trust el computer en el iPhone
3. En Xcode: select device como destination
4. Verify Bundle ID está disponible (puede requerir cambiar a uno único)
5. Sign with Apple Developer team
6. ⌘+R

⚠️ **Primera vez en device**: ir a Settings → General → VPN & Device Management → trust developer cert.

## 🧪 Run tests

⚠️ Cuando tengamos tests configurados ([[Backlog]] P1):

```bash
xcodebuild test \
  -scheme Serene \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

O en Xcode: ⌘+U

## 🌐 Backend setup

Para testing con backend real:

### Local
1. Clonar repo backend Go (separate)
2. `go run main.go` o equivalente
3. Verificar `localhost:8080` responde
4. App con `#if DEBUG` apunta a `localhost:8080` automáticamente

### Sin backend (offline mode)
- App funciona offline-first
- Coach responses caen a fallback local
- No hay sync remoto, todo SwiftData local

## 🔍 Debug helpers

### Verificar SwiftData store
SQLite vive en simulator en:
```
~/Library/Developer/CoreSimulator/Devices/<device-id>/data/Containers/Data/Application/<app-id>/Library/Application Support/default.store
```

Inspeccionar con DB Browser for SQLite.

### Limpiar app data
```
xcrun simctl uninstall booted com.serene.app
```

O en Xcode: hold Option en Run button → Clean Build Folder.

### Forzar regeneración weekly summary
Borrar entries `WeeklySummaryEntry` del SQLite, o reset app data.

## 🎨 SwiftUI Previews

Cada view tiene `#Preview { ... }`.

Para ver: abrir el archivo, ⌘+Option+Return → Canvas visible.

Live preview funciona sin device/simulator.

## 🐛 Comunes issues

### "Cannot find type 'X'"
- Probablemente falta agregar el archivo al target en Xcode
- Right-click → "Show File Inspector" → check target membership

### SwiftData crash al primer launch
- Borrar app y re-instalar
- Schema migration puede fallar silenciosamente — revisar console

### Coach response no aparece
- Backend down o no configurado → fallback local debe activarse
- Si tampoco fallback: revisar AICoachService log

## 🔗 Relacionados
- [[Getting Started]]
- [[Coding Standards]]
- [[Release Process]]
