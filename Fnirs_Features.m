clear; close all; clc;

NirsMyDataDir = fullfile('G:','eeg + nirs','NIRS_01-29_epo');
SaveDir = fullfile('G:','eeg + nirs','Fnirs_Feat');

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
    [toplamveri,toplamkanal,toplamgozlem] = size(epo.imag.oxy.x);

    oznitelikler.imag.oxy.feat = zeros(toplamgozlem,7*toplamkanal);
    oznitelikler.imag.deoxy.feat = zeros(toplamgozlem,7*toplamkanal);
    oznitelikler.ment.oxy.feat = zeros(toplamgozlem,7*toplamkanal);
    oznitelikler.ment.deoxy.feat = zeros(toplamgozlem,7*toplamkanal);

    for kanal=1:toplamkanal
        for gozlem = 1:toplamgozlem
            oznitelikler.imag.oxy.feat(gozlem,(kanal-1)*7+1:(kanal)*7) = Features(epo.imag.oxy.x(:,kanal,gozlem));
            oznitelikler.imag.deoxy.feat(gozlem,(kanal-1)*7+1:(kanal)*7) = Features(epo.imag.deoxy.x(:,kanal,gozlem));
            oznitelikler.ment.oxy.feat(gozlem,(kanal-1)*7+1:(kanal)*7) = Features(epo.ment.oxy.x(:,kanal,gozlem));
            oznitelikler.ment.deoxy.feat(gozlem,(kanal-1)*7+1:(kanal)*7) = Features(epo.ment.deoxy.x(:,kanal,gozlem));
        end
    end
    
    oznitelikler.imag.oxy.class = epo.imag.oxy.event.desc;
    oznitelikler.imag.oxy.channelname = epo.imag.oxy.clab;
    oznitelikler.imag.oxy.classname = epo.imag.oxy.className;
    
    oznitelikler.imag.deoxy.class = epo.imag.deoxy.event.desc;
    oznitelikler.imag.deoxy.channelname = epo.imag.deoxy.clab;
    oznitelikler.imag.deoxy.classname = epo.imag.deoxy.className;
    
    oznitelikler.ment.oxy.class = epo.ment.oxy.event.desc;
    oznitelikler.ment.oxy.channelname = epo.ment.oxy.clab;
    oznitelikler.ment.oxy.classname = epo.ment.oxy.className;
    
    oznitelikler.ment.deoxy.class = epo.ment.deoxy.event.desc;
    oznitelikler.ment.deoxy.channelname = epo.ment.deoxy.clab;
    oznitelikler.ment.deoxy.classname = epo.ment.deoxy.className;
    
    cd(SaveDir);
    save([subdir_list{kullanici} '_feat'],'oznitelikler');
    message = [datestr(datetime) '-> ' num2str(kullanici) '. kullanýcý için öznitelikler kaydedildi.'];
    disp(message);
end
