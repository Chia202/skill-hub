# Distributed Statistics

这里只覆盖偏统计方法导向的分布式计算，不讨论集群部署、容器编排、前端系统或运维细节。

优先回答以下问题：

- 如何把统计任务拆到多个节点
- 如何在通信受限下保持统计效率
- 如何聚合局部估计量、核矩阵或子空间估计
- 去中心化网络中如何进行一致学习
- 流式或在线数据下怎样更新统计结构

## 先做的四个判断

1. 是中心化架构，还是去中心化网络。
2. 节点数据是同质，还是异质。
3. 目标是点估计、推断、分类，还是子空间恢复。
4. 瓶颈在计算、通信、隐私，还是局部样本代表性。

## 常见算法图景

### 一次通信或少次通信的聚合

适合：

- 样本量极大
- 节点很多
- 通信昂贵
- 目标是得到近似全样本估计

回答重点：

- 每个节点先算局部统计量或局部估计量。
- 中央端再做聚合、校正或一到数轮 refinement。
- 关键比较项不是“能不能并行”，而是“损失了多少统计效率”和“需要多少轮通信”。

### 分布式 SDR

适合：

- 用户问 communication-efficient sufficient dimension reduction
- 用户问 distributed SIR、distributed cumulative slicing、heterogeneous massive data

回答重点：

- 先说明局部节点估计的是 kernel matrix、子空间基，还是 reduced-rank structure。
- 再说明聚合时需要解决子空间对齐、特征值间隔和节点异质性。
- 如果用户说“每个节点模型不同”，提醒只有某些共享子空间或共享结构假设下，聚合才有明确统计意义。

### 去中心化学习与分布式 SVM

适合：

- 用户问 decentralized networks
- 用户问不交换原始数据如何学习分类器

回答重点：

- 说明中心化服务器不存在时，常见做法是 consensus/ADMM 或其变体。
- 强调交换的是参数、梯度、拉格朗日变量或局部摘要，而不是原始数据。
- 评价算法时同时比较收敛速度、通信代价和网络拓扑敏感性。

### 在线与流式更新

适合：

- 数据持续到达
- 环境或分布可能变化
- 用户问 online SDR 或 sequential updates

回答重点：

- 说明在线算法的核心是递推更新，而不是简单重跑全样本算法。
- 提醒概念漂移、窗口选择和遗忘因子会改变统计性质。

## 回答分布式统计问题时必须比较的维度

1. 统计效率：与全样本集中式方法相比损失多少。
2. 通信效率：需要多少轮、每轮传什么。
3. 计算负担：局部计算是否可扩展，是否需要矩阵分解或局部迭代。
4. 节点异质性：不同节点分布、模型或噪声是否一致。
5. 鲁棒性：单个节点失效、离群节点或重尾样本如何影响聚合。

## 推荐表述

如果用户问“如何实现”，优先写成统计流程，而不是工程架构图：

1. 在每个节点构造局部统计对象。
2. 上传局部摘要或进行邻居通信。
3. 聚合并做偏差修正或子空间对齐。
4. 判断是否继续通信迭代。
5. 最后评估统计误差与通信开销。

如果用户问“哪种方法更好”，优先从以下角度回答：

- 样本拆分方式是否匹配方法假设
- 目标是 estimation 还是 inference
- 是否允许多轮通信
- 节点间是否异质

## 常见陷阱

- 只谈并行加速，不谈统计误差传播。
- 在节点异质时仍把局部估计简单平均。
- 忽略子空间估计中的方向不识别与对齐问题。
- 把分布式学习问题误答成 Spark 或 Hadoop 教程。

## Paper Pointers

- Xu, Zhu, Fan (2022), *Distributed Sufficient Dimension Reduction for Heterogeneous Massive Data*, Statistica Sinica. <https://doi.org/10.5705/ss.202021.0031>
- Fan, Guo, Wang, Zhu (2022), *Distributed estimation in heterogeneous reduced rank regression: With application to order determination in sufficient dimension reduction*, Journal of Multivariate Analysis. <https://doi.org/10.1016/j.jmva.2022.104991>
- Cai, Li, Zhu (2018), *Online sufficient dimension reduction through sliced inverse regression*. <https://pure.psu.edu/en/publications/online-sufficient-dimension-reduction-through-sliced-inverse-regr/>
- Forero, Cano, Giannakis (2010), *Consensus-Based Distributed Support Vector Machines*, JMLR. <https://www.jmlr.org/papers/v11/forero10a.html>
- Chen, Qiao, Zhu (2025), *Efficient Distributed Learning over Decentralized Networks with Convoluted Support Vector Machine*, JASA. <https://doi.org/10.1080/01621459.2025.2550671>
