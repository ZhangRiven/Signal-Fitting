clear
plot_num = 2;
% 1. 读取txt文本中的采样数据
data = importdata('激励信号样本点.txt'); % 将'采样数据.txt'替换为您的文件名
time = data(1:2048,1); % 第一列为采样时间
voltage = data(1:2048,2); % 第二列为电压值

% 2. 通过快速傅里叶变换,得到数据的频谱,把频谱显示出来
N = 2^nextpow2(length(voltage));% 数据长度
% diff = time(2:N)-time(1:N-1);
%fs = 1000000.0/mean(diff);
fs = 1/(time(2)-time(1)); % 根据采样时间us计算采样频率

freq = fs*(0:N-1)/N; % 频率向量

subplot(plot_num,1,1);
plot(time, voltage, 'b');
xlabel('Time(us)') 
ylabel('Voltage')
title('Original Signal')

fft_voltage = fft(voltage, N); % 快速傅里叶变换
fft_single_sided = abs(fft_voltage(1:N/2)); % 单侧振幅谱

subplot(plot_num,1,2);
plot(freq(1:N/2),fft_single_sided) % 绘制频谱图
xlabel('Frequency (Hz)') 
ylabel('Amplitude')
title('Frequency Spectrum')

% 3. 搜索频谱主瓣,计算出幅值和频率
[pks,locs] = findpeaks(fft_single_sided); % 寻找峰值及其位置
[max_pks,max_idx] = max(pks); % 寻找最大峰值及其索引
peak_freq = freq(locs(max_idx)); % 主瓣频率
peak_amp = max_pks; % 主瓣幅值

fprintf('主瓣频率: %.2f MHz\n', peak_freq)
fprintf('主瓣幅值: %.2f\n', peak_amp)

%相角
signal_theta_vector = angle(fft_voltage);%*180/pi;
signal_theta = signal_theta_vector(locs(max_idx))

%直流分量
signal_average = mean(voltage)

%欧米伽
w = 2*pi*peak_freq

peak_amp

y_new = peak_amp/1000*sin(w*(time)-signal_theta)+signal_average;
subplot(plot_num,1,1);
hold on
plot(time, y_new, 'r');