function [dPhi_noisy_wrap, dPhi_true_wrap, dPhi_true_unwrap, dPhi_noisy_unwrap, Noise_m, AOAVect] = PI_SectorDeltaPhaseGenerator(Freq, Sector, Baseline, dPhiNoise, ConingAngle)
Lambda = 3e8/Freq;
d = Baseline .* 1e-3;
AOAVect = Sector;
n = length(AOAVect);

%--Noisefree---------------------------------------------------------------
dPhi_true_unwrap = zeros(n,3);
for k = 1:3
    dPhi_true_unwrap(:,k) = ((2*pi.*d(k))./Lambda).*sind(Sector);% Radians
end
dPhi_true_unwrap = dPhi_true_unwrap.*cosd(ConingAngle); % Radians
dPhi_true_unwrap = rad2deg(dPhi_true_unwrap); % degrees

dPhi_true_wrap = rem(dPhi_true_unwrap, 360);
for n = 1:n
    for m = 1:3
        if (dPhi_true_wrap(n,m) > 180)
            dPhi_true_wrap(n,m) = dPhi_true_wrap(n,m) - 360;
        elseif (dPhi_true_wrap(n,m) <= -180)
            dPhi_true_wrap(n,m) = dPhi_true_wrap(n,m) + 360;
        end    
    end
end
%---Noisy------------------------------------------------------------------
% Noise_m = randi(2*dPhiNoise, n, 3);
% Noise_m = Noise_m - (dPhiNoise);

Noise_m = dPhiNoise(1) + (dPhiNoise(2) .* randn(n,3));
dPhi_noisy_unwrap = dPhi_true_unwrap + Noise_m;

dPhi_noisy_wrap = rem(dPhi_noisy_unwrap, 360);
for n = 1:n
    for m = 1:3
        if (dPhi_noisy_wrap(n,m) > 180)
            dPhi_noisy_wrap(n,m) = dPhi_noisy_wrap(n,m) - 360;
        elseif (dPhi_noisy_wrap(n,m) <= -180)
            dPhi_noisy_wrap(n,m) = dPhi_noisy_wrap(n,m) + 360;
        end    
    end
end

return