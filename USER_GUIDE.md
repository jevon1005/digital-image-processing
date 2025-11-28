# 数字图像处理系统用户手册 - Digital Image Processing System User Guide

## 概述 - Overview

这是一个基于MATLAB App Designer开发的数字图像处理软件，实现了数字图像处理教材第2-6章的主要算法。

This is a MATLAB App Designer-based digital image processing application implementing major algorithms from chapters 2-6 of digital image processing textbooks.

## 系统要求 - System Requirements

- MATLAB R2018b 或更高版本 (MATLAB R2018b or higher)
- Image Processing Toolbox

## 启动应用 - Launching the Application

在MATLAB命令窗口中运行：
```matlab
ImageProcessingApp
```

或者在MATLAB编辑器中打开 `ImageProcessingApp.m` 文件并点击"运行"按钮。

## 功能说明 - Features

### 基本操作 - Basic Operations

#### 加载图像 - Load Image
点击"加载图像"按钮，选择要处理的图像文件（支持JPG、PNG、BMP、TIF格式）。
图像将显示在左侧的"原始图像"面板中。

Click "Load Image" button to select an image file (supports JPG, PNG, BMP, TIF formats).
The image will be displayed in the "Original Image" panel on the left.

#### 保存图像 - Save Image
处理完图像后，点击"保存图像"按钮保存处理后的图像。

After processing, click "Save Image" button to save the processed image.

### 第三章：强度变换与空间滤波 - Chapter 3: Intensity Transformations and Spatial Filtering

#### 直方图均衡化 - Histogram Equalization
增强图像对比度，使图像的灰度分布更加均匀。
适用于对比度较低的图像。

Enhances image contrast by equalizing the histogram.
Suitable for low-contrast images.

#### 图像反转 - Image Negative
生成图像的负片效果。
对于彩色图像和灰度图像都有效。

Generates the negative of the image.
Works for both color and grayscale images.

#### 对数变换 - Log Transformation
压缩图像的动态范围，增强暗部细节。
适用于动态范围较大的图像。

Compresses the dynamic range and enhances dark details.
Suitable for images with large dynamic range.

#### 幂次变换 - Power Transformation
使用Gamma值进行幂次变换。
- Gamma < 1: 增强暗部细节
- Gamma > 1: 增强亮部细节
- Gamma = 1: 无变化

Uses Gamma value for power transformation.
- Gamma < 1: Enhances dark details
- Gamma > 1: Enhances bright details
- Gamma = 1: No change

**使用方法**: 调整Gamma值（0.1-5.0），然后点击"幂次变换"按钮。

**Usage**: Adjust Gamma value (0.1-5.0), then click "Power Transform" button.

#### 平滑滤波 - Smoothing Filter
使用均值滤波器平滑图像，减少噪声。
会使图像变得模糊。

Smooths the image using average filter to reduce noise.
May blur the image.

#### 锐化滤波 - Sharpening Filter
增强图像边缘，使图像更加清晰。
使用unsharp滤波器。

Enhances image edges for sharpness.
Uses unsharp filter.

### 第四章：频率域处理 - Chapter 4: Frequency Domain Processing

#### FFT频谱显示 - FFT Spectrum Display
显示图像的傅里叶频谱。
可以观察图像的频率分布特性。

Displays the Fourier spectrum of the image.
Shows frequency distribution characteristics.

#### 低通滤波 - Low-Pass Filter
保留低频成分，去除高频成分。
使图像变得平滑，去除噪声和细节。

Preserves low frequencies and removes high frequencies.
Smooths the image and removes noise and details.

#### 高通滤波 - High-Pass Filter
保留高频成分，去除低频成分。
增强图像边缘和细节。

Preserves high frequencies and removes low frequencies.
Enhances edges and details.

### 第五章：图像复原 - Chapter 5: Image Restoration

#### 添加高斯噪声 - Add Gaussian Noise
向图像添加高斯分布的噪声。
用于测试降噪算法。

Adds Gaussian distributed noise to the image.
For testing denoising algorithms.

#### 添加椒盐噪声 - Add Salt & Pepper Noise
向图像添加椒盐噪声（随机黑白点）。
用于测试中值滤波等降噪算法。

Adds salt and pepper noise (random black and white pixels).
For testing median filtering and other denoising algorithms.

#### 均值滤波 - Mean Filter
使用均值滤波器去除噪声。
对高斯噪声效果较好。

Removes noise using mean filter.
Effective for Gaussian noise.

#### 中值滤波 - Median Filter
使用中值滤波器去除噪声。
对椒盐噪声效果特别好。

Removes noise using median filter.
Particularly effective for salt and pepper noise.

### 第六章：彩色图像处理 - Chapter 6: Color Image Processing

#### RGB转灰度 - RGB to Grayscale
将彩色图像转换为灰度图像。
使用标准的加权平均方法。

Converts color image to grayscale.
Uses standard weighted average method.

#### RGB转HSV - RGB to HSV
将RGB色彩空间转换为HSV色彩空间。
H: 色调, S: 饱和度, V: 明度

Converts RGB color space to HSV color space.
H: Hue, S: Saturation, V: Value

#### 彩色增强 - Color Enhancement
增强图像的饱和度，使颜色更加鲜艳。
通过增加HSV空间中的S分量实现。

Enhances image saturation for more vivid colors.
Achieved by increasing the S component in HSV space.

## 使用技巧 - Tips

1. **处理流程**: 建议先加载图像，查看图像信息，然后根据需要选择相应的处理方法。

2. **对比效果**: 原始图像和处理后图像会同时显示，便于对比效果。

3. **多次处理**: 每次处理都是基于原始图像，如需在处理结果上继续处理，需要先保存，然后重新加载。

4. **参数调整**: 某些功能（如幂次变换）允许调整参数，可以尝试不同的参数值观察效果。

5. **图像格式**: 
   - 灰度处理功能会自动将彩色图像转换为灰度
   - 彩色处理功能需要彩色图像输入

## Tips

1. **Processing Flow**: Load image first, check image info, then select appropriate processing methods.

2. **Compare Results**: Original and processed images are displayed side by side for easy comparison.

3. **Multiple Processing**: Each operation is based on the original image. To process the result further, save it and reload.

4. **Parameter Adjustment**: Some features (like power transformation) allow parameter adjustment. Try different values to observe effects.

5. **Image Format**:
   - Grayscale operations automatically convert color images to grayscale
   - Color operations require color image input

## 故障排除 - Troubleshooting

### 问题：点击按钮没有反应
**解决方法**: 确保已经加载了图像。大多数功能需要先加载图像才能使用。

### Problem: Button clicks have no effect
**Solution**: Make sure an image is loaded first. Most features require an image to be loaded.

### 问题：图像显示不正常
**解决方法**: 
- 检查图像文件是否损坏
- 尝试其他格式的图像
- 确保图像尺寸不要过大（建议小于2000x2000像素）

### Problem: Image display issues
**Solution**:
- Check if image file is corrupted
- Try different image formats
- Ensure image size is not too large (recommended < 2000x2000 pixels)

## 技术支持 - Technical Support

如有问题，请在GitHub仓库中提交Issue。

For issues, please submit an Issue on the GitHub repository.

## 版本信息 - Version Information

- 版本 Version: 1.0.0
- 最后更新 Last Updated: 2025-11-27
