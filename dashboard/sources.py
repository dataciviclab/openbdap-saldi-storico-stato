"""Data sources for the Bilancio Pubblico Intelligence dashboard."""

from __future__ import annotations

from pathlib import Path

import duckdb
import streamlit as st

REPO_ROOT = Path(__file__).parent.parent
MART_DIR = REPO_ROOT / "out" / "data" / "mart"


def _q(mart_path: Path, sql: str) -> "pd.DataFrame":
    """Query a parquet file via DuckDB."""
    import pandas as pd
    con = duckdb.connect()
    try:
        df = con.execute(f"SELECT * FROM read_parquet('{mart_path}')").fetchdf()
        if sql.strip().upper().startswith("SELECT"):
            df = con.execute(sql.replace("read_parquet_input", f"'{mart_path}'"), read={"clean_input": df}).fetchdf()
        return df
    finally:
        con.close()


def _read_parquet(path: Path):
    """Read parquet file into DataFrame."""
    import pandas as pd
    con = duckdb.connect()
    try:
        return con.execute(f"SELECT * FROM read_parquet('{path}')").fetchdf()
    finally:
        con.close()


def _query_parquet(path: Path, sql: str):
    """Run SQL against a parquet file."""
    import pandas as pd
    con = duckdb.connect()
    try:
        return con.execute(sql.replace("t", f"read_parquet('{path}')")).fetchdf() if "FROM t" in sql else con.execute(sql).fetchdf()
    finally:
        con.close()


# --- Saldi ---

@st.cache_data(ttl=3600, show_spinner=False)
def load_saldi_anno():
    return _read_parquet(MART_DIR / "bdap_saldi_stato" / "2024" / "mart_saldi_anno.parquet")


@st.cache_data(ttl=3600, show_spinner=False)
def load_composizione_spesa():
    return _read_parquet(MART_DIR / "bdap_spese_stato" / "2024" / "mart_investimenti_vs_corrente.parquet")


@st.cache_data(ttl=3600, show_spinner=False)
def load_avanzo_primario():
    return _read_parquet(MART_DIR / "bdap_saldi_stato" / "2024" / "mart_avanzo_primario.parquet")


# --- Entrate ---

@st.cache_data(ttl=3600, show_spinner=False)
def load_entrate_anno():
    return _read_parquet(MART_DIR / "bdap_entrate_stato" / "2024" / "mart_entrate_anno.parquet")


@st.cache_data(ttl=3600, show_spinner=False)
def load_entrate_titolo():
    return _read_parquet(MART_DIR / "bdap_entrate_stato" / "2024" / "mart_entrate_titolo_natura_anno.parquet")


@st.cache_data(ttl=3600, show_spinner=False)
def load_trend_tributarie():
    return _read_parquet(MART_DIR / "bdap_entrate_stato" / "2024" / "mart_trend_tributarie.parquet")


# --- Spese ---

@st.cache_data(ttl=3600, show_spinner=False)
def load_spese_missione():
    return _read_parquet(MART_DIR / "bdap_spese_stato" / "2024" / "mart_spese_missione_anno.parquet")


@st.cache_data(ttl=3600, show_spinner=False)
def load_spese_anno():
    return _read_parquet(MART_DIR / "bdap_spese_stato" / "2024" / "mart_spese_anno.parquet")


# --- Pagamenti ---

@st.cache_data(ttl=3600, show_spinner=False)
def load_pagamenti_anno():
    return _read_parquet(MART_DIR / "bdap_pagamenti_stato" / "mart_pagamenti_anno.parquet")


@st.cache_data(ttl=3600, show_spinner=False)
def load_costo_debito():
    return _read_parquet(MART_DIR / "bdap_pagamenti_stato" / "mart_costo_debito_bilancio.parquet")
