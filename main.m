clear
plot_num = 3;
fs = 500000;%采样频率500kHz

% 1. 读取txt文本中的采样数据
data = importdata('激励信号样本点.txt'); % 将'采样数据.txt'替换为您的文件名
voltage = data(:,2); % 第二列为电压值

% 点数
%N = 2^nextpow2(length(voltage));% 数据长度
%N = length(voltage);
N = 2500;

%时间序列
time = (0:N-1)/fs;

subplot(plot_num,1,1);
plot(time, voltage(1:N), 'b');
xlabel('Time(us)')
ylabel('Voltage')
title('Original Signal')

% 2. 通过快速傅里叶变换,得到数据的频谱,把频谱显示出来

freq = fs*(0:N-1)/N; % 频率向量

fft_voltage = fft(voltage, N); % 快速傅里叶变换
fft_single_sided = abs(fft_voltage(1:N/2)); % 单侧振幅谱
fft_single_sided(1) = fft_single_sided(1)/N;
fft_single_sided(end) = fft_single_sided(end)/N;
fft_single_sided(2:end-1) = fft_single_sided(2:end-1)*2/N;

subplot(plot_num,1,2);
plot(freq(1:N/2),fft_single_sided) % 绘制频谱图
xlabel('Frequency (Hz)') 
ylabel('Amplitude')
title('Frequency Spectrum')

% 3. 搜索频谱主瓣,计算出幅值和频率
%[pks,locs] = findpeaks(fft_single_sided); % 寻找极大值及其位置
[max_pks,max_idx] = max(fft_single_sided); % 寻找最大峰值及其索引
peak_freq = freq(max_idx); % 主瓣频率
peak_amp = max_pks; % 主瓣幅值

fprintf('主瓣位置: %d\n', max_idx)
fprintf('主瓣频率: %.2f Hz\n', peak_freq)
fprintf('主瓣幅值: %.2f\n', peak_amp)

%相角
fft_voltage(abs(fft_voltage) < 0.1) = 0;
signal_theta_vector = angle(fft_voltage);%*180/pi;

signal_theta = -signal_theta_vector(max_idx);
fprintf('相位: %.2f\n', signal_theta)

subplot(plot_num,1,3);
plot(signal_theta_vector);


%平均偏置
signal_average = mean(voltage);
fprintf('偏置: %.2f\n', signal_average)

%欧米伽
w = 2*pi*peak_freq;

t = (0:10*N-1)/fs;
fprintf("表达式: y = %.2fsin(%.2fx%+.2f)%+.2f\n", peak_amp, w, signal_theta, signal_average)
y_new = peak_amp*sin(w*time+signal_theta)+signal_average;

subplot(plot_num,1,1);
hold on
plot(time, y_new, 'r');