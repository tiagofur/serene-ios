---
tags: [architecture, cost, business]
updated: 2026-04-14
---

# Cost Model

Estimación de costes operativos de IA y backend.

## 🤖 Costes IA

### Por request type

| Operación | Tokens input | Tokens output | Coste/req |
|---|---|---|---|
| Coach response post-gratitud | ~2K | ~300 | $0.0004 |
| Weekly summary | ~5K | ~500 | $0.001 |
| Difficult mode turn | ~2K | ~400 | $0.0005 |

(Basado en DeepSeek V3 pricing: $0.14/M input, $0.28/M output)

### Por usuario Pro/semana

| Operación | Cantidad | Subtotal |
|---|---|---|
| Coach responses (5 grat × 7 días) | 35 | $0.014 |
| Weekly summary | 1 | $0.001 |
| Difficult mode (estimado) | 5 turns | $0.0025 |
| **Total** | | **~$0.018/semana** |

**Mensual**: ~$0.07/Pro user
**Anual**: ~$0.85/Pro user

### Por usuario Free/semana

| Operación | Cantidad | Subtotal |
|---|---|---|
| Coach responses (3 grat × 7 días) | 21 | $0.0084 |
| Weekly summary | 0.25 (1/mes) | $0.00025 |
| **Total** | | **~$0.009/semana** |

**Mensual**: ~$0.04/Free user

## 📊 Escalabilidad

| Users | Free 80% | Pro 20% | Coste IA mensual |
|---|---|---|---|
| 100 | 80 | 20 | $4.6 |
| 500 | 400 | 100 | $23 |
| 1,000 | 800 | 200 | $46 |
| 5,000 | 4,000 | 1,000 | $230 |
| 10,000 | 8,000 | 2,000 | $460 |

(Asume 80/20 free/pro split)

## 💰 Margen

| Métrica | 1,000 users | 10,000 users |
|---|---|---|
| Pro users | 200 | 2,000 |
| Revenue (avg ARPU $4.50) | $900 | $9,000 |
| Coste IA | $46 | $460 |
| **Margen IA** | **94.9%** | **94.9%** |

Excluye costes de:
- Backend hosting (~$50-200/mes según escala)
- Apple 15-30% commission
- Email/notifications service
- Analytics

### Estimación net margin
~70-75% después de Apple commission y opex.

## 🏗️ Backend hosting

| Etapa | Solución | Costo mensual |
|---|---|---|
| 0-1k users | Render / Fly.io free tier | ~$0-10 |
| 1k-10k | DigitalOcean droplet + managed Postgres | ~$50 |
| 10k-50k | DO + Postgres scaled | ~$150-400 |
| 50k+ | AWS/GCP arquitectura escalable | $1000+ |

## 🚨 Cost monitoring

⚠️ **TODO**: Implementar metering en backend:
- Tokens por user (rolling 30 days)
- Alert si user excede 5x average (potential abuse)
- Daily/weekly cost reports

## 💡 Optimizaciones futuras

### v2.0
- Apple Intelligence on-device para casos simples → reduce cloud calls
- Cache de coach responses similares (con personalización mínima)
- Prompt compression (system prompt ya cacheable, instructions cortas)

### v2.1
- Fine-tuned model propio (one-time training cost, cheaper inference)
- Self-hosted LLM si volume justifica (>$5k/mes en API)

## 🔗 Relacionados
- [[AI Architecture]]
- [[Monetization Model]]
- [[KPIs]]
- [[ADR-002 - Hybrid AI Architecture]]
