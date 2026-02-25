---
title: "M1-06 — QA (controlli qualità, coerenza, regressioni)"
labels: ["QA"]
assignees: []
---
## 🎯 Obiettivo
Evitare che il progetto “sembri ok” ma sia sbagliato.

## ✅ Task
- [ ] Check coerenza per anno/territorio (buchi, outlier grossi)
- [ ] Check somme e percentuali (range 0–100, totali coerenti)
- [ ] Confronto RAW vs CLEAN: righe perse/aggiunte spiegate
- [ ] Regole di regressione (se rifacciamo pipeline, cosa non deve cambiare)
- [ ] Output QA: report breve (MD) con esito e anomalie note

## 📦 Output atteso
`docs/qa.md` + checklist QA riusabile per dataset futuri.