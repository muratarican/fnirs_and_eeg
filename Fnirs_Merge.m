clear; close all; clc;

NirsMyDataDir = fullfile('G:','eeg + nirs','Fnirs_Feat');

subdir_list = {'subject 01_epo_feat','subject 02_epo_feat','subject 03_epo_feat','subject 04_epo_feat','subject 05_epo_feat' ...
    'subject 06_epo_feat','subject 07_epo_feat','subject 08_epo_feat','subject 09_epo_feat','subject 10_epo_feat' ...
    'subject 11_epo_feat','subject 12_epo_feat','subject 13_epo_feat','subject 14_epo_feat','subject 15_epo_feat' ...
    'subject 16_epo_feat','subject 17_epo_feat','subject 18_epo_feat','subject 19_epo_feat','subject 20_epo_feat' ... 
    'subject 21_epo_feat','subject 22_epo_feat','subject 23_epo_feat','subject 24_epo_feat','subject 25_epo_feat' ...
    'subject 26_epo_feat','subject 27_epo_feat','subject 28_epo_feat','subject 29_epo_feat'};

loadDir = fullfile(NirsMyDataDir);

cd(loadDir);
toplamkullanici = length(subdir_list);
imag_data_oxy = zeros(60*toplamkullanici,253);
imag_data_deoxy = zeros(60*toplamkullanici,253);
ment_data_oxy = zeros(60*toplamkullanici,253);
ment_data_deoxy = zeros(60*toplamkullanici,253);

for kullanici = 1:toplamkullanici
    load([subdir_list{kullanici} '.mat']);
    imag_data_oxy((kullanici-1)*60+1:kullanici*60,1:253) = [oznitelikler.imag.oxy.feat oznitelikler.imag.oxy.class];
    imag_data_deoxy((kullanici-1)*60+1:kullanici*60,1:253) = [oznitelikler.imag.deoxy.feat oznitelikler.imag.deoxy.class];
    ment_data_oxy((kullanici-1)*60+1:kullanici*60,1:253) = [oznitelikler.ment.oxy.feat oznitelikler.ment.oxy.class];
    ment_data_deoxy((kullanici-1)*60+1:kullanici*60,1:253) = [oznitelikler.ment.deoxy.feat oznitelikler.ment.deoxy.class];    
    message = [datestr(datetime) '-> ' num2str(kullanici) '. kullanýcý için öznitelikler ve sýnýflar birleþtirildi.'];
    disp(message);
end

imag_data = [imag_data_oxy;imag_data_deoxy];
ment_data = [ment_data_oxy;ment_data_deoxy];

save('featclassmerge.mat','imag_data_oxy','imag_data_deoxy','ment_data_oxy','ment_data_deoxy','imag_data','ment_data');
message = [datestr(datetime) '-> ' 'Tüm kullanýcýlar için öznitelikler ve sýnýflar birleþtirildi ve kaydedildi.'];
disp(message);