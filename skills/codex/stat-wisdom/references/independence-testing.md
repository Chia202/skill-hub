# Independence Testing

在讨论独立性问题时，先区分四件事：

1. 检验边际独立，还是条件独立。
2. 衡量相依强度，还是做显著性检验。
3. 做最终推断，还是做前期特征筛选。
4. 面对标量变量，还是高维随机向量。

优先使用下面的分析顺序：

1. 说明零相关不等于独立，除非处在高斯或其他受限分布族中。
2. 说明变量类型、维数和样本量关系。
3. 判断是否需要非参数、稳健或高维方法。
4. 再选择统计量与检验程序。

## 常见问题类型

### 边际独立性

适合回答：

- `X` 与 `Y` 是否独立
- 怎样度量非线性相依
- 哪种 dependence measure 适合高维向量

优先考虑：

- 距离相关系数与能量统计：适合发现一般非线性相依，常用于高维筛选与泛型独立性检验。
- HSIC 一类核方法：适合非线性、非欧式结构或核化表示。
- 投影相关系数：适合讨论两个高维随机向量之间的依赖结构，强调通过投影把高维问题转化为一维依赖刻画。

### 条件独立性

适合回答：

- `X \perp Y \mid Z` 如何检验
- 因果发现里为什么需要 conditional independence
- 非参数条件独立检验有哪些路线

优先强调：

- 条件独立比边际独立更难，维数灾难更严重。
- 偏相关只在近线性和近高斯场景下可信，不能直接代替一般条件独立。
- 核方法、重采样方法和基于回归残差的方法各有代价，重点比较 type-I error 控制、功效和维数敏感性。

### 特征筛选

适合回答：

- 距离相关筛选相比 SIS 有何优势
- 响应变量复杂、非线性、类别不平衡时如何筛选
- 面对重尾、异常值或交互效应时如何构造 model-free screening

优先强调：

- 筛选的目标是保留有效变量，通常追求 sure screening，而不是立即得到最终稀疏模型。
- SIS 依赖线性边际相关，容易漏掉非线性效应和某些联合效应。
- DC-SIS、MV-SIS、基于 cumulative divergence 的前向筛选更适合非线性、分类响应或模型错设场景。

## 回答时的推荐比较框架

对方法比较题，按以下维度回答：

1. 统计对象：独立、条件独立，还是筛选有效性。
2. 相依结构：线性、非线性、单变量、多变量。
3. 假设强度：是否依赖高斯性、光滑性、核选择、切片或带宽。
4. 计算代价：是否需要成对距离、核矩阵、重采样或多轮拟合。
5. 稳健性：对异常值、重尾、共线性、混合型数据是否敏感。
6. 高维适应性：当 `p \gg n` 时是否仍可解释和计算。

## 推荐回答要点

### 距离相关与 SIS

- 说明 SIS 更接近线性边际筛选。
- 说明距离相关能检测更一般的依赖关系。
- 说明在强非线性或非单调关系下，DC-SIS 往往更稳。
- 同时提醒它仍然可能受高噪声、强共线性和有限样本不稳定性影响。

### 投影相关系数

- 把核心点放在“高维向量依赖可通过一维投影上的依赖结构刻画”。
- 强调它适合解释高维向量间的非线性相依，而不是只替代普通相关系数。
- 如果用户追问稳健性，只说它在高维向量依赖分析中更有结构针对性；除非有额外条件，不要泛化成“天然对所有异常值都稳健”。

### 条件独立与因果推断

- 指出 conditional independence 是图模型和因果发现的基础语言。
- 区分“检验条件独立”和“识别因果效应”是两件事。
- 如果用户把条件独立检验当作因果结论本身，立即指出还需要无混杂、正值性、模型设定等额外条件。

## 常见陷阱

- 把零相关当作独立。
- 把筛选方法的 sure screening 理解成选择一致性。
- 在高维条件独立问题里忽视维数灾难与调参敏感性。
- 在 mixed data 或 heavy-tailed data 中照搬经典高斯工具。

## Paper Pointers

以下文献适合在回答里点名引用或作为进一步阅读：

- Li, Zhong, Zhu (2012), *Feature Screening via Distance Correlation Learning*, JASA. <https://pmc.ncbi.nlm.nih.gov/articles/PMC4170057/>
- Zhong, Xu, Zhu, Li (2017), *Projection correlation between two random vectors*, Biometrika. <https://pmc.ncbi.nlm.nih.gov/articles/PMC5793497/>
- Zhou, Zhu, Xu, Li (2020), *Model-Free Forward Screening Via Cumulative Divergence*, JASA. <https://doi.org/10.1080/01621459.2019.1632078>
- Gretton et al. (2007), *A Kernel Statistical Test of Independence*, NeurIPS. <https://papers.nips.cc/paper/3201-a-kernel-statistical-test-of-independence>
- Zhang, Peters, Janzing, Schölkopf (2011), *Kernel-based Conditional Independence Test and Application in Causal Discovery*, UAI. <https://www.researchgate.net/publication/221404238_Kernel-based_Conditional_Independence_Test_and_Application_in_Causal_Discovery>
- Scetbon, Meunier, Romano (2022), *An Asymptotic Test for Conditional Independence using Analytic Kernel Embeddings*, ICML. <https://proceedings.mlr.press/v162/scetbon22a.html>
