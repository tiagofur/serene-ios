---
tags: [development, git]
updated: 2026-04-14
---

# Git Workflow

Convenciones de branches, commits y PRs.

## 🌿 Branches

### Naming
- `main` — siempre deployable (futuro)
- `claude/<task>-<short-id>` — branches de Claude Code
- `feat/<feature-name>` — features manuales
- `fix/<bug-name>` — bug fixes
- `docs/<topic>` — solo docs
- `chore/<task>` — refactor, tooling, deps

### Branch actual
- `claude/implement-prd-features-ooe2m` — branch principal de desarrollo
- Eventualmente merge a `main` vía PR

## 📝 Commits

### Format
```
<verb> <subject>

<body opcional con detalle>

https://claude.ai/code/session_<id>
```

### Verbs comunes
- `Add` — nueva feature
- `Update` — mejora a existente
- `Fix` — bug fix
- `Refactor` — sin cambio de comportamiento
- `Docs` — solo documentación
- `Implement` — features grandes (v1.0, v1.1, v1.2)

### Ejemplos buenos
```
Implement v1.2 Pro features: patterns, difficult mode, PDF export

Adds the v1.2 milestones from the PRD roadmap (Semanas 7-8):
[detalles]
```

```
Fix streak rescue date calculation timezone bug

Edge case in StreakData.useRescue when user crosses
midnight in non-UTC timezone.
```

### Anti-patterns
- ❌ "WIP", "tmp", "fix"
- ❌ Subject >72 chars
- ❌ Sin contexto en body para cambios grandes

## 🔀 Pull Requests

### Cuándo crear PR
- Solo cuando el usuario explícitamente lo pide
- Para features grandes (v1.x → main)
- Para bugs críticos pre-release

### PR Format
```markdown
## Summary
- Bullet 1
- Bullet 2
- Bullet 3

## Test plan
- [ ] Manual test golden path
- [ ] Edge case X
- [ ] Verify dark mode

https://claude.ai/code/session_<id>
```

### Review checklist
- [ ] Code sigue [[Coding Standards]]
- [ ] Sin TODOs sin owner
- [ ] Tests cubren cambios (cuando aplique)
- [ ] Documentación actualizada (este vault)
- [ ] No regresiones visuales (light + dark)
- [ ] No hardcoded strings

## 🔄 Push retry policy

(Per CLAUDE.md instructions)

```
git push -u origin <branch>

If fail (network):
  retry after 2s, 4s, 8s, 16s (exponential backoff)
  max 4 retries
```

## ⚠️ Reglas críticas

### Nunca
- ❌ `git push --force` a main/master sin warning explícito
- ❌ `git rebase -i` (interactive)
- ❌ `git commit --no-verify` sin permiso
- ❌ `git config` updates sin permiso
- ❌ `git reset --hard` sin verificar
- ❌ `git add -A` sin revisar (puede incluir secrets)

### Siempre
- ✅ Stage explícito: `git add Serene/path/file.swift`
- ✅ `git status` antes de commit
- ✅ HEREDOC para commit messages multi-línea
- ✅ Pull antes de push si remote está adelantado

## 🎯 Workflow típico

```bash
# 1. Pick task del backlog
# 2. Create branch
git checkout -b feat/nice-feature

# 3. Code, commit incrementally
git add Serene/Views/...
git commit -m "Add NiceFeatureView with X capability"

# 4. Push
git push -u origin feat/nice-feature

# 5. PR cuando ready
# Si user pide: gh pr create vía MCP
```

## 🔗 Relacionados
- [[Getting Started]]
- [[Coding Standards]]
- [[Release Process]]
