%% 1. Specifications
Fs=48000;          % Sampling frequency (Hz)
Fp=1500;           % Passband edge (Hz)
Fs1=2500;          % Stopband edge (Hz)
Ap=0.09;           % Max passband ripple (dB)
As=45;             % Min stopband attenuation (dB)
fmax=6000;         % Max frequency to display (Hz)

%% 2. Elliptic Filter Design
% ellipord finds minimum order meeting specs
% ellip designs filter
[N,Wn]=ellipord(Fp/(Fs/2),Fs1/(Fs/2),Ap,As);
[b,a]=ellip(N,Ap,As,Wn,'low');   % Coefficients
fprintf('Designed elliptic: N=%d\n',N);

%% 3. Frequency Response & Metrics
nfft=2^15;
[H,f]=freqz(b,a,nfft,Fs);        % Frequency response
HdB=20*log10(abs(H)+eps);        % Magnitude in dB
pb=f<=Fp;                        % Passband mask
sb=f>=Fs1 & f<=min(fmax,Fs/2);   % Stopband mask

% Metrics: ripple, attenuation, cutoff frequency
meas_ripple=max(HdB(pb)) - min(HdB(pb));
meas_att_db=-max(HdB(sb));
[~,i]=min(abs(HdB(f>=0.6*Fp & f<=1.1*Fs1)+3));
f_cutoff=f(find(f>=0.6*Fp,1)-1+i);

% Group delay (samples + ms)
gd=grpdelay(b,a,nfft,Fs);
gd_pb=gd(pb);
gd_samples=[min(gd_pb) max(gd_pb)];
gd_ms=gd_samples/Fs*1e3;

%% 4. Test Signal & Filtering
t=(0:2^14-1)'/Fs;   % Time vector
% Composite test: desired tones (200-1200 Hz)
% noise (3-5 kHz), Gaussian noise
x=sin(2*pi*[200 800 1200].*t)*[1;0.8;1.2] + ...
    sin(2*pi*[3000 5000].*t)*[0.7;0.5] + 0.05*randn(size(t));
y=filter(b,a,x);    % Apply filter

%% 5. SNR Improvement Test
% 1 kHz + noise
sig_in=sin(2*pi*1000*t)+0.2*randn(size(t));
% SNR gain
SNR_improve=snr(filter(b,a,sig_in))-snr(sig_in);

%% 6. Fixed-Point Q1.14 Quantization
frac=14;
bq=round(b*2^frac)/2^frac;
aq=round(a*2^frac)/2^frac;
% Max magnitude deviation between float and fixed-point
quant_err=max(abs(HdB-20*log10(abs(freqz(bq,aq,nfft,Fs))+eps)));

%% 7. PSD Estimation (Welch)
[Pin,fpsd]=pwelch(x,hamming(1024),512,4096,Fs);
Pout=pwelch(y,hamming(1024),512,4096,Fs);

%% 8. Validation Report
fprintf('\nGolden IIR Filter Validation Report:\n');
fprintf('Passband (0-%d Hz): Ripple=%.4f dB, Cutoff=%.2f Hz -> %s\n', ...
    Fp,meas_ripple,f_cutoff,passfail(meas_ripple<=0.1));
fprintf('Stopband (%d-%d Hz): Attenuation=%.2f dB -> %s\n', ...
    Fs1,min(fmax,Fs/2),meas_att_db,passfail(meas_att_db>=As));
fprintf('Transition width: %.2f Hz\n',Fs1-Fp);
fprintf('Group delay (passband): %.2f-%.2f samples (%.3f-%.3f ms)\n', ...
    gd_samples,gd_ms);
fprintf('SNR improvement: %.2f dB\n',SNR_improve);
fprintf('Fixed-point (Q1.%d) max error: %.4f dB\n',frac,quant_err);

%% 9. Figures
% Main analysis
figure('Name','Filter Analysis','Units','normalized', ...
    'Position',[0.05 0.05 0.9 0.8]);
subplot(2,2,1); plot(f,HdB,'b'); grid on;
xline(Fp,'g--','Fp'); xline(Fs1,'r--','Fs1');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title('Magnitude Response'); xlim([0 fmax]);

subplot(2,2,2); plot(f,unwrap(angle(H))*180/pi); grid on;
xlabel('Frequency (Hz)'); ylabel('Phase (deg)');
title('Phase Response'); xlim([0 fmax]);

subplot(2,2,3); plot(f,gd); grid on;
xlabel('Frequency (Hz)'); ylabel('Group delay (samples)');
title('Group Delay'); xlim([0 fmax]);

subplot(2,2,4); impz(b,a,256,Fs);
title('Impulse Response');

% Zero-Pole Plot
figure('Name','Zero-Pole Plot');
zplane(b,a);
title('Elliptic Filter Zeros and Poles');
grid on;

% Time-domain vs PSD
figure('Name','Time & PSD','Units','normalized','Position',[0.1 0.1 0.75 0.6]);
subplot(2,1,1); nshow=round(0.01*Fs);
plot(t(1:nshow)*1e3,x(1:nshow),'r',t(1:nshow)*1e3,y(1:nshow),'b');
grid on; xlabel('Time (ms)'); ylabel('Amplitude');
title('Input vs Output - 10 ms'); legend('Input','Filtered');

subplot(2,1,2);
plot(fpsd,10*log10(Pin),'--k','DisplayName','Input PSD'); hold on;
plot(fpsd,10*log10(Pout),'b','DisplayName','Output PSD');
grid on; xlabel('Frequency (Hz)'); ylabel('PSD (dB/Hz)');
title('Noise Shaping'); legend show; xlim([0 fmax]);

%% Helper Function for Pass/Fail reporting
function s = passfail(c)
    s = "FAIL";
    if c, s = "PASS"; end
end