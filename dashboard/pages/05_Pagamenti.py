"""Pagamenti e Debito - Consuntivo e costo del debito."""

import streamlit as st
import plotly.graph_objects as go

from sources import load_pagamenti_anno, load_costo_debito

st.title("🏛️ Pagamenti e Costo del Debito")

df_pag = load_pagamenti_anno()
df_deb = load_costo_debito()

if df_pag.empty:
    st.warning("Nessun dato.")
    st.stop()

# --- Trend pagamenti ---
st.subheader("Trend pagamenti totali")

fig = go.Figure()
fig.add_trace(go.Scatter(
    x=df_pag["anno"], y=df_pag["pagato_totale"] / 1e9,
    name="Pagato totale", line=dict(color="#3498db", width=2),
    fill="tozeroy", fillcolor="rgba(52,152,219,0.1)",
))
fig.add_trace(go.Scatter(
    x=df_pag["anno"], y=df_pag["erario_totale"] / 1e9,
    name="Erario", line=dict(color="#e74c3c", width=2, dash="dot"),
))
fig.update_layout(yaxis_title="Milioni di €", height=350, margin={"t": 30})
st.plotly_chart(fig, width="stretch")

# --- Costo debito bilancio ---
st.subheader("Costo del debito a bilancio (Missione 034)")

fig2 = go.Figure()
fig2.add_trace(go.Scatter(
    x=df_deb["anno"], y=df_deb["costo_debito_bilancio"] / 1e9,
    name="Costo debito", line=dict(color="#e74c3c", width=2),
    fill="tozeroy", fillcolor="rgba(231,76,60,0.1)",
))
fig2.update_layout(yaxis_title="Milioni di €", height=350, margin={"t": 30})
st.plotly_chart(fig2, width="stretch")

# --- KPI ---
latest = int(df_pag["anno"].max())
row_pag = df_pag[df_pag["anno"] == latest].iloc[0]
row_deb = df_deb[df_deb["anno"] == latest].iloc[0] if latest in df_deb["anno"].values else None

col1, col2, col3 = st.columns(3)
col1.metric("Pagato totale", f"€ {row_pag['pagato_totale']/1e9:,.0f} mld")
col2.metric("Quota erario", f"{row_pag['quota_erario_pct']:.1f}%")
if row_deb is not None:
    col3.metric("Costo debito", f"€ {row_deb['costo_debito_bilancio']/1e9:,.0f} mld",
                delta=f"{row_deb['var_pct']:+.1f}%")
