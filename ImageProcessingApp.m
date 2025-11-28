classdef ImageProcessingApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        LeftPanel                       matlab.ui.container.Panel
        ControlsPanel                   matlab.ui.container.Panel
        LoadImageButton                 matlab.ui.control.Button
        SaveImageButton                 matlab.ui.control.Button
        ImageInfoLabel                  matlab.ui.control.Label
        
        % Chapter 3 Controls
        Chapter3Panel                   matlab.ui.container.Panel
        HistogramEqualizationButton     matlab.ui.control.Button
        ImageNegativeButton             matlab.ui.control.Button
        LogTransformButton              matlab.ui.control.Button
        PowerTransformButton            matlab.ui.control.Button
        GammaSpinner                    matlab.ui.control.Spinner
        GammaLabel                      matlab.ui.control.Label
        SmoothingFilterButton           matlab.ui.control.Button
        SharpeningFilterButton          matlab.ui.control.Button
        
        % Chapter 4 Controls
        Chapter4Panel                   matlab.ui.container.Panel
        FFTDisplayButton                matlab.ui.control.Button
        LowPassFilterButton             matlab.ui.control.Button
        HighPassFilterButton            matlab.ui.control.Button
        
        % Chapter 5 Controls
        Chapter5Panel                   matlab.ui.container.Panel
        AddGaussianNoiseButton          matlab.ui.control.Button
        AddSaltPepperNoiseButton        matlab.ui.control.Button
        MeanFilterButton                matlab.ui.control.Button
        MedianFilterButton              matlab.ui.control.Button
        
        % Chapter 6 Controls
        Chapter6Panel                   matlab.ui.container.Panel
        RGB2GrayButton                  matlab.ui.control.Button
        RGB2HSVButton                   matlab.ui.control.Button
        ColorEnhanceButton              matlab.ui.control.Button
        
        % Display panels
        RightPanel                      matlab.ui.container.Panel
        OriginalImagePanel              matlab.ui.container.Panel
        OriginalImageLabel              matlab.ui.control.Label
        OriginalImageAxes               matlab.ui.control.UIAxes
        ProcessedImagePanel             matlab.ui.container.Panel
        ProcessedImageLabel             matlab.ui.control.Label
        ProcessedImageAxes              matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        OriginalImage % Original loaded image
        ProcessedImage % Processed image
        CurrentImage % Current working image
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Initialize the app
        end

        % Button pushed function: LoadImageButton
        function LoadImageButtonPushed(app, event)
            [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Image Files'});
            if filename ~= 0
                filepath = fullfile(pathname, filename);
                app.OriginalImage = imread(filepath);
                app.CurrentImage = app.OriginalImage;
                
                % Display original image
                imshow(app.OriginalImage, 'Parent', app.OriginalImageAxes);
                
                % Display image info
                [rows, cols, channels] = size(app.OriginalImage);
                info_text = sprintf('Size: %dx%d, Channels: %d, Class: %s', ...
                    rows, cols, channels, class(app.OriginalImage));
                app.ImageInfoLabel.Text = info_text;
            end
        end

        % Button pushed function: SaveImageButton
        function SaveImageButtonPushed(app, event)
            if ~isempty(app.ProcessedImage)
                [filename, pathname] = uiputfile({'*.jpg', 'JPEG'; '*.png', 'PNG'; '*.bmp', 'BMP'}, 'Save Image');
                if filename ~= 0
                    filepath = fullfile(pathname, filename);
                    imwrite(app.ProcessedImage, filepath);
                    uialert(app.UIFigure, 'Image saved successfully!', 'Success');
                end
            else
                uialert(app.UIFigure, 'No processed image to save!', 'Error');
            end
        end

        % Chapter 3: Histogram Equalization
        function HistogramEqualizationButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            if size(app.CurrentImage, 3) == 3
                % Convert to grayscale if RGB
                gray_img = rgb2gray(app.CurrentImage);
            else
                gray_img = app.CurrentImage;
            end
            
            app.ProcessedImage = histeq(gray_img);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 3: Image Negative
        function ImageNegativeButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            app.ProcessedImage = imcomplement(app.CurrentImage);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 3: Log Transformation
        function LogTransformButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            img = im2double(app.CurrentImage);
            c = 1 / log(1 + max(img(:)));
            app.ProcessedImage = c * log(1 + img);
            app.ProcessedImage = im2uint8(app.ProcessedImage);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 3: Power Transformation
        function PowerTransformButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            img = im2double(app.CurrentImage);
            gamma = app.GammaSpinner.Value;
            app.ProcessedImage = img .^ gamma;
            app.ProcessedImage = im2uint8(app.ProcessedImage);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 3: Smoothing Filter
        function SmoothingFilterButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            h = fspecial('average', [5 5]);
            app.ProcessedImage = imfilter(app.CurrentImage, h);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 3: Sharpening Filter
        function SharpeningFilterButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            h = fspecial('unsharp');
            app.ProcessedImage = imfilter(app.CurrentImage, h);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 4: FFT Display
        function FFTDisplayButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            if size(app.CurrentImage, 3) == 3
                gray_img = rgb2gray(app.CurrentImage);
            else
                gray_img = app.CurrentImage;
            end
            
            F = fft2(double(gray_img));
            F_shifted = fftshift(F);
            magnitude_spectrum = log(1 + abs(F_shifted));
            app.ProcessedImage = mat2gray(magnitude_spectrum);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 4: Low-Pass Filter
        function LowPassFilterButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            if size(app.CurrentImage, 3) == 3
                gray_img = rgb2gray(app.CurrentImage);
            else
                gray_img = app.CurrentImage;
            end
            
            [M, N] = size(gray_img);
            F = fft2(double(gray_img));
            F_shifted = fftshift(F);
            
            % Create low-pass filter (Gaussian)
            D0 = 30;
            [X, Y] = meshgrid(1:N, 1:M);
            centerX = ceil(N/2);
            centerY = ceil(M/2);
            D = sqrt((X - centerX).^2 + (Y - centerY).^2);
            H = exp(-(D.^2) / (2*(D0^2)));
            
            % Apply filter
            G = H .* F_shifted;
            G_shifted = ifftshift(G);
            filtered = real(ifft2(G_shifted));
            app.ProcessedImage = uint8(filtered);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 4: High-Pass Filter
        function HighPassFilterButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            if size(app.CurrentImage, 3) == 3
                gray_img = rgb2gray(app.CurrentImage);
            else
                gray_img = app.CurrentImage;
            end
            
            [M, N] = size(gray_img);
            F = fft2(double(gray_img));
            F_shifted = fftshift(F);
            
            % Create high-pass filter (Gaussian)
            D0 = 30;
            [X, Y] = meshgrid(1:N, 1:M);
            centerX = ceil(N/2);
            centerY = ceil(M/2);
            D = sqrt((X - centerX).^2 + (Y - centerY).^2);
            H = 1 - exp(-(D.^2) / (2*(D0^2)));
            
            % Apply filter
            G = H .* F_shifted;
            G_shifted = ifftshift(G);
            filtered = real(ifft2(G_shifted));
            filtered = mat2gray(filtered);
            app.ProcessedImage = uint8(filtered * 255);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 5: Add Gaussian Noise
        function AddGaussianNoiseButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            app.ProcessedImage = imnoise(app.CurrentImage, 'gaussian', 0, 0.01);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 5: Add Salt & Pepper Noise
        function AddSaltPepperNoiseButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            app.ProcessedImage = imnoise(app.CurrentImage, 'salt & pepper', 0.05);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 5: Mean Filter
        function MeanFilterButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            h = fspecial('average', [5 5]);
            app.ProcessedImage = imfilter(app.CurrentImage, h);
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 5: Median Filter
        function MedianFilterButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            if size(app.CurrentImage, 3) == 3
                app.ProcessedImage = app.CurrentImage;
                for i = 1:3
                    app.ProcessedImage(:,:,i) = medfilt2(app.CurrentImage(:,:,i));
                end
            else
                app.ProcessedImage = medfilt2(app.CurrentImage);
            end
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
        end

        % Chapter 6: RGB to Grayscale
        function RGB2GrayButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            if size(app.CurrentImage, 3) == 3
                app.ProcessedImage = rgb2gray(app.CurrentImage);
                imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
            else
                uialert(app.UIFigure, 'Image is already grayscale!', 'Info');
            end
        end

        % Chapter 6: RGB to HSV
        function RGB2HSVButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            if size(app.CurrentImage, 3) == 3
                hsv_img = rgb2hsv(app.CurrentImage);
                app.ProcessedImage = hsv_img;
                imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
            else
                uialert(app.UIFigure, 'Please load a color image!', 'Error');
            end
        end

        % Chapter 6: Color Enhancement
        function ColorEnhanceButtonPushed(app, event)
            if isempty(app.CurrentImage)
                uialert(app.UIFigure, 'Please load an image first!', 'Error');
                return;
            end
            
            if size(app.CurrentImage, 3) == 3
                hsv_img = rgb2hsv(app.CurrentImage);
                hsv_img(:,:,2) = hsv_img(:,:,2) * 1.5; % Increase saturation
                hsv_img(:,:,2) = min(hsv_img(:,:,2), 1); % Clamp to [0, 1]
                app.ProcessedImage = hsv2rgb(hsv_img);
                imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
            else
                uialert(app.UIFigure, 'Please load a color image!', 'Error');
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1200 700];
            app.UIFigure.Name = '数字图像处理系统 - Digital Image Processing';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x', '2x'};
            app.GridLayout.RowHeight = {'1x'};

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Title = '控制面板 - Control Panel';
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create controls in LeftPanel
            controlsLayout = uigridlayout(app.LeftPanel);
            controlsLayout.RowHeight = repmat({'fit'}, 1, 30);
            controlsLayout.ColumnWidth = {'1x'};

            % Basic Controls
            app.LoadImageButton = uibutton(controlsLayout, 'push');
            app.LoadImageButton.Text = '加载图像 - Load Image';
            app.LoadImageButton.Layout.Row = 1;
            app.LoadImageButton.Layout.Column = 1;
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);

            app.SaveImageButton = uibutton(controlsLayout, 'push');
            app.SaveImageButton.Text = '保存图像 - Save Image';
            app.SaveImageButton.Layout.Row = 2;
            app.SaveImageButton.Layout.Column = 1;
            app.SaveImageButton.ButtonPushedFcn = createCallbackFcn(app, @SaveImageButtonPushed, true);

            app.ImageInfoLabel = uilabel(controlsLayout);
            app.ImageInfoLabel.Text = 'Image Info: No image loaded';
            app.ImageInfoLabel.Layout.Row = 3;
            app.ImageInfoLabel.Layout.Column = 1;

            % Chapter 3 Panel
            app.Chapter3Panel = uipanel(controlsLayout);
            app.Chapter3Panel.Title = '第三章：强度变换与空间滤波';
            app.Chapter3Panel.Layout.Row = 4;
            app.Chapter3Panel.Layout.Column = 1;
            
            ch3Layout = uigridlayout(app.Chapter3Panel);
            ch3Layout.RowHeight = repmat({'fit'}, 1, 9);
            ch3Layout.ColumnWidth = {'1x', 'fit'};

            app.HistogramEqualizationButton = uibutton(ch3Layout, 'push');
            app.HistogramEqualizationButton.Text = '直方图均衡化';
            app.HistogramEqualizationButton.Layout.Row = 1;
            app.HistogramEqualizationButton.Layout.Column = [1 2];
            app.HistogramEqualizationButton.ButtonPushedFcn = createCallbackFcn(app, @HistogramEqualizationButtonPushed, true);

            app.ImageNegativeButton = uibutton(ch3Layout, 'push');
            app.ImageNegativeButton.Text = '图像反转';
            app.ImageNegativeButton.Layout.Row = 2;
            app.ImageNegativeButton.Layout.Column = [1 2];
            app.ImageNegativeButton.ButtonPushedFcn = createCallbackFcn(app, @ImageNegativeButtonPushed, true);

            app.LogTransformButton = uibutton(ch3Layout, 'push');
            app.LogTransformButton.Text = '对数变换';
            app.LogTransformButton.Layout.Row = 3;
            app.LogTransformButton.Layout.Column = [1 2];
            app.LogTransformButton.ButtonPushedFcn = createCallbackFcn(app, @LogTransformButtonPushed, true);

            app.GammaLabel = uilabel(ch3Layout);
            app.GammaLabel.Text = 'Gamma:';
            app.GammaLabel.Layout.Row = 4;
            app.GammaLabel.Layout.Column = 1;

            app.GammaSpinner = uispinner(ch3Layout);
            app.GammaSpinner.Value = 1.0;
            app.GammaSpinner.Limits = [0.1 5.0];
            app.GammaSpinner.Step = 0.1;
            app.GammaSpinner.Layout.Row = 4;
            app.GammaSpinner.Layout.Column = 2;

            app.PowerTransformButton = uibutton(ch3Layout, 'push');
            app.PowerTransformButton.Text = '幂次变换';
            app.PowerTransformButton.Layout.Row = 5;
            app.PowerTransformButton.Layout.Column = [1 2];
            app.PowerTransformButton.ButtonPushedFcn = createCallbackFcn(app, @PowerTransformButtonPushed, true);

            app.SmoothingFilterButton = uibutton(ch3Layout, 'push');
            app.SmoothingFilterButton.Text = '平滑滤波';
            app.SmoothingFilterButton.Layout.Row = 6;
            app.SmoothingFilterButton.Layout.Column = [1 2];
            app.SmoothingFilterButton.ButtonPushedFcn = createCallbackFcn(app, @SmoothingFilterButtonPushed, true);

            app.SharpeningFilterButton = uibutton(ch3Layout, 'push');
            app.SharpeningFilterButton.Text = '锐化滤波';
            app.SharpeningFilterButton.Layout.Row = 7;
            app.SharpeningFilterButton.Layout.Column = [1 2];
            app.SharpeningFilterButton.ButtonPushedFcn = createCallbackFcn(app, @SharpeningFilterButtonPushed, true);

            % Chapter 4 Panel
            app.Chapter4Panel = uipanel(controlsLayout);
            app.Chapter4Panel.Title = '第四章：频率域处理';
            app.Chapter4Panel.Layout.Row = 5;
            app.Chapter4Panel.Layout.Column = 1;
            
            ch4Layout = uigridlayout(app.Chapter4Panel);
            ch4Layout.RowHeight = repmat({'fit'}, 1, 3);
            ch4Layout.ColumnWidth = {'1x'};

            app.FFTDisplayButton = uibutton(ch4Layout, 'push');
            app.FFTDisplayButton.Text = 'FFT频谱显示';
            app.FFTDisplayButton.Layout.Row = 1;
            app.FFTDisplayButton.ButtonPushedFcn = createCallbackFcn(app, @FFTDisplayButtonPushed, true);

            app.LowPassFilterButton = uibutton(ch4Layout, 'push');
            app.LowPassFilterButton.Text = '低通滤波';
            app.LowPassFilterButton.Layout.Row = 2;
            app.LowPassFilterButton.ButtonPushedFcn = createCallbackFcn(app, @LowPassFilterButtonPushed, true);

            app.HighPassFilterButton = uibutton(ch4Layout, 'push');
            app.HighPassFilterButton.Text = '高通滤波';
            app.HighPassFilterButton.Layout.Row = 3;
            app.HighPassFilterButton.ButtonPushedFcn = createCallbackFcn(app, @HighPassFilterButtonPushed, true);

            % Chapter 5 Panel
            app.Chapter5Panel = uipanel(controlsLayout);
            app.Chapter5Panel.Title = '第五章：图像复原';
            app.Chapter5Panel.Layout.Row = 6;
            app.Chapter5Panel.Layout.Column = 1;
            
            ch5Layout = uigridlayout(app.Chapter5Panel);
            ch5Layout.RowHeight = repmat({'fit'}, 1, 4);
            ch5Layout.ColumnWidth = {'1x'};

            app.AddGaussianNoiseButton = uibutton(ch5Layout, 'push');
            app.AddGaussianNoiseButton.Text = '添加高斯噪声';
            app.AddGaussianNoiseButton.Layout.Row = 1;
            app.AddGaussianNoiseButton.ButtonPushedFcn = createCallbackFcn(app, @AddGaussianNoiseButtonPushed, true);

            app.AddSaltPepperNoiseButton = uibutton(ch5Layout, 'push');
            app.AddSaltPepperNoiseButton.Text = '添加椒盐噪声';
            app.AddSaltPepperNoiseButton.Layout.Row = 2;
            app.AddSaltPepperNoiseButton.ButtonPushedFcn = createCallbackFcn(app, @AddSaltPepperNoiseButtonPushed, true);

            app.MeanFilterButton = uibutton(ch5Layout, 'push');
            app.MeanFilterButton.Text = '均值滤波';
            app.MeanFilterButton.Layout.Row = 3;
            app.MeanFilterButton.ButtonPushedFcn = createCallbackFcn(app, @MeanFilterButtonPushed, true);

            app.MedianFilterButton = uibutton(ch5Layout, 'push');
            app.MedianFilterButton.Text = '中值滤波';
            app.MedianFilterButton.Layout.Row = 4;
            app.MedianFilterButton.ButtonPushedFcn = createCallbackFcn(app, @MedianFilterButtonPushed, true);

            % Chapter 6 Panel
            app.Chapter6Panel = uipanel(controlsLayout);
            app.Chapter6Panel.Title = '第六章：彩色图像处理';
            app.Chapter6Panel.Layout.Row = 7;
            app.Chapter6Panel.Layout.Column = 1;
            
            ch6Layout = uigridlayout(app.Chapter6Panel);
            ch6Layout.RowHeight = repmat({'fit'}, 1, 3);
            ch6Layout.ColumnWidth = {'1x'};

            app.RGB2GrayButton = uibutton(ch6Layout, 'push');
            app.RGB2GrayButton.Text = 'RGB转灰度';
            app.RGB2GrayButton.Layout.Row = 1;
            app.RGB2GrayButton.ButtonPushedFcn = createCallbackFcn(app, @RGB2GrayButtonPushed, true);

            app.RGB2HSVButton = uibutton(ch6Layout, 'push');
            app.RGB2HSVButton.Text = 'RGB转HSV';
            app.RGB2HSVButton.Layout.Row = 2;
            app.RGB2HSVButton.ButtonPushedFcn = createCallbackFcn(app, @RGB2HSVButtonPushed, true);

            app.ColorEnhanceButton = uibutton(ch6Layout, 'push');
            app.ColorEnhanceButton.Text = '彩色增强';
            app.ColorEnhanceButton.Layout.Row = 3;
            app.ColorEnhanceButton.ButtonPushedFcn = createCallbackFcn(app, @ColorEnhanceButtonPushed, true);

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Title = '图像显示 - Image Display';
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create display layout
            displayLayout = uigridlayout(app.RightPanel);
            displayLayout.RowHeight = {'1x'};
            displayLayout.ColumnWidth = {'1x', '1x'};

            % Original Image Panel
            app.OriginalImagePanel = uipanel(displayLayout);
            app.OriginalImagePanel.Title = '原始图像 - Original Image';
            app.OriginalImagePanel.Layout.Row = 1;
            app.OriginalImagePanel.Layout.Column = 1;

            origLayout = uigridlayout(app.OriginalImagePanel);
            origLayout.RowHeight = {'1x'};
            origLayout.ColumnWidth = {'1x'};

            app.OriginalImageAxes = uiaxes(origLayout);
            app.OriginalImageAxes.Layout.Row = 1;
            app.OriginalImageAxes.Layout.Column = 1;
            app.OriginalImageAxes.XTick = [];
            app.OriginalImageAxes.YTick = [];

            % Processed Image Panel
            app.ProcessedImagePanel = uipanel(displayLayout);
            app.ProcessedImagePanel.Title = '处理后图像 - Processed Image';
            app.ProcessedImagePanel.Layout.Row = 1;
            app.ProcessedImagePanel.Layout.Column = 2;

            procLayout = uigridlayout(app.ProcessedImagePanel);
            procLayout.RowHeight = {'1x'};
            procLayout.ColumnWidth = {'1x'};

            app.ProcessedImageAxes = uiaxes(procLayout);
            app.ProcessedImageAxes.Layout.Row = 1;
            app.ProcessedImageAxes.Layout.Column = 1;
            app.ProcessedImageAxes.XTick = [];
            app.ProcessedImageAxes.YTick = [];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ImageProcessingApp

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
