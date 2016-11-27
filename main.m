%说明：NYGPS基带信号解调主函数
clear;
close all;
clc;

%-----初始化-----
settings = initSettings();
fprintf('------11------');
probeData(settings);
fprintf('------22------');
%=====postProcessing=====
% Initialization =========================================================
disp ('Starting processing...');

[fid, message] = fopen(settings.fileName, 'rb');

%If success, then process the data
if (fid > 0)
    
    % Move the starting point of processing. Can be used to start the
    % signal processing at any point in the data record (e.g. good for long
    % records or for signal processing in blocks).
    fseek(fid, settings.skipNumberOfBytes, 'bof');

% Acquisition ============================================================

    % Do acquisition if it is not disabled in settings or if the variable
    % acqResults does not exist.
    %if ((settings.skipAcquisition == 0) || ~exist('acqResults', 'var'))
        
        % Find number of samples per spreading code
        samplesPerCode = round(settings.samplingFreq / ...
                           (settings.codeFreqBasis / settings.codeLength));
        
        % Read data for acquisition. 11ms of signal are needed for the fine
        % frequency estimation
        data = fread(fid, 11*samplesPerCode, settings.dataType)';

        %--- Do the acquisition -------------------------------------------
        disp ('   Acquiring satellites...');
        acqResults = acquisition(data, settings);

        plotAcquisition(acqResults);
   % end
end

