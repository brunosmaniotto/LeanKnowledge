import streamlit as st
import pandas as pd
import plotly.express as px
import json
import os
from pathlib import Path
from datetime import datetime

# Set page config
st.set_page_config(page_title="LeanKnowledge Monitoring Dashboard", layout="wide")

st.title("📊 LeanKnowledge Monitoring Dashboard")

# --- Sidebar Configuration ---
st.sidebar.header("Configuration")
default_backlog = "backlog.json"
default_strategy = "strategy_kb.json"

backlog_path = st.sidebar.text_input("Backlog JSON Path", default_backlog)
strategy_path = st.sidebar.text_input("Strategy KB JSON Path", default_strategy)

# --- Data Loading ---
@st.cache_data(ttl=60)
def load_backlog(path):
    if not os.path.exists(path):
        return None
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    # Flatten data for DataFrame
    rows = []
    for item_id, entry in data.items():
        row = {
            "ID": item_id,
            "status": entry.get("status"),
            "domain": entry.get("domain"),
            "priority_score": entry.get("priority_score", 0),
            "attempts": entry.get("attempts", 0),
            "source": entry.get("source"),
            "lean_file": entry.get("lean_file"),
            "completed_at": entry.get("completed_at"),
            "failure_reason": entry.get("failure_reason"),
            "type": entry.get("item", {}).get("type"),
            "statement": entry.get("item", {}).get("statement"),
            "dependencies": ", ".join(entry.get("item", {}).get("dependencies", []))
        }
        rows.append(row)
    return pd.DataFrame(rows)

@st.cache_data(ttl=60)
def load_strategy_kb(path):
    if not os.path.exists(path):
        return None
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
    return pd.DataFrame(data)

df_backlog = load_backlog(backlog_path)
df_strategy = load_strategy_kb(strategy_path)

if df_backlog is None:
    st.error(f"Backlog file not found at {backlog_path}")
    st.stop()

# --- 1. Overview ---
st.header("1. Overview")
col1, col2, col3, col4 = st.columns(4)

total_items = len(df_backlog)
status_counts = df_backlog["status"].value_counts()

completed = status_counts.get("completed", 0)
ready = status_counts.get("ready", 0)
blocked = status_counts.get("blocked", 0)
failed = status_counts.get("failed", 0)

# Completion rate: completed / (completed + ready + blocked + failed)
denom = completed + ready + blocked + failed
completion_rate = (completed / denom * 100) if denom > 0 else 0

col1.metric("Total Items", total_items)
col2.metric("Completed", completed)
col3.metric("Blocked", blocked)
col4.metric("Completion Rate", f"{completion_rate:.1f}%")

# Status Bar Chart
fig_status = px.bar(
    status_counts.reset_index(), 
    x="status", 
    y="count", 
    title="Items per Status",
    color="status",
    color_discrete_map={
        "completed": "green",
        "ready": "blue",
        "pending": "gray",
        "blocked": "orange",
        "failed": "red",
        "skipped": "lightgray",
        "in_progress": "yellow",
        "axiomatized": "purple"
    }
)
st.plotly_chart(fig_status, use_container_width=True)

# --- 2. Backlog Table ---
st.header("2. Backlog Table")
col_f1, col_f2 = st.columns(2)
with col_f1:
    status_filter = st.multiselect("Filter by Status", options=df_backlog["status"].unique(), default=[])
with col_f2:
    domain_filter = st.multiselect("Filter by Domain", options=df_backlog["domain"].unique(), default=[])

filtered_df = df_backlog.copy()
if status_filter:
    filtered_df = filtered_df[filtered_df["status"].isin(status_filter)]
if domain_filter:
    filtered_df = filtered_df[filtered_df["domain"].isin(domain_filter)]

st.dataframe(
    filtered_df[["ID", "type", "status", "priority_score", "domain", "attempts", "source", "lean_file"]],
    use_container_width=True,
    hide_index=True
)

