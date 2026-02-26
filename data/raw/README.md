# 📥 /data/raw – Dati originali (documentazione)

---

## 🔗 Notebook di ingestione

📓 [01_source_raw.ipynb](../../notebooks/01_source_raw.ipynb)

Il notebook gestisce:
- download del CSV ufficiale OpenBDAP
- salvataggio snapshot versionato
- calcolo SHA256
- generazione `run_manifest.json`
- generazione `profile_basic.json`

---

## 🔗 Link Drive (raw)

[Cartella Drive – RAW OpenBDAP Saldi](https://drive.google.com/drive/folders/1wkoZrfr5c_vNJWP2sVZiZECPEoJpJrz6?usp=drive_link)

Snapshot esempio:
[OpenBDAP Saldi — RUN 20260226_194139](https://drive.google.com/drive/folders/1Ye8u_hUVl36NvCkXlU7Iqau5XIEQgRoZ?usp=sharing)

---

## 📚 Dataset documentato

**Nome dataset:**  
Rendiconto pubblicato — Serie storica — Saldi

**Fonte ufficiale:**  
https://bdap-opendata.rgs.mef.gov.it/content/rendiconto-pubblicato-serie-storica-saldi

**Formato:** CSV (delimiter `;`, valori tra doppi apici)

**Periodo coperto:** 2003–2024  
**Livello:** Anno  
**Numero righe:** 23 (una per anno + header)

### Campi principali

- ANNO  
- RISPARMIO_PUBBLICO  
- SALDO_NETTO  
- INDEBITAMENTO_NETTO  
- RICORSO_MERCATO  
- AVANZO_PRIMARIO  
- SPESE_CORRENTI  
- SPESE_INTERESSI  
- SPESE_CONTO_CAPITALE  
- SPESE_ACQ_ATT_FINE  
- SPESE_RIMBORSO_PRESTITI  

---

## 📌 Checklist
- [x] pubblico, citabile, verificabile  
- [x] fonte ufficiale (RGS – OpenBDAP)  
- [x] frequenza aggiornamento: annuale  

---

## 📝 Note

- Il livello RAW è salvato come snapshot versionato (`<RUN_ID>`).
- Nessuna trasformazione viene applicata in questa fase.
- Integrità garantita tramite SHA256 registrato in `run_manifest.json`.
- Qualsiasi trasformazione verrà effettuata nel notebook successivo `02_clean_transform.ipynb`.
