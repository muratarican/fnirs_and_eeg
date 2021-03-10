clear; close all;  clc; 
%%%%%%%%%%%%%%%%%% specify your own directory name %%%%%%%%%%%%%%%%%%%%%%%%
MyToolboxDir = fullfile('H:','eeg + nirs','bbci_public-master');
NirsMyDataDir = fullfile('H:','eeg + nirs','EEG Data Set');
TemDir = fullfile('H:','eeg + nirs','Temp');
WorkingDir = fullfile('E:','Documents','MATLAB','Nirs');
SaveDir = fullfile('H:','eeg + nirs','EEG_epo');
startup_bbci_toolbox('DataDir',NirsMyDataDir,'TmpDir',TemDir, 'History', 0);
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
    loadDir = fullfile(NirsMyDataDir, subdir_list{kullanici}, 'with occular artifact');
    cd(loadDir);
    load cnt; load mrk; load mnt;% load continous eeg signal (cnt), marker (mrk) and montage (mnt)
    
    % temporary variable
    cnt_temp = cnt; mrk_temp = mrk;
    clear cnt mrk;
    
    [cnt.imag, mrk.imag] = proc_appendCnt({cnt_temp{1}, cnt_temp{3}, cnt_temp{5}}, {mrk_temp{1}, mrk_temp{3}, mrk_temp{5}}); % for motor imagery
    [cnt.ment, mrk.ment] = proc_appendCnt({cnt_temp{2}, cnt_temp{4}, cnt_temp{6}}, {mrk_temp{2}, mrk_temp{4}, mrk_temp{6}}); % for mental arithmetic
        
    
    % epoching
    ival = [-2 10]*1000; % from -10000 to 25000 msec relative to task onset (0 s)

    epo.imag   = proc_segmentation(cnt.imag, mrk.imag, ival);
    epo.ment   = proc_segmentation(cnt.ment, mrk.ment, ival);
    
    % baseline correction
    ival_base = [-2 0]*1000;

    epo.imag   = proc_baseline(epo.imag, ival_base);
    epo.ment   = proc_baseline(epo.ment, ival_base);
    
    epo.imag.x(1:2*200,:,:)   = [];
    epo.ment.x(1:2*200,:,:)   = [];
    
    epo.imag.t(:,1:2*200)   = [];
    epo.ment.t(:,1:2*200)   = [];
    
    for epok = 1:size(epo.imag.x,3)
        for kanal = 1:size(cnt.imag.x,2)
            epo.imag.x(:,kanal,epok) = vmd(epo.imag.x(:,kanal,epok),'NumIMFs',1,'MaxIterations',100);
            epo.ment.x(:,kanal,epok) = vmd(epo.ment.x(:,kanal,epok),'NumIMFs',1,'MaxIterations',100);
        end
    end
    cd(SaveDir);
    save([subdir_list{kullanici} '_epo'],'epo');
    message = [datestr(datetime) '-> ' num2str(kullanici) '. kullanıcı için epo kaydedildi.'];
    disp(message);
end