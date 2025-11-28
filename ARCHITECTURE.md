# 应用程序结构图 - Application Structure Diagram

## 整体架构 - Overall Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    ImageProcessingApp                           │
│                   (MATLAB App Designer)                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │
            ┌─────────────────┴─────────────────┐
            │                                   │
            ▼                                   ▼
    ┌───────────────┐                  ┌───────────────┐
    │  UI Components│                  │  Data Storage │
    │    (界面组件)  │                  │   (数据存储)   │
    └───────────────┘                  └───────────────┘
            │                                   │
            │                                   │
    ┌───────┴───────┐                  ┌────────┴────────┐
    │               │                  │                 │
    ▼               ▼                  ▼                 ▼
┌────────┐    ┌─────────┐      ┌──────────┐    ┌──────────┐
│Control │    │ Display │      │Original  │    │Processed │
│ Panel  │    │ Panels  │      │  Image   │    │  Image   │
└────────┘    └─────────┘      └──────────┘    └──────────┘
```

## 控制面板层次结构 - Control Panel Hierarchy

```
Control Panel (控制面板)
│
├── Basic Controls (基本控制)
│   ├── Load Image Button (加载图像)
│   ├── Save Image Button (保存图像)
│   └── Image Info Label (图像信息)
│
├── Chapter 3 Panel (第三章面板)
│   ├── Histogram Equalization (直方图均衡化)
│   ├── Image Negative (图像反转)
│   ├── Log Transform (对数变换)
│   ├── Gamma Spinner (Gamma参数)
│   ├── Power Transform (幂次变换)
│   ├── Smoothing Filter (平滑滤波)
│   └── Sharpening Filter (锐化滤波)
│
├── Chapter 4 Panel (第四章面板)
│   ├── FFT Display (FFT频谱显示)
│   ├── Low-Pass Filter (低通滤波)
│   └── High-Pass Filter (高通滤波)
│
├── Chapter 5 Panel (第五章面板)
│   ├── Add Gaussian Noise (添加高斯噪声)
│   ├── Add Salt & Pepper Noise (添加椒盐噪声)
│   ├── Mean Filter (均值滤波)
│   └── Median Filter (中值滤波)
│
└── Chapter 6 Panel (第六章面板)
    ├── RGB to Gray (RGB转灰度)
    ├── RGB to HSV (RGB转HSV)
    └── Color Enhancement (彩色增强)
```

## 数据流图 - Data Flow Diagram

```
User Action (用户操作)
      │
      ▼
┌─────────────┐
│ Load Image  │
│  (加载图像)  │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│ OriginalImage   │ ──────────┐
│  CurrentImage   │            │
└─────────┬───────┘            │
          │                    │
          ▼                    │
  ┌───────────────┐            │
  │Select Function│            │
  │  (选择功能)    │            │
  └───────┬───────┘            │
          │                    │
          ▼                    │
  ┌─────────────────┐          │
  │ Process Image   │          │
  │  (处理图像)      │◄─────────┘
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ProcessedImage   │
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ Display Result  │
  │  (显示结果)      │
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │  Save Image?    │
  │  (保存图像?)     │
  └─────────────────┘
```

## 功能模块关系图 - Functional Module Relationships

```
                    ┌──────────────────────┐
                    │  Image I/O Module    │
                    │   (图像输入输出模块)   │
                    └──────────┬───────────┘
                               │
                ┌──────────────┴──────────────┐
                │                             │
                ▼                             ▼
    ┌───────────────────┐         ┌──────────────────┐
    │  Input Processing │         │ Output Processing│
    │   (输入处理)       │         │   (输出处理)      │
    └─────────┬─────────┘         └──────────────────┘
              │
              ▼
    ┌─────────────────────────────────────┐
    │     Image Processing Modules        │
    │       (图像处理模块)                  │
    └─────────────────────────────────────┘
              │
    ┌─────────┼─────────┬─────────┬────────┐
    │         │         │         │        │
    ▼         ▼         ▼         ▼        ▼
┌────────┐┌────────┐┌────────┐┌────────┐┌────────┐
│Chapter2││Chapter3││Chapter4││Chapter5││Chapter6│
│  图像  ││强度变换││频域处理││图像复原││彩色处理│
│  基础  ││空间滤波││        ││        ││        │
└────────┘└────────┘└────────┘└────────┘└────────┘
```

## 处理流程示例 - Processing Flow Example

### 示例1：直方图均衡化 - Example 1: Histogram Equalization

```
Start
  │
  ├─→ Check if image loaded ──No──→ Show error message → End
  │                          
  Yes
  │
  ├─→ Check if RGB image?
  │         │
  │        Yes ──→ Convert to grayscale
  │         │
  │        No
  │         │
  ├─────────┘
  │
  ├─→ Apply histeq()
  │
  ├─→ Store in ProcessedImage
  │
  ├─→ Display in ProcessedImageAxes
  │
