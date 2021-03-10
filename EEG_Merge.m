clear; close all; clc;

NirsMyDataDir = fullfile('H:','eeg + nirs','EEG_Feat');

subdir_list = {'subject 01_epo_feat','subject 02_epo_feat','subject 03_epo_feat','subject 04_epo_feat','subject 05_epo_feat' ...
    'subject 06_epo_feat','subject 07_epo_feat','subject 08_epo_feat','subject 09_epo_feat','subject 10_epo_feat' ...
    'subject 11_epo_feat','subject 12_epo_feat','subject 13_epo_feat','subject 14_epo_feat','subject 15_epo_feat' ...
    'subject 16_epo_feat','subject 17_epo_feat','subject 18_epo_feat','subject 19_epo_feat','subject 20_epo_feat' ... 
    'subject 21_epo_feat','subject 22_epo_feat','subject 23_epo_feat','subject 24_epo_feat','subject 25_epo_feat' ...
    'subject 26_epo_feat','subject 27_epo_feat','subject 28_epo_feat','subject 29_epo_feat'};

loadDir = fullfile(NirsMyDataDir);

cd(loadDir);
toplamkullanici = length(subdir_list);
imag_data_oxy = zeros(60*toplamkullanici,225);
ment_data_oxy = zeros(60*toplamkullanici,253);

for kullanici = 1:toplamkullanici
    load([subdir_list{kullanici} '.mat']);
    imag_data((kullanici-1)*60+1:kullanici*60,1:225) = [oznitelikler.imag.feat oznitelikler.imag.class];
    ment_data((kullanici-1)*60+1:kullanici*60,1:225) = [oznitelikler.ment.feat oznitelikler.ment.class];
    message = [datestr(datetime) '-> ' num2str(kullanici) '. kullanıcı için öznitelikler ve sınıflar birleştirildi.'];
    disp(message);
end

save('featclassmerge.mat','imag_data','ment_data');
message = [datestr(datetime) '-> ' 'Tüm kullanıcılar için öznitelikler ve sınıflar birleştirildi ve kaydedildi.'];
disp(message);