---
tags: [development, release]
updated: 2026-04-14
status: planned
---

# Release Process

⚠️ **Estado**: Documentado a futuro. No hemos hecho release aún.

## 📋 Pre-release checklist

### Code
- [ ] Versión bumpeada en `Info.plist` (`CFBundleShortVersionString`, `CFBundleVersion`)
- [ ] Changelog actualizado: [[Changelog]]
- [ ] Sin TODOs P0 abiertos en [[Backlog]]
- [ ] Tests passing (cuando los tengamos)
- [ ] No warnings de compiler

### Funcional
- [ ] Manual test del onboarding completo
- [ ] Manual test del daily flow (3/3 + extras)
- [ ] Test offline (airplane mode)
- [ ] Test dark mode
- [ ] Test en device físico (no solo simulator)
- [ ] Crisis Detection funciona ([[AI Quality Goals]])

### Assets
- [ ] App icon (1024×1024 + variantes)
- [ ] Screenshots en App Store Connect (6.7" + 6.5" + 5.5" iPhone)
- [ ] App Preview videos (opcional pero recomendado)
- [ ] Privacy policy URL accesible
- [ ] Terms of service URL accesible

### Store metadata
- [ ] Description ES (futuro: EN, PT-BR)
- [ ] Keywords (max 100 chars)
- [ ] What's New en cada release
- [ ] Categoría: Health & Fitness o Lifestyle

## 🚀 Release types

### TestFlight (interno)
1. Archive en Xcode (Product → Archive)
2. Upload to App Store Connect
3. Wait for processing (~10-30 min)
4. Add internal testers
5. Smoke test in TestFlight

### TestFlight (externo)
1. Add external testers en grupos
2. Submit for Beta App Review (24-48h primer build)
3. Notificar testers

### Production
1. Submit for review desde TestFlight build estable
2. Wait for review (24-48h típicamente)
3. Once approved: release manualmente o auto
4. Monitor crashes / reviews

## 📊 Post-release

- Monitor App Store Connect metrics
- Track [[KPIs]]
- Reviews response (responder a 1-stars constructivos)
- Crash reports → priorizar hotfixes

## 🔄 Hotfix flow

Para bugs críticos post-release:
1. Branch `hotfix/<bug>` desde el tag de release
2. Fix + test
3. Bump patch version (1.2.0 → 1.2.1)
4. Expedited review (botón en App Store Connect, justificar)

## 📝 Versioning

Semantic versioning:
- **MAJOR** (1.x → 2.x): Cambios disruptivos, nueva plataforma
- **MINOR** (1.0 → 1.1): Nuevas features, no rompe compat
- **PATCH** (1.1.0 → 1.1.1): Bug fixes, polish

## 🎯 Cadencia objetivo

- **MVP launch**: cuando R1 (Crisis Detection) esté + StoreKit real + fonts bundled
- **Minor releases**: cada 4-6 semanas
- **Patch releases**: as needed para fixes críticos
- **Major releases**: ~6-12 meses

## 🌍 Rollout strategy

Para minor/major releases nuevos:
1. **Phased release** (App Store Connect feature): 1% → 5% → 20% → 50% → 100% over 7 días
2. Monitor crash rate cada step
3. Pause si crash rate >0.5%

## 🔗 Relacionados
- [[Changelog]]
- [[KPIs]]
- [[Risk Register]]
- [[Backlog]] (P0 items para release)
