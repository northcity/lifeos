<div align="center">

# 🌍 LifeOS

**Personal Life Simulation & Prediction Engine**

*Rehearse your future. Make better decisions today.*

[![Python](https://img.shields.io/badge/Python-3.11%2B-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![Vue](https://img.shields.io/badge/Vue-3-4FC08D?style=flat-square&logo=vue.js&logoColor=white)](https://vuejs.org)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](./LICENSE)
[![LLM](https://img.shields.io/badge/LLM-Qwen--Plus-FF6A00?style=flat-square)](https://bailian.console.aliyun.com/)
[![GraphRAG](https://img.shields.io/badge/Memory-Zep%20GraphRAG-8B5CF6?style=flat-square)](https://www.getzep.com/)

[English](./README.md)  |  [中文文档](./README-ZH.md)

</div>

---

## ⚡ Overview

**LifeOS** is an AI-powered personal life simulation engine. You describe your real situation — finances, career, family, goals — and LifeOS constructs a high-fidelity multi-agent world populated with intelligent versions of you, your family members, your employer, and the market environment.

These agents interact, evolve, and make decisions across simulated time. The result: a detailed report on likely future trajectories, risk warnings, and actionable recommendations — all before you commit to any real-world decision.

> **You provide**: Your personal profile (age, income, savings, goals, family situation) and a simulation requirement in plain language  
> **LifeOS returns**: A complete life trajectory analysis with risk alerts, milestone predictions, and a living digital world you can interact with

### What makes LifeOS different

- 🧠 **Long + short-term memory** via Zep GraphRAG — agents actually remember past events as simulation progresses
- 👥 **Multiple self-models** — simulates both your conservative self and ambitious self simultaneously
- 🏛️ **Full life context** — models spouse, children, employer, asset targets, market environment as separate agents
- 🔍 **God’s-eye view** — inject scenario variables mid-simulation (job loss, market crash, new opportunity)
- 📊 **Rich analysis report** — ReportAgent synthesizes simulation outcomes with charts and recommendations

---

## 🔄 Workflow

```
Your Profile + Goals
       ↓
┌─────────────────────────────────────────────────────────────────────────┐
│  Step 1: Graph Build                                                       │
│  Extract entities from profile → Build ontology → Inject into GraphRAG     │
├─────────────────────────────────────────────────────────────────────────┤
│  Step 2: Environment Setup                                                 │
│  Generate agents: You×2 (conservative/ambitious) + Spouse + Child +        │
│  Employer + MarketEnvironment + AssetTarget + Organizations                │
├─────────────────────────────────────────────────────────────────────────┤
│  Step 3: Simulation                                                        │
│  Run multi-agent simulation → Real-time GraphRAG memory updates            │
├─────────────────────────────────────────────────────────────────────────┤
│  Step 4: Report                                                            │
│  ReportAgent analyzes simulation → Goals achieved / risks / milestones     │
├─────────────────────────────────────────────────────────────────────────┤
│  Step 5: Deep Interaction                                                  │
│  Chat with any agent → Ask “future you” anything                           │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Example Use Cases

| Scenario | What you input | What LifeOS predicts |
|----------|---------------|---------------------|
| 🏠 Shanghai down payment | Monthly income ¥30k, savings ¥500k, goal: ¥1M down payment in 3 years | Probability of reaching goal, optimal saving strategy, risk months |
| 💼 Career switch | Current role, target role, skill gaps, family financial commitments | Transition timeline, income dip duration, recovery trajectory |
| 👨‍👩‍👧 Family planning | Current finances, expected childcare costs, career plans | Monthly cashflow impact, milestone conflicts, recommended timing |
| 📈 Investment strategy | Asset allocation, risk tolerance, income timeline | Portfolio performance simulation, downside scenarios |

---

## 🚀 Quick Start

### Prerequisites

| Tool | Version | Check |
|------|---------|-------|
| **Node.js** | 18+ | `node -v` |
| **Python** | 3.11 – 3.12 | `python --version` |

### 1. Configure Environment Variables

```bash
cp .env.example .env
# Fill in your API keys
```

```env
# Alibaba Cloud Qwen (supports any OpenAI-compatible API)
LLM_API_KEY=your_api_key
LLM_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
LLM_MODEL_NAME=qwen-plus

# Zep Cloud (free tier sufficient for personal use)
# https://app.getzep.com/
ZEP_API_KEY=your_zep_api_key
```

### 2. Install & Start

```bash
# Install all dependencies
npm run setup:all

# Start frontend + backend
npm run dev
```

**Service URLs:**
- Frontend: `http://localhost:3000`
- Backend API: `http://localhost:5001`

### Option: Docker

```bash
cp .env.example .env
docker compose up -d
```

Ports `3000` (frontend) and `5001` (backend) are mapped automatically.

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Vue 3 + Vite + D3.js (graph visualization) |
| Backend | Python 3.12 + Flask |
| LLM | Alibaba Cloud qwen-plus (OpenAI-compatible) |
| Memory | Zep Cloud GraphRAG (long + short-term agent memory) |
| Simulation | OASIS multi-agent framework |
| i18n | vue-i18n (Chinese / English) |

---

## 💬 Acknowledgments

Built on top of **[OASIS](https://github.com/camel-ai/oasis)** by the CAMEL-AI team. Sincere thanks for the open-source multi-agent simulation framework.

---

## 📄 License

MIT License — see [LICENSE](./LICENSE) for details.