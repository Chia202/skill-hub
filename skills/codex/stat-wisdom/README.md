# Stat Wisdom Skill

`stat-wisdom` 是一个面向统计学与大数据方法论场景的 agent skill，目前可直接用于 Codex 与 Claude Code，重点覆盖三类问题：

- 独立性检验、条件独立性检验、非线性相依与特征筛选
- 充分降维（SDR），包括 `SIR`、`SAVE`、`MAVE`、`cumulative slicing`、稀疏 SDR 等方向
- 偏统计方法导向的分布式计算与分布式学习，包括 communication-efficient SDR、去中心化学习与在线更新

## Repository Structure

```text
.
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    ├── independence-testing.md
    ├── sufficient-dimension-reduction.md
    ├── distributed-statistics.md
    └── notation-style.md
```

## Installation

### Option 1: Clone into Codex skills directory

如果你希望 Codex 自动发现这个 skill，直接克隆到 `${CODEX_HOME:-$HOME/.codex}/skills` 下：

```bash
git clone https://github.com/Chia202/stat-wisdom-skill.git \
  "${CODEX_HOME:-$HOME/.codex}/skills/stat-wisdom"
```

安装后，Codex 在匹配到相关统计问题时可以自动触发这个 skill。

### Option 2: Clone into Claude Code skills directory

如果你希望 Claude Code 自动发现这个 skill，直接克隆到 `~/.claude/skills` 下：

```bash
git clone https://github.com/Chia202/stat-wisdom-skill.git \
  "$HOME/.claude/skills/stat-wisdom"
```

安装后，你可以：

- 直接输入 `/stat-wisdom` 显式调用
- 或者直接提与独立性检验、充分降维、分布式统计相关的问题，让 Claude Code 按描述自动触发

如果你想让它只在某个项目内生效，也可以把仓库放到项目目录下的 `.claude/skills/stat-wisdom`。

### Option 3: Clone anywhere and invoke by path

如果你只是想在本地仓库里维护它，也可以克隆到任意目录：

```bash
git clone https://github.com/Chia202/stat-wisdom-skill.git
cd stat-wisdom-skill
```

随后在需要时显式引用该 skill 路径。

## Compatibility Notes

- Codex: 直接使用本仓库的 `SKILL.md`，`agents/openai.yaml` 提供 OpenAI/Codex 侧的附加元数据
- Claude Code: 直接使用本仓库的 `SKILL.md`；`references/` 下的参考文件会按需加载
- Claude 网页版 / Claude Desktop 普通聊天: 不能像 Claude Code 那样直接安装 skill；更接近的替代方案是使用 Projects 的 instructions 和 knowledge files

## How It Works

这个 skill 由一个主入口和四个参考文件组成：

- `SKILL.md`：定义触发条件、回答流程、语气风格和使用边界
- `references/independence-testing.md`：独立性检验、条件独立、特征筛选
- `references/sufficient-dimension-reduction.md`：SIR、SAVE、MAVE、累积切片、结构维数等
- `references/distributed-statistics.md`：分布式 SDR、去中心化学习、在线更新
- `references/notation-style.md`：数学符号、LaTeX 规范、统计写作风格

## Usage Examples

下面这些提问适合触发这个 skill：

```text
在处理高维非线性数据时，基于距离相关系数的特征筛选相比传统 SIS 有哪些核心优势？
```

```text
充分降维中，SIR 与 MAVE 在 model-free 场景下的基本假设有什么不同？
```

```text
如何利用 projection correlation 来度量两个高维随机向量之间的非线性相依性？
```

```text
在分布式计算环境下，如何实现 communication-efficient 的充分降维算法？
```

```text
请用严格的数学符号重写下面这段统计推导，并统一使用 \operatorname{var}、\operatorname{cov}、\operatorname{pr} 的写法。
```

### Explicit Invocation

如果你希望在 Codex 中显式调用，可以使用类似表述：

```text
Use $stat-wisdom to explain why conditional independence testing is central in causal inference, and compare kernel-based methods with residual-based methods.
```

```text
Use $stat-wisdom to rewrite this derivation with rigorous notation and clearer bracket nesting.
```

如果你希望在 Claude Code 中显式调用，可以直接使用 slash command：

```text
/stat-wisdom explain why conditional independence testing is central in causal inference, and compare kernel-based methods with residual-based methods.
```

```text
/stat-wisdom rewrite this derivation with rigorous notation and clearer bracket nesting.
```

## Design Goals

这个 skill 的目标不是替代所有统计学习或机器学习内容，而是强化以下能力：

- 用较高的方法论密度分析统计问题
- 在独立性检验、充分降维和分布式统计之间建立清晰的比较框架
- 在回答中主动暴露假设、失败模式与理论边界
- 在数学写作上维持统一、整洁、可投稿风格的记号规范

## Scope and Limits

适合：

- 统计理论与方法问题
- 高维数据分析与特征筛选
- 充分降维相关方法比较与解释
- 分布式统计方法与去中心化学习的统计视角分析
- 统计论文、讲义、公式推导的符号规范整理

不适合：

- 纯工程实现与系统部署
- 通用 Python、前端、后端或 DevOps 问题
- 与统计方法论关系很弱的泛机器学习调参问题

## Contributing

如果你要继续扩展这个 skill，建议优先从以下方向补充：

- 新增更细分的参考文件，例如条件独立检验、稳健统计、因果推断
- 根据真实提问继续扩充触发词和使用案例
- 对新的数学写作偏好做 canonical notation 级别的统一，而不是零散补丁

## License

MIT License
