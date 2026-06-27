# Notation Style

回答涉及数学公式、定理、证明、讲义或论文改写时，严格遵循这里的规范。

如果用户临时指定了不同记号，以用户显式指定为准。若内部规则彼此冲突，优先采用本文件的 canonical conventions。

## Canonical Conventions

默认采用以下记号体系：

- 随机标量用大写英文，如 `X`, `Y`.
- 标量实现值用小写英文，如 `x`, `y`.
- 向量一般用粗体小写，如 `\mathbf{x}`, `\mathbf{y}`.
- 矩阵用粗体大写，如 `\mathbf{M}`, `\mathbf{\Sigma}`.
- 集合或空间可用 `\mathcal{S}`, `\mathcal{F}`, `\mathbb{R}`, `\mathbb{R}^p`.
- 除非另有说明，所有向量默认是列向量。

注意：你提供的原始规范对“随机向量”和“向量实现值”有重叠写法。默认写作中保留 `\mathbf{x}` 作为向量记号；如果必须严格区分随机向量与其实现值，先显式声明并改用 `\mathbf{X}` 表示随机向量、`\mathbf{x}` 表示实现值，然后全文保持一致。

## 行内公式与行间公式

- 简短公式尽量保留在正文中。
- 长公式、关键公式、或超过一行高度的公式放在单独一行显示。
- 只有在后文引用某个方程时才加编号，编号放在右侧。
- 不要在行内使用缩小字号来塞进复杂表达式。
- 行内不要写 `\frac{{\mathrm d}y}{{\mathrm d}x}` 这类高公式，改写成 `${\mathrm d}y/{\mathrm d}x` 或直接使用行间公式。

## 括号与可读性

- 多层嵌套时使用 `[\{(\cdot)\}]` 这样的层次。
- 复杂幂写成 `(mnpq)^a`，不要把基底写得难以辨认。
- 冗长表达式先引入新符号，再继续推导，不要硬堆大括号。

## 转置、导数与算子

- 转置写作 `\mathbf{M}^{\mathrm{T}}`, `\mathbf{x}^{\mathrm{T}}`，不要用撇号。
- 单变量导数用 `f'(x)`, `f''(x)`.
- 梯度写作 `\nabla f(\mathbf{x})`.
- Hessian 写作 `\nabla^2 f(\mathbf{x})`.
- 雅可比矩阵写作 `\mathbf{J}(\mathbf{x})`.

## 统计算子

统一使用：

- `E(X)`
- `\operatorname{var}(X)`
- `\operatorname{cov}(X, Y)`
- `\operatorname{corr}(X, Y)`
- `\operatorname{pr}(A)`
- `\operatorname{tr}(\mathbf{M})`
- `\log x`

不要使用：

- `EX`
- `\operatorname{Var}(X)`
- `\operatorname{Cov}(X, Y)`
- `\operatorname{Pr}(A)`
- `\operatorname{trace}`
- `\ln x`

备注：你给出的原始说明后半段曾出现 `\operatorname{Var}`, `\operatorname{Cov}`, `\operatorname{Corr}` 等写法。这里统一以小写 operator 版本为 canonical convention。

## 下标、上标与省略号

- 避免第三阶及以上的上下标。
- 上下标尽量水平对齐，避免视觉错位。
- 写作 `x_1, \ldots, x_n`，不要写 `x_1, x_2, \ldots x_n`.
- 写作 `\sum_{i=1}^n`，不要写 `\sum_1^n`.
- 列表中用 `\ldots`，如 `y_1, \ldots, y_n`.
- 二元运算之间用 `\cdots`，如 `y_1 + \cdots + y_n`.

## 乘法、分数与小数

- 不使用 `.` 或 `\cdot` 作为默认乘积符号，除非确有歧义需要消除。
- 不写 `a/bc` 这种易歧义形式，改写成 `a/(bc)` 或 `a(bc)^{-1}`.
- 小数点前必须有 `0`，写作 `0.2`，不要写 `.2`.

## 文字与公式混排

- 不鼓励在显示公式里夹杂大段文字。
- 若必须并列定义，使用紧凑格式，例如

```tex
\bar Y = n^{-1} \sum_{j=1}^n Y_j, \quad
S^2 = \sum_{j=1}^n (Y_j - \bar Y)^2.
```

- 符号不要出现在句首；必要时先用文字引入。

## 常用对象

- 实直线写作 `\mathbb{R}`，`p` 维实空间写作 `\mathbb{R}^p`.
- 单位阵写作 `\mathbf{I}`.
- 全 1 向量与全 0 向量写作 `\mathbf{1}` 与 `\mathbf{0}`.
- 示性函数写作 `I(A)`.

## 概率与分布

- 密度或质量函数写作 `p(x)` 或 `f(x)`.
- 分布函数写作 `F(x)`.
- 条件密度写作 `p(x \mid y)` 或 `p_{X \mid Y}(x \mid y)`.
- 使用 `X \sim p(x)` 这类写法前，先确认上下文确实把 `p` 作为密度函数。
- 概率写作 `\operatorname{pr}(A) = E\{I(A)\}`.
- 条件期望写作 `E(X \mid Y)`.

## 模板化检查顺序

在整理用户公式时，按以下顺序检查：

1. 是否区分了标量、向量、矩阵。
2. 是否统一了转置、梯度、Hessian 和 Jacobian 的写法。
3. 是否把长公式放到行间。
4. 是否修正了 operator 名称大小写。
5. 是否修正了括号嵌套与歧义分数。

## 推荐改写语句

需要温和纠正时，优先使用：

- `Yes, exactly, 这里真正需要统一的是随机对象与其实现值的记号。`
- `Unfortunately, 这个写法把 operator 和变量混在了一起，最好改成 \operatorname{var}(X).`
- `Perhaps the cleanest notation is to reserve \mathbf{x} for vectors and state explicitly whether it is random or observed.`
