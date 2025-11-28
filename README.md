# 数字图像处理系统 - Digital Image Processing System

基于MATLAB App Designer的数字图像处理应用程序，实现了数字图像处理教材第2-6章的主要算法。

A MATLAB App Designer-based digital image processing application implementing major algorithms from chapters 2-6 of digital image processing textbooks.

## 功能特性 - Features

### 第二章：图像基础 - Chapter 2: Image Fundamentals
- 图像加载与显示 - Image loading and display
- 图像信息查看 - Image information viewing
- 图像保存 - Image saving

### 第三章：强度变换与空间滤波 - Chapter 3: Intensity Transformations and Spatial Filtering
- 直方图均衡化 - Histogram equalization
- 图像反转 - Image negative
- 对数变换 - Log transformation
- 幂次变换（Gamma校正）- Power transformation (Gamma correction)
- 平滑滤波 - Smoothing filter
- 锐化滤波 - Sharpening filter

### 第四章：频率域处理 - Chapter 4: Frequency Domain Processing
- FFT频谱显示 - FFT spectrum display
- 低通滤波 - Low-pass filter
- 高通滤波 - High-pass filter

### 第五章：图像复原 - Chapter 5: Image Restoration
- 添加高斯噪声 - Add Gaussian noise
- 添加椒盐噪声 - Add salt & pepper noise
- 均值滤波 - Mean filter
- 中值滤波 - Median filter

### 第六章：彩色图像处理 - Chapter 6: Color Image Processing
- RGB转灰度 - RGB to grayscale conversion
- RGB转HSV - RGB to HSV conversion
- 彩色增强 - Color enhancement

## 系统要求 - System Requirements

- MATLAB R2018b 或更高版本 - MATLAB R2018b or higher
- Image Processing Toolbox

## 安装与运行 - Installation and Running

1. 克隆或下载此仓库 - Clone or download this repository
2. 在MATLAB中打开项目文件夹 - Open the project folder in MATLAB
3. 运行以下命令启动应用 - Run the following command to launch the app:

```matlab
ImageProcessingApp
```

## 快速开始 - Quick Start

想要快速上手？查看 [快速开始指南 - QUICK_START.md](QUICK_START.md)

Want to get started quickly? Check out the [Quick Start Guide - QUICK_START.md](QUICK_START.md)

## 使用说明 - User Guide

详细的使用说明请参见 [用户手册 - USER_GUIDE.md](USER_GUIDE.md)

For detailed usage instructions, please refer to the [User Guide - USER_GUIDE.md](USER_GUIDE.md)

## 界面截图 - Screenshots

应用程序采用双面板设计：
- 左侧面板：控制面板，包含所有功能按钮
- 右侧面板：图像显示面板，同时显示原始图像和处理后图像

The application features a dual-panel design:
- Left panel: Control panel with all function buttons
- Right panel: Image display panel showing original and processed images side by side

## 项目结构 - Project Structure

```
digital-image-processing/
├── ImageProcessingApp.m           # 主应用程序文件 - Main application file
├── README.md                      # 项目说明 - Project description
├── QUICK_START.md                 # 快速开始指南 - Quick start guide
├── USER_GUIDE.md                  # 用户手册 - User guide
├── TECHNICAL_DOCUMENTATION.md     # 技术文档 - Technical documentation
├── ARCHITECTURE.md                # 架构图 - Architecture diagrams
├── example_usage.m                # 使用示例 - Usage examples
├── test_app.m                     # 测试脚本 - Test script
├── LICENSE                        # MIT许可证 - MIT License
└── .gitignore                     # Git忽略文件 - Git ignore file
```

## 贡献 - Contributing

欢迎提交问题和改进建议！

Issues and improvement suggestions are welcome!

## 许可证 - License

本项目采用 MIT 许可证。

This project is licensed under the MIT License.
