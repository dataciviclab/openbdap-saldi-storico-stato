# 🧹 /data/clean — Dati puliti

Il layer CLEAN normalizza i dati RAW senza alterarne il contenuto semantico.
Input: CSV da `data/raw/`. Output: Parquet + metadata su Google Drive.

---

## 🔗 Notebook di trasformazione

📓 [`02_raw_clean.ipynb`](../../notebooks/02_raw_clean.ipynb)

---

## 📂 Struttura Drive (CLEAN)

```
MyDrive/DataCivicLab/data/clean/
├── openbdap_rendiconto_saldi_storico/
│   └── <RUN_ID>/
│       ├── saldi_storico.parquet
│       ├── columns_mapping_raw_to_clean.json
│       ├── profile_clean.json
│       ├── validate_clean.json
│       ├── data_dictionary.json
│       └── clean_manifest.json
└── openbdap_rendiconto_spese_missioni/
    └── <RUN_ID>/
        ├── spese_missioni.parquet
        ├── columns_mapping_raw_to_clean.json
        ├── profile_clean.json
        ├── validate_clean.json
        ├── data_dictionary.json
        └── clean_manifest.json
```

🔗 [Cartella Drive — CLEAN](https://drive.google.com/drive/folders/1JGJpf6jeFDzpgZRgfXoBShBt3zP9kQVg?usp=sharing)

---

## 🔄 Policy di trasformazione

Le stesse regole si applicano a entrambi i dataset.

### Null policy
I seguenti valori vengono convertiti a `NULL`:
`""` · `" "` · `"n.d."` · `"nd"` · `"N.D."` · `"null"` · `"NULL"`

### Parsing numerico
- `,` → `.` (separatore decimale)
- `-` mantenuto come segno meno (non è null)
- `%` → valore diviso 100
- Cast finale: `TRY_CAST AS DOUBLE` (fallisce silenziosamente a NULL)

### Nomi colonne
- Rinomina semantica esplicita via `SEMANTIC_MAP` (vedi `columns_mapping_raw_to_clean.json`)
- Fallback automatico a `snake_case` per colonne non mappate

### Cosa NON viene fatto
- Nessun ricalcolo o modifica semantica dei valori economici
- Nessuna aggregazione o join
- Nessuna imputazione dei null

---

## 📊 Dataset 1 — Saldi storici

**File output:** `saldi_storico.parquet`
**Chiave:** `esercizio_finanziario` (unica per anno)
**Righe attese:** 22 (2003–2024)

### Schema colonne

| Colonna CLEAN | Tipo | Colonna RAW |
|---|---|---|
| `esercizio_finanziario` | INTEGER | `ANNO` |
| `risparmio_pubblico` | DOUBLE | `RISPARMIO_PUBBLICO` |
| `saldo_netto_da_finanziare` | DOUBLE | `SALDO_NETTO` |
| `indebitamento_netto` | DOUBLE | `INDEBITAMENTO_NETTO` |
| `ricorso_al_mercato` | DOUBLE | `RICORSO_MERCATO` |
| `avanzo_primario` | DOUBLE | `AVANZO_PRIMARIO` |
| `spese_correnti` | DOUBLE | `SPESE_CORRENTI` |
| `spese_per_interessi` | DOUBLE | `SPESE_INTERESSI` |
| `spese_in_conto_capitale` | DOUBLE | `SPESE_CONTO_CAPITALE` |
| `spese_acquisizione_attivita_finanziarie` | DOUBLE | `SPESE_ACQ_ATT_FINE` |
| `spese_per_rimborso_prestiti` | DOUBLE | `SPESE_RIMBORSO_PRESTITI` |
| `spese_complessive` | DOUBLE | `SPESE_COMPLESSIVE` |
| `spese_finali` | DOUBLE | `SPESE_FINALI` |
| `spese_finali_netto_att_fin` | DOUBLE | `SPESE_FIN_NETTO_ATT_FIN` |
| `entrate_tributarie` | DOUBLE | `ENTRATE_TRIBUTARIE` |
| `entrate_extra_tributarie` | DOUBLE | `ENTRATE_EXTRA_TRIBUTARIE` |
| `entrate_alienazioni_patrimoniali_e_riscossioni` | DOUBLE | `ENTR_ALIEN_PATR_RISCOS` |
| `riscossione_crediti` | DOUBLE | `RISCOSSIONE_CREDITI` |
| `entrate_accensione_prestiti` | DOUBLE | `ENTR_ACCENSIONE_PRESTITI` |
| `entrate_finali` | DOUBLE | `ENTRATE_FINALI` |
| `entrate_fin_netto_riscossione_crediti` | DOUBLE | `ENTR_FIN_NETTO_RISCO_CRED` |
| `entrate_correnti` | DOUBLE | `ENTRATE_CORRENTI` |

---

## 📊 Dataset 2 — Spese per Missione, Programma e Macroaggregato

**File output:** `spese_missioni.parquet`
**Chiave composta:** `(esercizio_finanziario, codice_missione, codice_programma, codice_macroaggregato)`
**Righe attese:** ~2.000+ (2008–2024 × missioni × programmi × macroaggregati)
**Encoding RAW originale:** `latin-1`

### Schema colonne

| Colonna CLEAN | Tipo | Colonna RAW |
|---|---|---|
| `esercizio_finanziario` | INTEGER | `Esercizio Finanziario` |
| `codice_missione` | INTEGER | `Codice Missione` |
| `missione` | VARCHAR | `Missione` |
| `codice_programma` | INTEGER | `Codice Programma` |
| `programma` | VARCHAR | `Programma` |
| `codice_macroaggregato` | INTEGER | `Codice Macroaggregato` |
| `macroaggregato` | VARCHAR | `Macroaggregato` |
| `previsioni_definitive_cp` | DOUBLE | `Previsioni Definitive CP` |
| `previsioni_definitive_cs` | DOUBLE | `Previsioni Definitive CS` |

> ⚠️ Null attesi: ~90 righe in `previsioni_definitive_cp` e `previsioni_definitive_cs` (anni iniziali senza dato).

---

## ✅ Validazioni automatiche

Eseguite dal notebook al termine di ogni run:

**Dataset 1 (Saldi)**
- `row_count_ge_1` — dataset non vuoto
- `required_columns_present` — colonne obbligatorie presenti
- `unique_esercizio_finanziario` — nessun duplicato per anno
- `year_bounds_present` — range anni valorizzato

**Dataset 2 (Missioni)**
- `row_count_ge_min` — almeno 100 righe
- `required_columns_present` — colonne obbligatorie presenti
- `unique_composite_key` — nessun duplicato sulla chiave composta
- `year_bounds_present` — range anni valorizzato
- `null_check_previsioni_definitive_cp/cs` — null entro soglia attesa (≤ 200)
