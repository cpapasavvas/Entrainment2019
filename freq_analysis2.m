function [freq_array,powers,preserveFreqPower]=freq_analysis2(y,Fs,plot_flag,preserveFreq)
% this version takes an extra input which is a freuency to preserve
% preservefreq can be a frequency that needs to be preserved during the
% harmonics removal

% uses http://www.mathworks.com/support/tech-notes/1700/1702.html

preserveFreqPower = 0;

% y=w_rect'.*y;
% y(y==0)=[];
%y=filter(Hlp,y);

y=y-mean(y);

%applying hamming window
n=0:length(y)-1;
w_hamming=0.54-0.46*cos(2*pi*n/(length(y)-1));
y=y.*w_hamming';
y=3.*y;

% Use next highest power of 2 (+1) greater than or equal to length(x) to calculate FFT.
nfft= 2^(nextpow2(length(y))+1); 

% Take fft, padding with zeros so that length(fftx) is equal to nfft 
fftx = fft(y,nfft); 

% Calculate the numberof unique points
NumUniquePts = ceil((nfft+1)/2); 

% FFT is symmetric, throw away second half 
fftx = fftx(1:NumUniquePts); 

% Take the magnitude of fft of x and scale the fft so that it is not a function of the length of x
mx = abs(fftx)/length(y); 

% Take the square of the magnitude of fft of x. 
mx = mx.^2; 

% Since we dropped half the FFT, we multiply mx by 2 to keep the same energy.
% The DC component and Nyquist component, if it exists, are unique and should not be multiplied by 2.

if rem(nfft, 2) % odd nfft excludes Nyquist point
  mx(2:end) = mx(2:end)*2;
else
  mx(2:end -1) = mx(2:end -1)*2;
end

% This is an evenly spaced frequency vector with NumUniquePts points. 
f = (0:NumUniquePts-1)*Fs/nfft; 

 
mx(1:3)=0;                  %erasing artifact
for k=2:length(mx)-1        %smoothing out some edges
    if mx(k)> 1e-4 && abs(mx(k)-mx(k-1))<5e-5
        mx(k)=mean([mx(k-1) mx(k+1)]);
        % warning('edge smoothing applied');
    end
end

[val,ind]=findpeaks(mx,'THRESHOLD',0,'MINPEAKHEIGHT',1e-5,'SORTSTR','descend');
freq_array=f(ind);

% get the absolute power of the preserveFreq
for i=1:length(freq_array)
    if freq_array(i) >= 0.96*preserveFreq && freq_array(i) <= 1.04*preserveFreq
        preserveFreqPower= val(i);
        break
    end
end

if ~isempty(ind)
    dominant_freq=freq_array(1);
    max_val=val(1);
    mx=mx/max_val;
else
    dominant_freq=0;
end


%detecting and removing the harmonics
for i=length(freq_array):-1:2
    for j=i-1:-1:1
        if (freq_array(i)>1.97*freq_array(j) && freq_array(i)<2.03*freq_array(j)) || ...
              (freq_array(i)>2.96*freq_array(j) && freq_array(i)<3.04*freq_array(j)) || ...
                (freq_array(i)>3.94*freq_array(j) && freq_array(i)<4.06*freq_array(j))
            if freq_array(i) < 0.96*preserveFreq || freq_array(i) > 1.04*preserveFreq
                freq_array(i)=[];
                val(i)=[];
                break
            end
        end
    end
end

powers=(val./sum(val))';


% Generate the plot, title and labels.
if plot_flag
    figure; hold off; plot(f,mx);
    axis([0 70 0 1.1])
    title('Spectrum'); 
    xlabel('Frequency (Hz)'); ylabel('Power');
end
