"""Promesse vs Realtà — Confronto Legge di Bilancio vs Rendiconto."""

import streamlit as st
import plotly.graph_objects as go

from sources import load_lb_spese_anno, load_lb_vs_rendiconto

st.title("⚖️ Promesse vs Realtà")

df_lb_anno = load_lb_spese_anno()
df_lb_vs = load_lb_vs_rendiconto()

if df_lb_anno.empty or df_lb_vs.empty:
    st.warning("Nessun dato LB disponibile. Esegui `make run` sul dataset bdap-lb-spese-missione.")
    st.stop()

# --- KPI in alto ---
latest = int(df_lb_anno["anno"].max())
row = df_lb_anno[df_lb_anno["anno"] == latest].iloc[0]

col1, col2, col3 = st.columns(3)
col1.metric("📋 Previsione governo (LB)", f"€ {row['lb_totale_cp_mld']:.0f} mld")
col2.metric("📅 Anni disponibili", f"{len(df_lb_anno)}")
col3.metric("🎯 Missioni per anno", f"{df_lb_vs[df_lb_vs['anno']==latest]['missione'].nunique()}")

st.info("**LB** = Legge di Bilancio (previsioni iniziali del governo). "
        "**Rendiconto** = consuntivo effettivo. Il gap indica dove il governo ha "
        "sottovalutato o sopravvalutato le spese.")

# --- Trend LB vs Rendiconto ---
st.subheader("Trend: previsione governo vs consuntivo")

# Load rendiconto for comparison
from sources import load_spese_anno
df_rnd = load_spese_anno()

if not df_rnd.empty:
    fig = go.Figure()
    fig.add_trace(go.Scatter(
        x=df_lb_anno["anno"], y=df_lb_anno["lb_totale_cp_mld"],
        name="LB (previsione)", line=dict(color="#3498db", width=3),
    ))
    fig.add_trace(go.Scatter(
        x=df_rnd["anno"], y=df_rnd["spese_totali_cp"] / 1e9,
        name="Rendiconto (consuntivo)", line=dict(color="#e74c3c", width=3),
    ))
    fig.update_layout(
        yaxis_title="Milioni di €",
        height=400,
        margin={"t": 30},
        legend=dict(orientation="h", y=-0.15),
    )
    st.plotly_chart(fig, width="stretch")

# --- Confronto per missione ---
st.subheader(f"Confronto per missione ({latest})")

lb_latest = df_lb_vs[df_lb_vs["anno"] == latest].copy()
if not lb_latest.empty:
    # Load rendiconto for same year
    from sources import load_spese_missione
    df_rnd_m = load_spese_missione()
    rnd_latest = df_rnd_m[df_rnd_m["anno"] == latest][["missione", "totale_cp"]].copy()
    rnd_latest["rnd_mld"] = rnd_latest["totale_cp"] / 1e9

    merged = lb_latest.merge(rnd_latest, on="missione", how="left")
    merged["rnd_mld"] = merged["rnd_mld"].fillna(0)
    merged["gap_pct"] = merged.apply(
        lambda r: round((r["lb_previsto_mld"] - r["rnd_mld"]) / r["rnd_mld"] * 100, 1)
        if r["rnd_mld"] > 0 else None, axis=1
    )
    merged = merged.sort_values("lb_previsto_mld", ascending=False)

    # Table
    st.dataframe(
        merged[["missione", "lb_previsto_mld", "rnd_mld", "gap_pct"]].rename(columns={
            "missione": "Missione",
            "lb_previsto_mld": "LB (mld)",
            "rnd_mld": "Rendiconto (mld)",
            "gap_pct": "Gap %",
        }),
        width="stretch",
        hide_index=True,
    )

    # Chart top10
    top10 = merged.head(10)
    fig2 = go.Figure()
    fig2.add_trace(go.Bar(
        y=top10["missione"], x=top10["lb_previsto_mld"],
        name="LB", orientation="h", marker_color="#3498db",
    ))
    fig2.add_trace(go.Bar(
        y=top10["missione"], x=top10["rnd_mld"],
        name="Rendiconto", orientation="h", marker_color="#e74c3c",
    ))
    fig2.update_layout(
        barmode="group",
        xaxis_title="Milioni di €",
        height=400,
        margin={"t": 30},
        legend=dict(orientation="h", y=-0.15),
    )
    st.plotly_chart(fig2, width="stretch")
