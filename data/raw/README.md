# 📥 /data/raw — Dati originali

Il layer RAW è **intoccabile**: replica esattamente la fonte ufficiale senza alcuna trasformazione.
Ogni esecuzione crea uno snapshot versionato con `RUN_ID` timestamp UTC.

---

## 🔗 Notebook di ingestione

📓 [`01_source_raw.ipynb`](../../notebooks/01_source_raw.ipynb)

Il notebook gestisce per entrambi i dataset:
- download del CSV ufficiale OpenBDAP via `requests` (streaming + chunked)
- validazione del primo chunk (no HTML di errore)
- salvataggio snapshot versionato su Google Drive
- calcolo SHA256 per integrità
- generazione `run_manifest.json`
- generazione `profile_basic.json`

---

## 📂 Struttura Drive (RAW)

```
MyDrive/DataCivicLab/data/raw/
├── openbdap_rendiconto_saldi_storico/
│   └── <RUN_ID>/
│       ├── rendiconto_pubblicato_serie_storica_saldi_raw.csv
│       ├── run_manifest.json
│       └── profile_basic.json
└── openbdap_rendiconto_spese_missioni/
    └── <RUN_ID>/
        ├── rendiconto_pubblicato_spese_missioni_raw.csv
        ├── run_manifest.json
        └── profile_basic.json
```

🔗 [Cartella Drive — RAW Saldi](https://drive.google.com/drive/folders/1wkoZrfr5c_vNJWP2sVZiZECPEoJpJrz6?usp=drive_link)

---

## 📚 Dataset 1 — Saldi storici

**Nome:** Rendiconto Pubblicato — Serie storica — Saldi
**Fonte:** [OpenBDAP (RGS)](https://bdap-opendata.rgs.mef.gov.it/content/rendiconto-pubblicato-serie-storica-saldi)
**Formato:** CSV · delimitatore `;` · encoding `UTF-8`
**Periodo:** 2003–2024 · **Livello:** Anno · **Righe:** 23

### Campi

| Campo RAW | Descrizione |
|---|---|
| `ANNO` | Anno di esercizio finanziario |
| `RISPARMIO_PUBBLICO` | Risparmio pubblico |
| `SALDO_NETTO` | Saldo netto da finanziare |
| `INDEBITAMENTO_NETTO` | Indebitamento netto |
| `RICORSO_MERCATO` | Ricorso al mercato |
| `AVANZO_PRIMARIO` | Avanzo primario |
| `SPESE_CORRENTI` | Spese correnti |
| `SPESE_INTERESSI` | Spese per interessi |
| `SPESE_CONTO_CAPITALE` | Spese in conto capitale |
| `SPESE_ACQ_ATT_FINE` | Spese acquisizione attività finanziarie |
| `SPESE_RIMBORSO_PRESTITI` | Spese per rimborso prestiti |
| `SPESE_COMPLESSIVE` | Spese complessive |
| `SPESE_FINALI` | Spese finali |
| `SPESE_FIN_NETTO_ATT_FIN` | Spese finali netto attività finanziarie |
| `ENTRATE_TRIBUTARIE` | Entrate tributarie |
| `ENTRATE_EXTRA_TRIBUTARIE` | Entrate extra-tributarie |
| `ENTR_ALIEN_PATR_RISCOS` | Entrate alienazioni patrimoniali e riscossioni |
| `RISCOSSIONE_CREDITI` | Riscossione crediti |
| `ENTR_ACCENSIONE_PRESTITI` | Entrate accensione prestiti |
| `ENTRATE_FINALI` | Entrate finali |
| `ENTR_FIN_NETTO_RISCO_CRED` | Entrate finali netto riscossione crediti |
| `ENTRATE_CORRENTI` | Entrate correnti |

---

## 📚 Dataset 2 — Spese per Missione, Programma e Macroaggregato

**Nome:** Rendiconto Pubblicato — Serie storica — Spese Aggregato per Missione, Programma e Macroaggregato
**Fonte:** [OpenBDAP (RGS)](https://bdap-opendata.rgs.mef.gov.it/content/rendiconto-pubblicato-serie-storica-spese-aggregato-missione-programma-e-macroaggregato)
**Formato:** CSV · delimitatore `;` · encoding `latin-1`
**Periodo:** 2008–2024 · **Livello:** Anno / Missione / Programma / Macroaggregato

### Campi

| Campo RAW | Descrizione |
|---|---|
| `Esercizio Finanziario` | Anno di esercizio |
| `Codice Missione` | Codice numerico della missione |
| `Missione` | Denominazione della missione di spesa |
| `Codice Programma` | Codice numerico del programma |
| `Programma` | Denominazione del programma |
| `Codice Macroaggregato` | Codice numerico del macroaggregato |
| `Macroaggregato` | Denominazione (es. FUNZIONAMENTO, INTERVENTI) |
| `Previsioni Definitive CP` | Previsioni definitive di competenza |
| `Previsioni Definitive CS` | Previsioni definitive di cassa |

> ⚠️ Encoding `latin-1`: i nomi delle missioni contengono caratteri accentati italiani.

---

## 🔐 Integrità e tracciabilità

Ogni run produce un `run_manifest.json` con:

```json
{
  "run_id": "20260226_194139",
  "downloaded_at_utc": "2026-02-26T19:41:39+00:00",
  "raw_file": {
    "bytes": 3421,
    "sha256": "abc123...",
    "content_type": "text/csv"
  }
}
```

---

## 📌 Checklist fonte

- [x] Pubblica, citabile, verificabile
- [x] Fonte ufficiale (RGS — Ragioneria Generale dello Stato)
- [x] Frequenza aggiornamento: annuale
- [x] Nessuna trasformazione applicata al layer RAW
- [x] Integrità garantita da SHA256 in `run_manifest.json`
