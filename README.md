# DiffusionParametersPredictionSystem

基于 **PINN（物理信息神经网络）** 的多孔介质/岩石扩散参数反演预测系统

English: A PINN (Physics-Informed Neural Network) based software for inverting and predicting diffusion parameters of porous media/rock from through-diffusion experimental data.

---

## 简介

从贯穿扩散（through-diffusion）实验数据出发，联合累计渗流质量与下游质量通量两类观测，利用物理信息神经网络反演：

- **有效扩散系数 De**（输出单位 m²/s）
- **岩样容量因子 α**
- **阿伦尼乌斯参数**：指前因子 D₀ 与活化能 Ea，满足 De(T) = D₀ · exp(−Ea / (R·T))
- **不确定度量化**：Monte Carlo（MC）与 EnKF 集合卡尔曼滤波，输出均值、标准差、置信区间（CI/CV）

界面驱动，自动从实验数据 Excel 导入、反演计算并导出结果 Excel 与拟合图。

## 功能特性

| 模式 | 说明 |
| ---- | ---- |
| 单温度 PINN + MC + EnKF | 单温度实验 α、De 反演，MC + EnKF 双不确定度量化 |
| 多温度 PINN + MC | 温度分段 + 全局阿伦尼乌斯参数联合反演，MC 不确定度 |
| 多温度 PINN + EnKF | 同多温度流程，EnKF 不确定度 |

其他特性：

- 温度分段时间表数据支持（多温阶实验）
- 分阶段训练策略：时间滞回归初估 α → 首温网络精炼 → 冻结场二次精调（改善 α 可辨识性）
- MC 扰动观测数据重复训练，EnKF 对 log(De)、log(α) 集合更新
- 单位自动换算（cm²/day 内部单位 ↔ m²/s 输出）

## 系统要求

- Windows 64 位（WIN64），无需安装 Python 环境（已打包运行时）

## 获取与解压安装

仓库由于体积超过 GitHub 100 MB 单文件限制，整个程序以两个分卷压缩包存储：

```
DiffusionParametersPredictionSystem.zip.part1   (95.0 MB)
DiffusionParametersPredictionSystem.zip.part2   (81.1 MB)
restore.ps1                                     (合并解压脚本)
```

下载以上三个文件放入同一目录后执行：

```powershell
powershell -ExecutionPolicy Bypass -File restore.ps1
```

脚本会自动合并分卷、解压到 `Release` 目录，得到完整可运行的程序文件夹，双击 `DiffusionParametersPredictionSystem.exe` 即可运行。

## 使用流程

1. 按 `输入模板_01_单温度_PINN_MC_EnKF.xlsx` / `_02_多温度_PINN_MC.xlsx` / `_03_多温度_PINN_EnKF.xlsx` 准备实验数据
2. 启动程序，选择对应数据文件与输出目录
3. 运行反演，程序输出结果 Excel 与拟合图像（`试验结果` 目录）

## 文件结构

```
DiffusionParametersPredictionSystem.exe   程序主程序
_internal/                                运行时与源码（Python 3.12 + PyTorch 等打包依赖）
  内含 3 个 PINN 反演脚本（.py 源码）及 account.json 本地账号校验文件
输入模板_01/02/03_*.xlsx                  实验数据输入模板
restore.ps1                               合并分卷并解压脚本
```

## 技术栈

Python 3.12 · PyTorch（自动微分训练）· NumPy · Pandas · Matplotlib · PyInstaller 打包

## 说明
username: diffusion, password: diffusion01
- 输出目录、损失权重、网络宽度/深度、训练轮数、MC 样本数等参数可在程序界面及脚本内调整。