End
```

### 示例2：低通滤波 - Example 2: Low-Pass Filtering

```
Start
  │
  ├─→ Check if image loaded ──No──→ Show error message → End
  │                          
  Yes
  │
  ├─→ Convert to grayscale (if needed)
  │
  ├─→ Apply FFT (fft2)
  │
  ├─→ Shift zero frequency (fftshift)
  │
  ├─→ Create Gaussian filter mask
  │
  ├─→ Apply filter in frequency domain
  │
  ├─→ Inverse shift (ifftshift)
  │
  ├─→ Apply IFFT (ifft2)
  │
  ├─→ Convert to uint8
  │
  ├─→ Store and display result
  │
End
```

## UI布局示意图 - UI Layout Schematic

```
┌────────────────────────────────────────────────────────────────┐
│  数字图像处理系统 - Digital Image Processing System            │
├───────────────────┬────────────────────────────────────────────┤
│   控制面板        │           图像显示 - Image Display         │
│  Control Panel    │                                            │
│                   ├──────────────────┬─────────────────────────┤
│ ┌───────────────┐ │  原始图像        │   处理后图像             │
│ │ 加载图像      │ │ Original Image   │  Processed Image        │
│ │ Load Image    │ │                  │                         │
│ └───────────────┘ │  ┌────────────┐  │  ┌────────────┐        │
│ ┌───────────────┐ │  │            │  │  │            │        │
│ │ 保存图像      │ │  │            │  │  │            │        │
│ │ Save Image    │ │  │   Image    │  │  │   Result   │        │
│ └───────────────┘ │  │            │  │  │            │        │
│                   │  │            │  │  │            │        │
│ Image Info:       │  └────────────┘  │  └────────────┘        │
│ Size: 512x512     │                  │                         │
│ Channels: 3       │                  │                         │
│                   │                  │                         │
│ ┌───────────────┐ │                  │                         │
│ │第三章：强度变换│ │                  │                         │
│ │ ┌───────────┐ │ │                  │                         │
│ │ │直方图均衡化│ │ │                  │                         │
│ │ └───────────┘ │ │                  │                         │
│ │ ┌───────────┐ │ │                  │                         │
│ │ │图像反转   │ │ │                  │                         │
│ │ └───────────┘ │ │                  │                         │
│ │     ...       │ │                  │                         │
│ └───────────────┘ │                  │                         │
│                   │                  │                         │
│ [Chapter 4-6...]  │                  │                         │
│                   │                  │                         │
└───────────────────┴──────────────────┴─────────────────────────┘
```

## 类方法调用关系 - Class Method Call Relationships

```
ImageProcessingApp (Constructor)
    │
    ├─→ createComponents()
    │       │
    │       ├─→ Create UIFigure
    │       ├─→ Create GridLayout
    │       ├─→ Create LeftPanel
    │       │       └─→ Create all control buttons
    │       └─→ Create RightPanel
    │               ├─→ Create OriginalImageAxes
    │               └─→ Create ProcessedImageAxes
    │
    ├─→ registerApp()
    │
    └─→ runStartupFcn()
            └─→ startupFcn()

User Interaction
    │
    └─→ Button Callbacks
            ├─→ LoadImageButtonPushed()
            ├─→ SaveImageButtonPushed()
            ├─→ HistogramEqualizationButtonPushed()
            ├─→ ImageNegativeButtonPushed()
            ├─→ LogTransformButtonPushed()
            ├─→ PowerTransformButtonPushed()
            ├─→ SmoothingFilterButtonPushed()
            ├─→ SharpeningFilterButtonPushed()
            ├─→ FFTDisplayButtonPushed()
            ├─→ LowPassFilterButtonPushed()
            ├─→ HighPassFilterButtonPushed()
            ├─→ AddGaussianNoiseButtonPushed()
            ├─→ AddSaltPepperNoiseButtonPushed()
            ├─→ MeanFilterButtonPushed()
            ├─→ MedianFilterButtonPushed()
            ├─→ RGB2GrayButtonPushed()
            ├─→ RGB2HSVButtonPushed()
            └─→ ColorEnhanceButtonPushed()
```

## 状态转换图 - State Transition Diagram

```
     ┌──────────────┐
     │ Initial State│
     │   (初始状态)  │
     └──────┬───────┘
            │
            │ Load Image
            ▼
     ┌──────────────┐
     │Image Loaded  │◄─────┐
     │ (图像已加载)  │      │
     └──────┬───────┘      │
            │              │
            │ Process      │ Load New
            ▼              │
     ┌──────────────┐      │
     │  Processing  │      │
     │  (处理中)     │      │
     └──────┬───────┘      │
            │              │
            │ Complete     │
            ▼              │
     ┌──────────────┐      │
     │Result Ready  │──────┘
     │ (结果就绪)    │
     └──────┬───────┘
            │
            │ Save (optional)
            ▼
     ┌──────────────┐
     │  Image Saved │
     │ (图像已保存)  │
     └──────────────┘
```

## 错误处理流程 - Error Handling Flow

```
Function Called
      │
      ▼
Check: Image Loaded?
      │
      ├─No──→ uialert("Please load an image first!")
      │              │
      │              ▼
      │           Return
      │
     Yes
      │
      ▼
Check: Correct Image Type?
      │
      ├─No──→ uialert("Wrong image type!")
      │              │
      │              ▼
      │           Return
      │
     Yes
      │
      ▼
Process Image
      │
      ▼
Success
```
