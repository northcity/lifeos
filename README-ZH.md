<div align="center">

# 🌍 LifeOS — 人生操作系统

**AI 驱动的个人生命轨迹模拟与预测引擎**

*用数字沙盘预演你的人生，在决策前看见未来*

[![Python](https://img.shields.io/badge/Python-3.11%2B-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![Vue](https://img.shields.io/badge/Vue-3-4FC08D?style=flat-square&logo=vue.js&logoColor=white)](https://vuejs.org)
[![License](https://img.shields.io/badge/License-AGPL--3.0-blue?style=flat-square)](./LICENSE)
[![LLM](https://img.shields.io/badge/LLM-通义千问--Plus-FF6A00?style=flat-square)](https://bailian.console.aliyun.com/)
[![GraphRAG](https://img.shields.io/badge/记忆-Zep%20GraphRAG-8B5CF6?style=flat-square)](https://www.getzep.com/)

[English](./README.md) &nbsp;|&nbsp; [中文文档](./README-ZH.md)

</div>
---

## ⚡ 项目概述

**LifeOS（人生操作系统）** 是一款 AI 驱动的个人生命轨迹模拟引擎。

你只需描述自己的真实处境——收入、存款、家庭状况、职业目标——LifeOS 会构建一个高保真的多智能体世界：其中有你的保守版自我、进取版自我、伴侣、子女、雇主、市场环境，以及你正在追求的资产目标。

这些智能体会在模拟时间轴上自由交互、博弈、进化。最终输出：一份完整的人生轨迹分析报告，包含概率预测、风险预警和可执行建议——全部发生在你做出任何真实决策之前。

> **你提供**：个人档案（年龄、收入、积蓄、目标、家庭情况）+ 一段自然语言描述的模拟需求
> **LifeOS 返回**：完整的人生轨迹分析 · 关键节点预测 · 风险警报 · 一个可深度对话的数字世界

### LifeOS 的独特之处

- 🧠 **长短期记忆** — Zep GraphRAG 驱动，智能体真正记住过去发生的事
- 👥 **双版自我建模** — 同时模拟你的保守路径与进取路径，对比结果
- 🏛️ **完整生活上下文** — 伴侣、子女、雇主、市场环境均作为独立智能体建模
- 🔍 **上帝视角干预** — 模拟进行中可注入变量（失业、市场下行、意外收入）
- 📊 **深度分析报告** — ReportAgent 综合模拟结果生成图文并茂的预测报告

---

## 🔄 工作流程

1. **图谱构建**：从个人档案中抽取实体关系 → 生成知识本体 → 注入 GraphRAG 知识库
2. **环境搭建**：生成智能体（保守自我 + 进取自我 + 伴侣 + 子女 + 雇主 + 市场环境 + 资产目标）
3. **开始模拟**：多智能体并行推演 → GraphRAG 长短期记忆实时更新
4. **报告生成**：ReportAgent 分析模拟结果 → 目标达成率 / 风险节点 / 里程碑时间线
5. **深度互动**：与任意智能体对话 → 问"未来的你"任何问题

---

## 📊 典型使用场景

| 场景 | 输入 | LifeOS 预测 |
|------|------|-------------|
| 🏠 首付目标 | 张伟（32岁，北京），月薪2.5万，积蓄40万，目标4年内凑齐80万首付 | 达成概率、最优存款策略、风险月份 |
| 💼 职业转型 | 当前岗位、目标岗位、技能差距、家庭财务压力 | 过渡周期、收入下滑持续时间、回升轨迹 |
| 👨‍👩‍👧 家庭规划 | 当前财务、预期育儿成本、双方职业规划 | 月现金流影响、里程碑冲突点、建议时机 |
| 📈 投资决策 | 资产配置、风险承受力、收入规划 | 组合表现模拟、下行情景推演 |

---

## 🚀 快速开始

### 前置要求

| 工具 | 版本 | 检查命令 |
|------|------|----------|
| **Node.js** | 18+ | `node -v` |
| **Python** | 3.11 – 3.12 | `python --version` |

### 1. 配置环境变量

```bash
cp .env.example .env
# 填入你的 API 密钥
```

```env
# 阿里云通义千问（支持任意 OpenAI 格式 API）
LLM_API_KEY=your_api_key
LLM_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
LLM_MODEL_NAME=qwen-plus

# Zep Cloud（个人用免费额度足够）
# 注册地址：https://app.getzep.com/
ZEP_API_KEY=your_zep_api_key
```

### 2. 安装依赖 & 启动

```bash
# 一键安装所有依赖
npm run setup:all

# 同时启动前后端
npm run dev
```

**服务地址：**
- 前端：`http://localhost:3000`
- 后端 API：`http://localhost:5001`

### 方案二：Docker 部署

```bash
cp .env.example .env
docker compose up -d
```

默认映射端口 `3000`（前端）和 `5001`（后端）。

---

## 🛠️ 技术栈

| 层级 | 技术 |
|------|------|
| 前端 | Vue 3 + Vite + D3.js（图谱可视化） |
| 后端 | Python 3.12 + Flask |
| 大模型 | 阿里云通义千问 qwen-plus（OpenAI 兼容 API） |
| 记忆系统 | Zep Cloud GraphRAG（长短期智能体记忆） |
| 仿真引擎 | OASIS 多智能体框架 |
| 国际化 | vue-i18n（中文 / English） |

---

## 💬 致谢

LifeOS 灵感来源于 **[MiroFish](https://github.com/666ghj/Mirofish)**，一款社会舆论模拟引擎。MiroFish 展示了多智能体仿真在现实社会动态中的应用潜力，LifeOS 将这一思路延伸至个人人生轨迹规划领域。衷心感谢 MiroFish 项目提供的灵感与参考。

本项目仿真引擎基于 **[OASIS](https://github.com/camel-ai/oasis)**（CAMEL-AI 团队开源）构建，衷心感谢其对多智能体仿真领域的开源贡献。

> **开源声明**：依据 AGPLv3 开源协议，本项目完整源代码已公开至 [github.com/northcity/lifeos](https://github.com/northcity/lifeos)。如果你将修改后的版本部署为网络服务，同样需要向用户提供修改后的源代码。

---

## 📄 License

本项目采用 **GNU Affero General Public License v3.0（AGPLv3）**。若将修改后的版本部署为网络服务，必须将修改后的源代码公开。详见 [LICENSE](./LICENSE)。
