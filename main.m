clear
plot_num = 3;
fs = 500000;%����Ƶ��500kHz

% 1. ��ȡtxt�ı��еĲ�������
data = importdata('�����ź�������.txt'); % ��'��������.txt'�滻Ϊ�����ļ���
voltage = data(:,2); % �ڶ���Ϊ��ѹֵ

% ����
%N = 2^nextpow2(length(voltage));% ���ݳ���
%N = length(voltage);
N = 2500;

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
fft_single_sided(1) = fft_single_sided(1)/N;
fft_single_sided(end) = fft_single_sided(end)/N;
fft_single_sided(2:end-1) = fft_single_sided(2:end-1)*2/N;

subplot(plot_num,1,2);
plot(freq(1:N/2),fft_single_sided) % ����Ƶ��ͼ
xlabel('Frequency (Hz)') 
ylabel('Amplitude')
title('Frequency Spectrum')

% 3. ����Ƶ������,�������ֵ��Ƶ��
%[pks,locs] = findpeaks(fft_single_sided); % Ѱ�Ҽ���ֵ����λ��
[max_pks,max_idx] = max(fft_single_sided); % Ѱ������ֵ��������
peak_freq = freq(max_idx); % ����Ƶ��
peak_amp = max_pks; % �����ֵ

fprintf('����λ��: %d\n', max_idx)
fprintf('����Ƶ��: %.2f Hz\n', peak_freq)
fprintf('�����ֵ: %.2f\n', peak_amp)

%���
fft_voltage(abs(fft_voltage) < 0.1) = 0;
signal_theta_vector = angle(fft_voltage);%*180/pi;

signal_theta = -signal_theta_vector(max_idx);
fprintf('��λ: %.2f\n', signal_theta)

subplot(plot_num,1,3);
plot(signal_theta_vector);


%ƽ��ƫ��
signal_average = mean(voltage);
fprintf('ƫ��: %.2f\n', signal_average)

%ŷ��٤
w = 2*pi*peak_freq;

t = (0:10*N-1)/fs;
fprintf("���ʽ: y = %.2fsin(%.2fx%+.2f)%+.2f\n", peak_amp, w, signal_theta, signal_average)
y_new = peak_amp*sin(w*time+signal_theta)+signal_average;

subplot(plot_num,1,1);
hold on
plot(time, y_new, 'r');