# Expandable details
if st.checkbox("Show selected item details"):
    selected_id = st.selectbox("Select Item ID to view details", options=filtered_df["ID"].unique())
    item_details = filtered_df[filtered_df["ID"] == selected_id].iloc[0]
    st.write(f"**Statement:** {item_details['statement']}")
    st.write(f"**Dependencies:** {item_details['dependencies']}")
    if item_details["failure_reason"]:
        st.error(f"**Failure Reason:** {item_details['failure_reason']}")

# --- 3. Blocked Items ---
st.header("3. Blocked Items")
blocked_df = df_backlog[df_backlog["status"] == "blocked"]
if not blocked_df.empty:
    # Highlight high priority
    def highlight_priority(val):
        color = 'red' if val > 2 else 'black'
        return f'color: {color}'

    st.write(f"Found {len(blocked_df)} blocked items.")
    st.dataframe(
        blocked_df[["ID", "priority_score", "dependencies", "domain"]].style.map(highlight_priority, subset=["priority_score"]),
        use_container_width=True,
        hide_index=True
    )
else:
    st.success("No blocked items found!")

# --- 4. Strategy KB Stats ---
st.header("4. Strategy KB Stats")
if df_strategy is not None and not df_strategy.empty:
    s_col1, s_col2 = st.columns(2)
    s_col1.metric("Strategy Entries", len(df_strategy))
    
    # Breakdowns
    fig_strat_domain = px.pie(df_strategy, names="domain", title="Entries by Domain")
    st.plotly_chart(fig_strat_domain, use_container_width=True)
    
    fig_strat_diff = px.bar(df_strategy["difficulty"].value_counts().reset_index(), x="difficulty", y="count", title="Entries by Difficulty")
    st.plotly_chart(fig_strat_diff, use_container_width=True)
    
    # Top Tactics
    all_tactics = []
    for tactics in df_strategy["lean_tactics_used"]:
        if isinstance(tactics, list):
            all_tactics.extend(tactics)
    
    if all_tactics:
        tactic_counts = pd.Series(all_tactics).value_counts().head(10)
        fig_tactics = px.bar(tactic_counts.reset_index(), x="index", y="count", title="Top 10 Tactics")
        st.plotly_chart(fig_tactics, use_container_width=True)
    
    # Avg iterations by difficulty
    avg_iter = df_strategy.groupby("difficulty")["iterations_to_compile"].mean().reset_index()
    fig_iter = px.bar(avg_iter, x="difficulty", y="iterations_to_compile", title="Average Iterations by Difficulty")
    st.plotly_chart(fig_iter, use_container_width=True)
    
    # Common error types
    all_errors = []
    for errors in df_strategy["error_types_encountered"]:
        if isinstance(errors, list):
            all_errors.extend(errors)
    if all_errors:
        error_counts = pd.Series(all_errors).value_counts().head(10)
        fig_errors = px.bar(error_counts.reset_index(), x="index", y="count", title="Common Error Types")
        st.plotly_chart(fig_errors, use_container_width=True)
else:
    st.info("Strategy KB file not found or empty.")

# --- 5. Timeline ---
st.header("5. Timeline")
timeline_df = df_backlog[df_backlog["completed_at"].notnull()].copy()
if not timeline_df.empty:
    try:
        timeline_df["completed_at"] = pd.to_datetime(timeline_df["completed_at"])
        # Group by date
        timeline_df["date"] = timeline_df["completed_at"].dt.date
        daily_counts = timeline_df.groupby("date").size().reset_index(name="completions")
        daily_counts = daily_counts.sort_values("date")
        daily_counts["cumulative"] = daily_counts["completions"].cumsum()
        
        fig_timeline = px.line(daily_counts, x="date", y="cumulative", title="Cumulative Completions Over Time")
        st.plotly_chart(fig_timeline, use_container_width=True)
    except Exception as e:
        st.warning(f"Could not render timeline: {e}")
else:
    st.info("No completion timestamps found yet.")
