clear
plot_num = 2;
% 1. ��ȡtxt�ı��еĲ�������
data = importdata('�����ź�������.txt'); % ��'��������.txt'�滻Ϊ�����ļ���
time = data(1:2048,1); % ��һ��Ϊ����ʱ��
voltage = data(1:2048,2); % �ڶ���Ϊ��ѹֵ

% 2. ͨ�����ٸ���Ҷ�任,�õ����ݵ�Ƶ��,��Ƶ����ʾ����
N = 2^nextpow2(length(voltage));% ���ݳ���
% diff = time(2:N)-time(1:N-1);
%fs = 1000000.0/mean(diff);
fs = 1/(time(2)-time(1)); % ���ݲ���ʱ��us�������Ƶ��

freq = fs*(0:N-1)/N; % Ƶ������

subplot(plot_num,1,1);
plot(time, voltage, 'b');
xlabel('Time(us)') 
ylabel('Voltage')
title('Original Signal')

fft_voltage = fft(voltage, N); % ���ٸ���Ҷ�任
fft_single_sided = abs(fft_voltage(1:N/2)); % ���������

subplot(plot_num,1,2);
plot(freq(1:N/2),fft_single_sided) % ����Ƶ��ͼ
xlabel('Frequency (Hz)') 
ylabel('Amplitude')
title('Frequency Spectrum')

% 3. ����Ƶ������,�������ֵ��Ƶ��
[pks,locs] = findpeaks(fft_single_sided); % Ѱ�ҷ�ֵ����λ��
[max_pks,max_idx] = max(pks); % Ѱ������ֵ��������
peak_freq = freq(locs(max_idx)); % ����Ƶ��
peak_amp = max_pks; % �����ֵ

fprintf('����Ƶ��: %.2f MHz\n', peak_freq)
fprintf('�����ֵ: %.2f\n', peak_amp)

%���
signal_theta_vector = angle(fft_voltage);%*180/pi;
signal_theta = signal_theta_vector(locs(max_idx))

%ֱ������
signal_average = mean(voltage)

%ŷ��٤
w = 2*pi*peak_freq

peak_amp

y_new = peak_amp/1000*sin(w*(time)-signal_theta)+signal_average;
subplot(plot_num,1,1);
hold on
plot(time, y_new, 'r');