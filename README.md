# 目录

- [目录](#目录)
- [1. 模型介绍](#1-模型介绍)
  - [1.1. 网络模型结构](#11-网络模型结构)
  - [1.2. 数据集](#12-数据集)
    - [1.2.1. 数据集介绍](#121-数据集介绍)
    - [1.2.2. 准备数据集](#122-准备数据集)
      - [下载 Jester 数据集](#下载-jester-数据集)
    - [1.2.3. 对数据集进行解压](#123-对数据集进行解压)
    - [1.2.4. 准备数据集标记文件](#124-准备数据集标记文件)
  - [1.3. 代码提交地址](#13-代码提交地址)
  - [其他](#其他)
- [2. 代码目录结构说明](#2-代码目录结构说明)
  - [2.1. 脚本参数](#21-脚本参数)
- [3. 自验结果](#3-自验结果)
  - [3.1. 自验环境](#31-自验环境)
  - [3.2. 训练超参数](#32-训练超参数)
  - [3.3. 训练](#33-训练)
    - [3.3.1. 训练之前](#331-训练之前)
    - [3.3.2. 启动训练脚本](#332-启动训练脚本)
    - [3.3.3. 训练精度结果](#333-训练精度结果)
  - [3.4. 评估过程](#34-评估过程)
    - [3.4.1. 启动评估脚本](#341-启动评估脚本)
    - [3.4.2. 评估精度结果](#342-评估精度结果)
- [4. 参考资料](#4-参考资料)
  - [4.1. 参考论文](#41-参考论文)
  - [4.2. 参考 git 项目](#42-参考-git-项目)

# [1. 模型介绍](#contents)

时序关系网络( TRN )是一个解释网络模块，它允许在神经网络中进行时序关系推理，并旨在描述视频中观测之间的时序关系。TRN可以在多个时间尺度上学习和发现可能的时间关系。TRN可以与任何现有的CNN架构(在这项工作中使用BN Inception)以即插即用的方式使用。

[论文](https://arxiv.org/pdf/1711.08496v2.pdf):
Zhou, Bolei & Andonian, Alex & Torralba, Antonio. (2017).
Temporal Relational Reasoning in Videos. arXiv:1711.08496v2 [cs.CV] 25 Jul 2018.

## [1.1. 网络模型结构](#contents)

该模型使用了 BNInception 主干。最后一个全连接层用代替 Dropout 和 FC 层匹配必要数量的特征，从视频帧中提取。TRN 头由感知器层组成，感知器层从帧特征的不同组合中聚合特征。

## [1.2. 数据集](#contents)

可以直接使用基于原始论文提到的数据集或在相关域/网络架构中广泛使用的数据集运行脚本。

### 1.2.1. 数据集介绍

- 数据集链接: [Jester](https://developer.qualcomm.com/software/ai-datasets/jester)
- Jester 数据集的大小: 22.9GB, 148,092 videos (37 frames each), 27 classes
    - Train: 18,3GB, 118,562 videos
    - Validation: 2,3GB，14,787 videos
    - Test: 2,3GB, 14,743 videos
    - 数据格式: 带有视频帧的文件夹

### 1.2.2. 准备数据集

#### 下载 Jester 数据集

数据集 [链接](https://developer.qualcomm.com/software/ai-datasets/jester)

登录后，需要下载包含视频帧数据和标签列表的24个ZIP存档。

文件结构是这样的：

```text
JESTER/
  ├── 20bn-jester-download-package-labels.zip
  ├── 20bn-jester-v1-00.zip
  ├── … … …
  ├── 20bn-jester-v1-21.zip
  └── 20bn-jester-v1-22.zip
```

### 1.2.3. 对数据集进行解压

可以手动解压或使用脚本。 `unpack_jester_dataset.sh`

在模型文件的根目录运行

```bash
bash scripts/unpack_jester_dataset.sh [DATA_PATH] [TARGET_PATH]
```

- DATA_PATH - 指向包含来自原始数据集的ZIP存档的文件夹的路径 (JESTER)
- TARGET_PATH - 用于存储解压后数据集的路径。

例如:

```bash
bash scripts/unpack_jester_dataset.sh /path/to/JESTER /path/to/unpacked_JESTER
```

终端上的日志是这样的：

```text
Target data folder: /path/to/unpacked_JESTER
Unzip...
…
Extract tar archives...
…
Remove unnecessary data...
…
DONE!
```

解压后的文件结构如下：

```text
unpacked_JESTER/
 ├── 20bn-jester-v1/
 │   ├── 1/
 │   │   ├── 00001.jpg
 │   │   ├── 00002.jpg
 │   │   ├── …
 │   │   └── 00037.jpg
 │   ├── 2/
 │   ├── 3/
 │   ├── …
 │   └── 148092/
 └── labels/
     ├── labels.csv
     ├── test-answers.csv
     ├── test.csv
     ├── train.csv
     └── validation.csv
```

### 1.2.4. 准备数据集标记文件

使用此命令安装所需的包：

```bash
pip install -r requirements.txt
```

然后运行这个脚本 `preprocess_jester_dataset.sh`:

```bash
bash scripts/preprocess_jester_dataset.sh [DATASET_ROOT]
```

- DATASET_ROOT - 解压数据集的路径

例如：

```bash
bash scripts/preprocess_jester_dataset.sh /path/to/unpacked_JESTER
```

标准输出类似于：

```text
dataset path: /path/to/unpacked_JESTER
labels path: /path/to/unpacked_JESTER/labels
labels save to: /path/to/unpacked_JESTER

Prepare training folders list
…
Prepare validation folders list
…
```

> 请确保您有权限写入数据集根目录。

运行之后，在数据集根目录中会得到三个新文件：

`categories.txt`, `train_videofolder.txt`, `val_videofolder.txt`.

```text
unpacked_JESTER/
 ├── 20bn-jester-v1/
 ├── labels/
 ├── categories.txt
 ├── train_videofolder.txt
 └── val_videofolder.txt
```

## [1.3. 代码提交地址](contents)

https://git.openi.org.cn/youlz/TRN.git

## [其他](contents)

日志文件保存在提交的 **log.zip** 中

# [2. 代码目录结构说明](#contents)

```text
 .
 ├── configs   # 模型配置文件
 │   └── jester_config.yaml
 ├── model_utils   # Model Arts通用工具
 │   ├── __init__.py
 │   ├── config.py
 │   ├── device_adapter.py
 │   ├── local_adapter.py
 │   ├── logging.py
 │   ├── moxing_adapter.py
 │   └── util.py
 ├── scripts   
 │   ├── convert_bn_inception.sh   # 模型转换脚本
 │   ├── preprocess_jester_dataset.sh   # 数据集预处理脚本
 │   ├── run_eval_npu.sh   # 模型评估脚本
 │   ├── run_export_npu.sh   # 模型导出脚本
 │   ├── run_train_npu.sh   # 训练脚本
 │   └── unpack_jester_dataset.sh   # 数据集解压脚本
 ├── src
 │   ├── __init__.py
 │   ├── bn_inception.py
 │   ├── convert_bn_inception.py
 │   ├── preprocess_jester_dataset.py
 │   ├── train_cell.py
 │   ├── transforms.py
 │   ├── trn.py   # 模型定义
 │   ├── tsn.py
 │   ├── tsn_dataset.py
 │   └── utils.py
 ├── eval.py   # 对完成训练的模型进行评估的脚本
 ├── export.py   # 导出完成训练的模型的脚本
 ├── README.md   # 说明文档
 ├── requirements.txt   # 附加依赖
 └── train.py   # 开始训练的脚本
```

## [2.1. 脚本参数](#contents)

训练和评估的参数都可以设置在 jester_config.yaml 

默认配置fpr在JESTER数据集上训练TRN模型

```yaml
# 模型选项
num_segments: 8                           # 输入帧数
subsample_num: 3                          # 每个TRN头的子样本数
# 数据集选项
image_size: 224                           # 用于调整输入图像的大小
img_feature_dim: 256                      # Backbone out 通道

# Training options
lr: 0.001                                 # 学习率
clip_grad_norm: 20.0                      # 最大梯度范数
update_lr_epochs: 50                      # 学习率之前的 epochs 数
epochs_num: 120                           # epochs 数
train_batch_size: 24                      # 用于训练的批处理大小
momentum: 0.9                             # 动量
dropout: 0.8                              # Dropout 的概率
weight_decay: 0.0005                      # 权衰减
```

# [3. 自验结果](contents)

## [3.1. 自验环境](contents)

- 硬件环境
  - CPU：aarch64 192核
  - NPU：910ProA 32G
- MindSpore version:  1.8.1
- Python
  - 版本：3.7.13
  - 第三方库：requirement.txt

## [3.2. 训练超参数](contents)

train_batch_size：24

epoch：120

learning rate：0.001

optimizer：SDG

更多超参数请查看项目根目录下 configs 目录中的 `jester_config.yaml` 文件

## [3.3. 训练](contents)

### [3.3.1. 训练之前](#contents)

下载在 ImageNet 上训练的 BNInception 模型的 checkpoint : [链接](https://yjxiong.blob.core.windows.net/models/bn_inception-9f5701afb96c8044.pth)

使用如下命令将这个 checkpoint 转换为 Mindspore 格式（确保已经安装了 torch）

```bash
bash scripts/convert_bn_inception.sh /path/to/bn_inception-9f5701afb96c8044.pth /out/path/to/bn_inception.ckpt
```

### [3.3.2. 启动训练脚本](contents)

通过Shell脚本进行训练：

```bash
bash scripts/run_train_npu.sh [DEVICE_ID] [DATASET_ROOT] [PRETRAIN_BNINCEPTION_CKPT]
```

> DEVICE_ID - 设备 ID
>
> DATASET_ROOT - Jester 数据集根目录的路径
>
> PRETRAIN_BNINCEPTION_CKPT - 经过训练的 BNInception 模型的路径

如果使用 Shell 脚本, 日志信息和 checkpoint 将会保存到 **./train-logs** 目录下

### [3.3.3. 训练精度结果](contents)

训练日志文件储存在提交的 **train-logs** 目录下。

## [3.4. 评估过程](#contents)

### [3.4.1. 启动评估脚本](contents)

通过Shell脚本进行评估：

```bash
bash scripts/run_eval_npu.sh [DATASET_ROOT] [CKPT_PATH]
```

> DATASET_ROOT - Jester 数据集根目录的路径
>
> CKPT_PATH - 训练好的 TRN - MultiScale 模型的路径

#### [3.4.2. 评估精度结果](contents)

```text
2022-10-09 11:55:46,141:INFO:Top1: 94.82%
2022-10-09 11:55:46,142:INFO:Top5: 99.81%
```

评估日志文件将会储存在 **./eval-output** 目录下。

# [4. 参考资料](#contents)

## [4.1. 参考论文](contents)

https://arxiv.org/pdf/1711.08496v2.pdf

## [4.2. 参考 git 项目](contents)

https://github.com/zhoubolei/TRN-pytorch
