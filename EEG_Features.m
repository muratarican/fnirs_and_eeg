clear; close all; clc;

NirsMyDataDir = fullfile('H:','eeg + nirs','EEG_epo');
SaveDir = fullfile('H:','eeg + nirs','EEG_Feat');

subdir_list = {'subject 01_epo','subject 02_epo','subject 03_epo','subject 04_epo','subject 05_epo' ...
    'subject 06_epo','subject 07_epo','subject 08_epo','subject 09_epo','subject 10_epo' ...
    'subject 11_epo','subject 12_epo','subject 13_epo','subject 14_epo','subject 15_epo' ...
    'subject 16_epo','subject 17_epo','subject 18_epo','subject 19_epo','subject 20_epo' ... 
    'subject 21_epo','subject 22_epo','subject 23_epo','subject 24_epo','subject 25_epo' ...
    'subject 26_epo','subject 27_epo','subject 28_epo','subject 29_epo'};

loadDir = fullfile(NirsMyDataDir);

toplamkullanici = length(subdir_list);
for kullanici = 1:toplamkullanici
    cd(loadDir);
    load([subdir_list{kullanici} '.mat']);
    [toplamveri,toplamkanal,toplamgozlem] = size(epo.imag.x);

    oznitelikler.imag.feat = zeros(toplamgozlem,7*toplamkanal);
    oznitelikler.ment.feat = zeros(toplamgozlem,7*toplamkanal);
    
    for kanal=1:toplamkanal
        for gozlem = 1:toplamgozlem
            oznitelikler.imag.feat(gozlem,(kanal-1)*7+1:(kanal)*7) = Features(epo.imag.x(:,kanal,gozlem));
            oznitelikler.ment.feat(gozlem,(kanal-1)*7+1:(kanal)*7) = Features(epo.ment.x(:,kanal,gozlem));
        end
    end
    
    oznitelikler.imag.class = epo.imag.event.desc;
    oznitelikler.imag.channelname = epo.imag.clab;
    oznitelikler.imag.classname = epo.imag.className;
    
    oznitelikler.ment.class = epo.ment.event.desc;
    oznitelikler.ment.channelname = epo.ment.clab;
    oznitelikler.ment.classname = epo.ment.className;
    
    cd(SaveDir);
    save([subdir_list{kullanici} '_feat'],'oznitelikler');
    message = [datestr(datetime) '-> ' num2str(kullanici) '. kullanıcı için öznitelikler kaydedildi.'];
    disp(message);
end
