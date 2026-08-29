"""Query SQL - Interroga i dati del bilancio."""

import streamlit as st
import duckdb
from pathlib import Path

st.title("🧪 Query SQL")

st.info("Seleziona un dataset e scrivi una query SQL. I dati sono i mart parquet.")

REPO_ROOT = Path(__file__).resolve().parent.parent.parent

DATASETS = {
    "saldi_anno": "out/data/mart/bdap_saldi_stato/2025/mart_saldi_anno.parquet",
    "composizione_spesa": "out/data/mart/bdap_spese_stato/2025/mart_investimenti_vs_corrente.parquet",
    "avanzo_primario": "out/data/mart/bdap_saldi_stato/2025/mart_avanzo_primario.parquet",
    "entrate_anno": "out/data/mart/bdap_entrate_stato/2025/mart_entrate_anno.parquet",
    "entrate_titolo": "out/data/mart/bdap_entrate_stato/2025/mart_entrate_titolo_natura_anno.parquet",
    "trend_tributarie": "out/data/mart/bdap_entrate_stato/2025/mart_trend_tributarie.parquet",
    "spese_missione": "out/data/mart/bdap_spese_stato/2025/mart_spese_missione_anno.parquet",
    "spese_anno": "out/data/mart/bdap_spese_stato/2025/mart_spese_anno.parquet",
    "pagamenti_anno": "out/data/mart/bdap_pagamenti_stato/mart_pagamenti_anno.parquet",
    "costo_debito": "out/data/mart/bdap_pagamenti_stato/mart_costo_debito_bilancio.parquet",
}

dataset = st.selectbox("Dataset", list(DATASETS.keys()))
default_sql = "SELECT * FROM t ORDER BY 1 LIMIT 20"
sql = st.text_area("SQL", value=default_sql, height=100)

if st.button("Esegui"):
    try:
        rel_path = DATASETS[dataset]
        abs_path = str(REPO_ROOT / rel_path)
        con = duckdb.connect()
        df = con.execute(sql.replace("FROM t", f"FROM read_parquet('{abs_path}')")).fetchdf()
        con.close()
        st.dataframe(df, width="stretch")
        st.caption(f"{len(df)} righe")
    except Exception as e:
        st.error(f"Errore: {e}")
