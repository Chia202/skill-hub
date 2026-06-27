# Sufficient Dimension Reduction

讨论 SDR 时，始终先说明目标不是单纯压缩协变量维度，而是在不损失关于响应变量关键信息的前提下，用少数线性组合替代原始协变量。

优先围绕 central subspace 或 related target 组织回答，不要一上来只报 SIR、SAVE、MAVE 的名字。

## 标准回答顺序

1. 先写降维目标针对的是 `Y \mid \mathbf{x}` 的哪一层信息。
2. 再写目标子空间是 central subspace、central mean subspace，还是更具体的对象。
3. 再写方法依赖的是一阶逆矩、二阶逆矩、局部平滑，还是 estimating equations。
4. 最后比较统计条件、数值代价和稳健性。

## 方法簇

### SIR

适合在以下场景优先提及：

- 用户问经典 SDR 入门方法
- 想快速估计主导方向
- 响应变量关系主要通过逆回归均值体现

回答重点：

- SIR 利用 `E(\mathbf{x} \mid Y)` 的结构。
- 经典版本通常依赖线性条件均值一类假设。
- 对对称关系或纯二阶结构，SIR 可能丢失信息。
- 计算与解释都较直接，因此常作为 baseline。

### SAVE

适合在以下场景提及：

- 用户担心 SIR 漏掉对称结构
- 需要利用条件方差信息

回答重点：

- SAVE 通过 `\operatorname{cov}(\mathbf{x} \mid Y)` 一类二阶结构补充信息。
- 它通常比 SIR 更能捕捉某些对称模式。
- 代价是对样本量、切片与协方差估计更敏感。

### MAVE

适合在以下场景提及：

- 用户强调 model-free、局部结构、较少依赖经典逆矩假设
- 用户问 SIR 与 MAVE 在假设层面有何不同

回答重点：

- MAVE 走的是直接估计与局部平滑路线，通常比经典 inverse regression 方法更灵活。
- 它对协变量分布的限制更少，但计算更重，也更依赖带宽和局部拟合稳定性。
- 在样本有限、维度高且噪声复杂时，要提醒数值实现和调参负担。

### Cumulative Slicing

适合在以下场景提及：

- 用户担心 slicing 的人为选择
- 想要比固定切片更稳定的 inverse regression 方案
- 想讨论 cumulative mean、cumulative variance 或 cumulative directional regression

回答重点：

- 说明 cumulative slicing 的核心动机是减轻对切片选择的敏感性。
- 说明它与 SIR/SAVE 同属 inverse regression 家族，但组织信息的方式更连续。
- 如果用户追问“是否完全摆脱经典条件”，不要直接说完全摆脱；更稳妥的表述是“通常能缓解某些切片依赖或条件限制，但仍需逐一核对方法假设”。

### Estimating-equation 与高效估计

适合在以下场景提及：

- 用户问效率、半参数最优性、双重稳健、估计方程
- 用户已经进入理论推导层面

回答重点：

- 先区分目标是 recover subspace 还是做 semiparametric efficient estimation。
- 再解释 estimating equations 如何把结构约束写成可估计的矩条件。
- 如果用户追问 doubly robust，一定说明哪一部分模型错设后仍保有效性，避免泛化。

## 高维、稳健与扩展问题

### 稀疏 SDR

- 强调目标通常是“降维 + 可解释变量选择”。
- 提醒稀疏约束会改变数值算法与理论条件，不能简单照搬低维结论。

### 多响应 SDR

- 先说明是对 joint response 还是某个 summary functional 做降维。
- 如果响应相关性很强，提醒需要考虑多响应结构，而不是逐个响应分别做 SDR。

### 异方差、重尾与异常值

- 不要默认经典 moment-based 方法稳健。
- 如果用户强调 outlier、heavy-tail、rank-based 或 robust regression，优先讨论稳健 inverse regression、稳健 MAVE 或秩方法。

### 结构维数估计

- 提醒“估计子空间”与“估计维数”是两个子问题。
- 对 kernel matrix 或 eigen-structure 方法，重点解释 eigen-gap、秩检验与有限样本稳定性。

## 回答这类题时的固定比较维度

1. 目标子空间是什么。
2. 利用一阶信息、二阶信息，还是局部平滑。
3. 依赖哪些分布假设。
4. 是否适合高维、稀疏、多响应、异方差或重尾。
5. 是否容易扩展到在线或分布式情形。

## 常见陷阱

- 把“model-free”理解成“完全无条件”。
- 把 SDR 和变量选择混为一谈。
- 只比较估计精度，不比较结构维数选择的稳定性。
- 在强共线性或 `p \gg n` 下直接使用未正则化的经典方法。

## Paper Pointers

- Li (1991), *Sliced Inverse Regression for Dimension Reduction*, JASA. <https://doi.org/10.1080/01621459.1991.10475035>
- Cook (2000), *SAVE: a method for dimension reduction and graphics in regression*. <https://doi.org/10.1080/03610920008832598>
- Xia, Tong, Li, Zhu (2002), *Adaptive Estimation of Dimension Reduction Space*, JRSSB. <https://academic.oup.com/jrsssb/article/64/3/363/7098518>
- Zhu, Zhu, Feng (2010), *Dimension Reduction in Regressions Through Cumulative Slicing Estimation*, JASA. <https://doi.org/10.1198/jasa.2010.tm09666>
- Ma, Zhu et al. (2013), *Efficient Estimation in Sufficient Dimension Reduction*, Annals of Statistics. <https://pmc.ncbi.nlm.nih.gov/articles/PMC3777433/>
- Li, Yin (2011), *Sufficient dimension reduction based on an ensemble of minimum average variance estimators*, Annals of Statistics. <https://doi.org/10.1214/11-AOS950>
- Cook, Forzani (2010), *Dimension estimation in sufficient dimension reduction: A unifying approach*, Journal of Multivariate Analysis. <https://doi.org/10.1016/j.jmva.2010.08.007>
