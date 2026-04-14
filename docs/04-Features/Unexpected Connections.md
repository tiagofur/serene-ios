---
tags: [feature, pro, insights]
status: completed
version_introduced: 1.2
tier: pro
---

# Unexpected Connections

> Per PRD §3.5: _"Notamos que cuando agradeces naturaleza, tu semana mejora"_

## 🎯 Qué es

Para cada palabra recurrente en tus gratitudes, calculamos cuánto **mejora tu sentiment promedio** cuando la mencionas. Las que tienen lift significativo aparecen como conexiones.

## 📊 Algoritmo

Per [[PatternDetectionService]].detectConnections:

```
1. baseline = avg(sentimentScore) últimos 30 días
2. Para cada palabra (≥3 ocurrencias, sin stop words):
     avgWithWord = avg(sentimentScore de entries que la contienen)
     lift = avgWithWord - baseline
3. Filtrar lift >= 0.08
4. Sort desc por lift
5. Top 3
```

## 📝 Narrativa generada

Por intensidad de lift:
- `lift >= 0.20`: "tu tono emocional es **notablemente más alto**"
- `lift >= 0.12`: "tu tono emocional es **más luminoso**"
- `lift < 0.12`: "tu tono emocional es **más tranquilo**"

Plantilla completa:
> "Cuando mencionas **{topic}**, tu tono emocional es {intensity}. Ha aparecido {N} veces en los últimos 30 días."

## 🎨 UI

[[ConnectionsView]]:
- Card con header `link.circle` rosa
- Por conexión: avatar circular con inicial (rosa soft)
- Topic capitalizado
- Narrativa en texto secundario

## 💾 Persistencia

Snapshots como [[PatternEntry]] type=`connection`. Las nuevas reemplazan las viejas.

## ⚠️ Necesita ≥10 entries

Si menos: muestra placeholder _"A medida que escribas, tu coach notará qué temas te iluminan más."_

## 🔗 Relacionados
- [[Pattern Detection]]
- [[PatternDetectionService]]
- [[v1.2]]
