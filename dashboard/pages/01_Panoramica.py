"""Panoramica - Visione d'insieme del bilancio dello Stato."""

import streamlit as st
import plotly.graph_objects as go

from sources import load_saldi_anno, load_composizione_spesa, load_pagamenti_anno, load_costo_debito

st.title("🇮🇹 Bilancio dello Stato Italiano")

# --- KPI ---
df_saldi = load_saldi_anno()
df_comp = load_composizione_spesa()
df_pag = load_pagamenti_anno()
df_deb = load_costo_debito()

if df_saldi.empty:
    st.warning("Nessun dato disponibile. Esegui `make run` prima.")
    st.stop()

latest = int(df_saldi["anno"].max())
row = df_saldi[df_saldi["anno"] == latest].iloc[0]
row_comp = df_comp[df_comp["anno"] == latest].iloc[0] if latest in df_comp["anno"].values else None

col1, col2, col3, col4 = st.columns(4)
col1.metric(
    "📉 Deficit",
    f"€ {abs(row['saldo_netto_da_finanziare'])/1e9:,.0f} mld",
    help=f"Saldo netto da finanziare {latest}",
)
col2.metric(
    "⚖️ Avanzo Primario",
    f"€ {row['avanzo_primario']/1e9:,.0f} mld",
)
if row_comp is not None:
    col3.metric(
        "🏗️ Investimenti Reali",
        f"{row_comp['pct_investimenti']:.1f}%",
        help="Quota investimenti fissi sul totale spese",
    )
    col4.metric(
        "💸 Debito Totale",
        f"{row_comp['quota_debito_totale_pct']:.1f}%",
        help="Interessi + rimborso sul totale spese",
    )

# --- Trend Saldo Netto ---
st.subheader(f"Evoluzione saldi (2003-{latest})")

fig = go.Figure()
fig.add_trace(go.Bar(
    x=df_saldi["anno"],
    y=df_saldi["saldo_netto_da_finanziare"] / 1e9,
    name="Saldo netto",
    marker_color=["#e74c3c" if v < 0 else "#2ecc71" for v in df_saldi["saldo_netto_da_finanziare"] / 1e9],
))
fig.add_hline(y=0, line_dash="dash", line_color="gray")
fig.update_layout(
    yaxis_title="Milioni di €",
    height=350,
    margin={"t": 30},
    showlegend=False,
)
st.plotly_chart(fig, width="stretch")

# --- Composizione Spesa (stacked bar) ---
st.subheader(f"Composizione spesa ({latest})")

if row_comp is not None:
    voci = ["Trasferimenti", "Debito (interessi+rimborso)", "Investimenti reali", "Funzionamento", "Altri"]
    valori = [
        row_comp["trasferimenti_mld"],
        row_comp["onere_debito_mld"] + row_comp["rimborso_debito_mld"],
        row_comp["investimenti_mld"],
        row_comp["funzionamento_mld"],
        row_comp["altri_mld"],
    ]
    colori = ["#3498db", "#e74c3c", "#2ecc71", "#f39c12", "#95a5a6"]

    fig2 = go.Figure(go.Bar(
        x=[sum(valori)], y=["Spesa totale"],
        orientation="h",
        marker=dict(color=colori, line=dict(width=0)),
        name="",
        text=[f"{v:.0f} mld" for v in valori],
        textposition="inside",
    ))
    fig2.update_layout(
        barmode="stack", height=120, margin={"t": 0, "b": 0},
        showlegend=True,
        legend=dict(orientation="h", y=-0.3),
    )
    # Use a simple legend instead
    st.markdown(" | ".join([f"**{v}**: {val:.0f} mld ({val/sum(valori)*100:.0f}%)" for v, val in zip(voci, valori)]))

# --- Trend Debito Bilancio ---
st.subheader(f"Costo del debito a bilancio (2014-{latest})")

if not df_deb.empty:
    fig3 = go.Figure()
    fig3.add_trace(go.Scatter(
        x=df_deb["anno"],
        y=df_deb["costo_debito_bilancio"] / 1e9,
        name="Costo debito",
        line={"color": "#e74c3c", "width": 2},
        fill="tozeroy",
        fillcolor="rgba(231,76,60,0.1)",
    ))
    fig3.update_layout(
        yaxis_title="Milioni di €",
        height=300,
        margin={"t": 30},
    )
    st.plotly_chart(fig3, width="stretch")
