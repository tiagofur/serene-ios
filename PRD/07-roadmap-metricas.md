# 9. Roadmap de Desarrollo

| Fase | Timeline | Alcance | Hito |
|---|---|---|---|
| **MVP v1.0** | Semanas 1-4 | Pantalla Hoy completa, sheet escritura, coach IA basico, racha, onboarding 6 pasos, StoreKit 2, autenticacion Go | Submit App Store |
| **v1.1** | Semanas 5-6 | Resumen semanal (API cloud), historial completo Pro, notificaciones inteligentes, modo oscuro pulido | First 100 users |
| **v1.2** | Semanas 7-8 | Patrones emocionales, modo dificil, exportar PDF, mejoras UX onboarding basadas en datos | First MRR |
| **v2.0** | Mes 3-4 | Dictado por voz, Android Jetpack Compose, PT-BR completo, widget de pantalla de inicio iOS | Android launch |
| **v2.1** | Mes 5+ | Gratitud hacia personas (recordatorios relacionales), HealthKit, modo familia (compartir logros) | Pro growth |

---

# 10. Metricas de Exito

## 10.1 KPIs de retencion

| Metrica | Objetivo | Benchmark sector |
|---|---|---|
| D1 retention | 50%+ | 40-50% apps de bienestar |
| D7 retention | 30%+ | 20-30% |
| D30 retention | 20%+ | 10-15% |
| Racha promedio mes 1 | 5+ dias | 3-4 dias |
| % usuarios que completan 5 gratitudes | 40%+ | N/A (metrica propia) |
| % usuarios que abren resumen semanal | 60%+ de Pro | N/A |

## 10.2 KPIs de monetizacion

| Metrica | Objetivo mes 1 | Objetivo mes 3 | Objetivo mes 6 |
|---|---|---|---|
| MRR | $0 (lanzamiento) | $500 | $2,500 |
| Trial-to-paid conversion | --- | 15%+ | 18%+ |
| Churn mensual Pro | --- | <5% | <4% |
| ARPU | --- | $4.20 | $4.50 |
| Usuarios activos mensuales | 100 | 500 | 2,000 |

## 10.3 KPIs de calidad de IA

- Rating promedio de respuestas del coach (in-app feedback opcional): **>4.2/5**
- % respuestas que el usuario califica como "se sintio personalizada": **>70%**
- Latencia de respuesta del coach: **<3 segundos** en condiciones normales
- Coste de tokens por usuario Pro activo/semana: **<$0.005**

---

# 11. Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigacion |
|---|---|---|---|
| Retencion baja — habito dificil de construir | Alta | Alto | Racha + notificaciones inteligentes + coach que "recuerda" al usuario. Rescate de racha 1x/mes. |
| Competencia apps establecidas (Reflectly, Gratitude) | Media | Medio | Diferenciacion por coach IA personal + SwiftUI nativo superior + tono emocional unico. |
| Costes IA escalan con usuarios | Media | Medio | Arquitectura hibrida. API solo para Pro y respuestas post-gratitud. Free usa on-device mayormente. |
| App Store review — claims de salud mental | Baja | Alto | No hacer claims medicos. Posicionamiento: bienestar y habitos, no terapia. Disclaimer en onboarding. |
| Privacidad de datos emocionales sensibles | Baja | Alto | Encriptacion en transito y reposo. Opcion de modo offline. Transparencia en privacy policy. |
| Coach IA responde de forma inapropiada | Baja | Alto | System prompt con restricciones claras. Deteccion de keywords de crisis. Redireccion a recursos. |
