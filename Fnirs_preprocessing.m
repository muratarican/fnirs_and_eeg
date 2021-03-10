% demo_plot_NIRS
% This file is for plotting nirs-data 
% Most of MATLAB functions are available in BBCI toolbox
% Some minor code modifications might be applied
% We do not guarantee all of functions works properly in your platform
% If you want to see more tutorials, visit BBCI toolbox (https://github.com/bbci/bbci_public)
% specify your nirs data directory (NirsMyDataDir), temporary directory (TemDir) and working directory (WorkingDir)

clear; close all;  clc; 
%%%%%%%%%%%%%%%%%% specify your own directory name %%%%%%%%%%%%%%%%%%%%%%%%
MyToolboxDir = fullfile('h:','eeg + nirs','bbci_public-master');
NirsMyDataDir = fullfile('h:','eeg + nirs','NIRS_01-29');
TemDir = fullfile('h:','eeg + nirs','Temp');
WorkingDir = fullfile('E:','Documents','MATLAB','Nirs');
SaveDir = fullfile('h:','eeg + nirs','NIRS_01-29_epo');
cd(MyToolboxDir);
startup_bbci_toolbox('DataDir',NirsMyDataDir,'TmpDir',TemDir, 'History', 0);
cd(WorkingDir);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subdir_list = {'subject 01','subject 02','subject 03','subject 04','subject 05' ...
    'subject 06','subject 07','subject 08','subject 09','subject 10' ...
    'subject 11','subject 12','subject 13','subject 14','subject 15' ...
    'subject 16','subject 17','subject 18','subject 19','subject 20' ... 
    'subject 21','subject 22','subject 23','subject 24','subject 25' ...
    'subject 26','subject 27','subject 28','subject 29'};
basename_list = {'motor_imagery1','mental_arithmetic1','motor_imagery2','mental_arithmetic2','motor_imagery3','mental_arithmetic3'}; % task type: motor imagery / recording session: 1 - 3
    
% load nirs data
toplamkullanici = length(subdir_list);
for kullanici = 1:toplamkullanici
    loadDir = fullfile(NirsMyDataDir, subdir_list{kullanici});
    cd(loadDir);
    load cnt; load mrk; load mnt;% load continous eeg signal (cnt), marker (mrk) and montage (mnt)

    cd(WorkingDir);

    % temporary variable
    cnt_temp = cnt; mrk_temp = mrk;
    clear cnt mrk;

    % Merge cnts
    [cnt.imag, mrk.imag] = proc_appendCnt({cnt_temp{1}, cnt_temp{3}, cnt_temp{5}}, {mrk_temp{1}, mrk_temp{3}, mrk_temp{5}}); % for motor imagery
    [cnt.ment, mrk.ment] = proc_appendCnt({cnt_temp{2}, cnt_temp{4}, cnt_temp{6}}, {mrk_temp{2}, mrk_temp{4}, mrk_temp{6}}); % for mental arithmetic

    % MBLL
    cnt.imag = proc_BeerLambert(cnt.imag);
    cnt.ment = proc_BeerLambert(cnt.ment);

    % filtering
    [b, a] = butter(3, [0.01 0.09]/cnt.imag.fs*2);
    cnt.imag = proc_filtfilt(cnt.imag, b, a);
    cnt.ment = proc_filtfilt(cnt.ment, b, a);

    %% divide into HbR and HbO
    % cntHb uses same structure with cnt
    cntHb.imag.oxy   = cnt.imag; 
    cntHb.imag.deoxy = cnt.imag; 
    cntHb.ment.oxy   = cnt.ment; 
    cntHb.ment.deoxy = cnt.ment; 

    % replace data
    cntHb.imag.oxy.x = cnt.imag.x(:,1:end/2); 
    cntHb.imag.oxy.clab = cnt.imag.clab(:,1:end/2);
    cntHb.imag.oxy.clab = strrep(cntHb.imag.oxy.clab, 'oxy', ''); % delete 'oxy' in clab
    cntHb.imag.oxy.signal = 'NIRS (oxy)';

    cntHb.imag.deoxy.x = cnt.imag.x(:,end/2+1:end); 
    cntHb.imag.deoxy.clab = cnt.imag.clab(:,end/2+1:end);
    cntHb.imag.deoxy.clab = strrep(cntHb.imag.deoxy.clab, 'deoxy', ''); % delete 'deoxy' in clab
    cntHb.imag.deoxy.signal = 'NIRS (deoxy)'; 

    cntHb.ment.oxy.x = cnt.ment.x(:,1:end/2); 
    cntHb.ment.oxy.clab = cnt.ment.clab(:,1:end/2);
    cntHb.ment.oxy.clab = strrep(cntHb.ment.oxy.clab, 'oxy', ''); % delete 'oxy' in clab
    cntHb.ment.oxy.signal = 'NIRS (oxy)';

    cntHb.ment.deoxy.x = cnt.ment.x(:,end/2+1:end); 
    cntHb.ment.deoxy.clab = cnt.ment.clab(:,end/2+1:end);
    cntHb.ment.deoxy.clab = strrep(cntHb.ment.deoxy.clab, 'deoxy', ''); % delete 'deoxy' in clab
    cntHb.ment.deoxy.signal = 'NIRS (deoxy)'; 

    % epoching
    ival = [-2 10]*1000; % from -10000 to 25000 msec relative to task onset (0 s)

    epo.imag.oxy   = proc_segmentation(cntHb.imag.oxy, mrk.imag, ival);
    epo.imag.deoxy = proc_segmentation(cntHb.imag.deoxy, mrk.imag, ival);
    epo.ment.oxy   = proc_segmentation(cntHb.ment.oxy, mrk.ment, ival);
    epo.ment.deoxy = proc_segmentation(cntHb.ment.deoxy, mrk.ment, ival);

    % baseline correction
    ival_base = [-2 0]*1000;

    epo.imag.oxy   = proc_baseline(epo.imag.oxy, ival_base);
    epo.imag.deoxy = proc_baseline(epo.imag.deoxy, ival_base);
    epo.ment.oxy   = proc_baseline(epo.ment.oxy, ival_base);
    epo.ment.deoxy = proc_baseline(epo.ment.deoxy, ival_base);
    %{
        % draw HbR for mental arithmetic
        fig_set(3, 'Toolsoff', 0);
        grid_plot(epo.ment.deoxy, mnt, 'YLim', [-1 1]*1e-4);
    %}
    epo.imag.oxy.x(1:20,:,:)   = [];
    epo.imag.deoxy.x(1:20,:,:) = [];
    epo.ment.oxy.x(1:20,:,:)   = [];
    epo.ment.deoxy.x(1:20,:,:) = [];
    
    epo.imag.oxy.t(:,1:20)   = [];
    epo.imag.deoxy.t(:,1:20) = [];
    epo.ment.oxy.t(:,1:20)   = [];
    epo.ment.deoxy.t(:,1:20) = [];
    
    cd(SaveDir);
    save([subdir_list{kullanici} '_epo'],'epo');
    message = [datestr(datetime) '-> ' num2str(kullanici) '. kullanýcý için epo kaydedildi.'];
    disp(message);
end
