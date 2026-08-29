"""Data sources for the Bilancio Pubblico Intelligence dashboard."""

from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path

import duckdb
import streamlit as st

REPO_ROOT = Path(__file__).parent.parent
MART_DIR = REPO_ROOT / "out" / "data" / "mart"


def _read_parquet(path: Path):
    """Read parquet file into DataFrame."""
    import pandas as pd
    con = duckdb.connect()
    try:
        return con.execute(f"SELECT * FROM read_parquet('{path}')").fetchdf()
    finally:
        con.close()


def get_last_updated() -> str:
    """Return the most recent modification time across all mart parquet files."""
    latest_ts = 0.0
    for p in MART_DIR.rglob("*.parquet"):
        mtime = p.stat().st_mtime
        if mtime > latest_ts:
            latest_ts = mtime
    if latest_ts == 0.0:
        return "N/A"
    from datetime import datetime, timezone
    return datetime.fromtimestamp(latest_ts, tz=timezone.utc).strftime("%d/%m/%Y %H:%M")


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


@st.cache_data(ttl=3600, show_spinner=False)
def load_pagamenti_missione_anno():
    """Load all per-year pagamenti missioni mart and concatenate."""
    import pandas as pd
    frames = []
    base = MART_DIR / "bdap_pagamenti_stato"
    for year_dir in sorted(base.iterdir()):
        if year_dir.is_dir() and year_dir.name.isdigit():
            pq = year_dir / "mart_pagamenti_missione_categoria.parquet"
            if pq.exists():
                df = _read_parquet(pq)
                frames.append(df)
    return pd.concat(frames, ignore_index=True) if frames else pd.DataFrame()


# --- LB (Legge di Bilancio) ---

@st.cache_data(ttl=3600, show_spinner=False)
def load_lb_spese_anno():
    return _read_parquet(MART_DIR / "bdap_lb_spese_missione" / "mart_lb_spese_anno.parquet")


@st.cache_data(ttl=3600, show_spinner=False)
def load_lb_vs_rendiconto():
    return _read_parquet(MART_DIR / "bdap_lb_spese_missione" / "mart_lb_vs_rendiconto.parquet")

