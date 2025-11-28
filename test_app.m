% 测试脚本 - Test Script for ImageProcessingApp
% 此脚本用于验证应用程序代码的基本语法和结构

% Test that the class can be loaded
fprintf('Testing ImageProcessingApp...\n');

% Check if the file exists
if exist('ImageProcessingApp.m', 'file')
    fprintf('✓ ImageProcessingApp.m file found\n');
else
    error('✗ ImageProcessingApp.m file not found');
end

% Try to get class metadata
try
    meta = ?ImageProcessingApp;
    fprintf('✓ Class definition is valid\n');
    fprintf('  Class name: %s\n', meta.Name);
    
    % List methods
    fprintf('  Methods defined: %d\n', length(meta.MethodList));
    
    % List properties
    fprintf('  Properties defined: %d\n', length(meta.PropertyList));
    
catch ME
    fprintf('✗ Error loading class: %s\n', ME.message);
    rethrow(ME);
end

fprintf('\nBasic validation complete!\n');
fprintf('To run the application, execute: ImageProcessingApp\n');
