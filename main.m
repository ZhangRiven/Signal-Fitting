clear
plot_num = 2;
fs = 500000;%����Ƶ��500kHz

% 1. ��ȡtxt�ı��еĲ�������
data = importdata('�����ź�������.txt'); % ��'��������.txt'�滻Ϊ�����ļ���
voltage = data(:,2); % �ڶ���Ϊ��ѹֵ

% ����
%N = 2^nextpow2(length(voltage));% ���ݳ���
N = 2048;

%ʱ������
time = (0:N-1)/fs;

subplot(plot_num,1,1);
plot(time, voltage(1:N), 'b');
xlabel('Time(us)')
ylabel('Voltage')
title('Original Signal')

% 2. ͨ�����ٸ���Ҷ�任,�õ����ݵ�Ƶ��,��Ƶ����ʾ����

freq = fs*(0:N-1)/N; % Ƶ������

fft_voltage = fft(voltage, N); % ���ٸ���Ҷ�任
fft_single_sided = abs(fft_voltage(1:N/2)); % ���������

subplot(plot_num,1,2);
plot(freq(1:N/2),fft_single_sided) % ����Ƶ��ͼ
xlabel('Frequency (Hz)') 
ylabel('Amplitude')
title('Frequency Spectrum')

% 3. ����Ƶ������,�������ֵ��Ƶ��
[pks,locs] = findpeaks(fft_single_sided); % Ѱ�Ҽ���ֵ����λ��
[max_pks,max_idx] = max(pks); % Ѱ������ֵ��������
peak_freq = freq(locs(max_idx)); % ����Ƶ��
peak_amp = max_pks; % �����ֵ

fprintf('����λ��: %d\n', locs(max_idx))
fprintf('����Ƶ��: %.2f Hz\n', peak_freq)
fprintf('�����ֵ: %.2f\n', peak_amp)

%���
signal_theta_vector = angle(fft_voltage);%*180/pi;
signal_theta = signal_theta_vector(locs(max_idx));
fprintf('��λ: %.2f\n', signal_theta)

%ƽ��ƫ��
signal_average = mean(voltage);
fprintf('ƫ��: %.2f\n', signal_average)

%ŷ��٤
w = 2*pi*peak_freq;
fprintf("���ʽ: y = %.2fsin(%.2fx%+.2f)%+.2f\n", peak_amp/1000, w, signal_theta, signal_average)
y_new = peak_amp/1000*sin(w*time-signal_theta)+signal_average;

subplot(plot_num,1,1);
hold on
plot(time, y_new, 'r');