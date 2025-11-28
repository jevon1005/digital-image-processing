% 示例使用脚本 - Example Usage Script
% 此脚本展示了如何启动和使用图像处理应用程序

%% 启动应用程序 - Launch the Application
% 方法1：直接运行类构造函数
app = ImageProcessingApp;

% 注意：应用程序将以图形界面方式打开
% Note: The application will open as a graphical interface

%% 基本使用流程示例 - Basic Usage Flow Example

% 1. 加载图像 - Load Image
%    点击"加载图像"按钮
%    选择一个图像文件（.jpg, .png, .bmp, .tif）

% 2. 查看图像信息 - View Image Information
%    图像加载后，信息会显示在控制面板顶部

% 3. 应用图像处理算法 - Apply Image Processing Algorithms
%    点击相应的功能按钮，例如：
%    - 直方图均衡化：增强对比度
%    - 添加噪声：测试降噪算法
%    - 应用滤波器：平滑或锐化图像

% 4. 保存处理后的图像 - Save Processed Image
%    点击"保存图像"按钮
%    选择保存位置和文件名

%% 典型应用场景 - Typical Application Scenarios

% 场景1：低对比度图像增强
% Scenario 1: Low Contrast Image Enhancement
% 1. 加载低对比度图像
% 2. 点击"直方图均衡化"
% 3. 观察效果并保存

% 场景2：噪声图像复原
% Scenario 2: Noisy Image Restoration
% 1. 加载图像
% 2. 点击"添加椒盐噪声"查看噪声效果
% 3. 点击"中值滤波"去除噪声
% 4. 比较原图和处理结果

% 场景3：图像锐化
% Scenario 3: Image Sharpening
% 1. 加载模糊图像
% 2. 点击"锐化滤波"或"高通滤波"
% 3. 观察边缘增强效果

% 场景4：彩色图像增强
% Scenario 4: Color Image Enhancement
% 1. 加载彩色图像
% 2. 点击"彩色增强"增加饱和度
% 3. 保存增强后的图像

%% 高级功能示例 - Advanced Features Example

% 频率域处理
% Frequency Domain Processing
% 1. 加载图像
% 2. 点击"FFT频谱显示"查看频率分布
% 3. 使用"低通滤波"或"高通滤波"处理图像

% 色彩空间转换
% Color Space Conversion
% 1. 加载彩色图像
% 2. 点击"RGB转HSV"查看HSV空间表示
% 3. 点击"RGB转灰度"转换为灰度图像

%% 注意事项 - Notes

% - 每次处理都基于原始图像，不会累积处理效果
% - Each operation is based on the original image, effects do not accumulate
% 
% - 要在处理结果上继续处理，需要保存后重新加载
% - To process the result further, save and reload it
%
% - 某些功能（如彩色处理）需要特定类型的图像
% - Some features (like color processing) require specific image types
%
% - 可以调整参数（如Gamma值）来获得不同效果
% - You can adjust parameters (like Gamma value) for different effects
