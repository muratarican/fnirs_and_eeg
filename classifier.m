clear
clc

load featclassmerge

trainingData = ment_data_eeg_deoxy;
SaveDir = fullfile('H:','eeg + nirs','result','kNN');

[trainedClassifier, validationPredictions,validationAccuracy] = kNN_trainClassifier_3(trainingData);
[a_ACC,b_Sens, c_FPR, d_PRC, g_Message_95, f_Kappa, z_Conf] = istatistikolc(trainingData(:,end),validationPredictions);
filename = [SaveDir '\n_ment_EEG_HbR.mat'];
save(filename,'a_ACC', 'b_Sens', 'c_FPR', 'd_PRC', 'g_Message_95','f_Kappa', 'z_Conf')

w_trainingData = kmccd(trainingData);
[trainedClassifier, validationPredictions,validationAccuracy] = kNN_trainClassifier_3(w_trainingData);
[a_ACC,b_Sens, c_FPR, d_PRC, g_Message_95, f_Kappa, z_Conf] = istatistikolc(w_trainingData(:,end),validationPredictions);
filename = [SaveDir '\kmccd_ment_EEG_HbR.mat'];
save(filename,'a_ACC', 'b_Sens', 'c_FPR', 'd_PRC', 'g_Message_95','f_Kappa', 'z_Conf')

w_trainingData = kmcc(trainingData);
[trainedClassifier, validationPredictions,validationAccuracy] = kNN_trainClassifier_3(w_trainingData);
[a_ACC,b_Sens, c_FPR, d_PRC, g_Message_95, f_Kappa, z_Conf] = istatistikolc(w_trainingData(:,end),validationPredictions);
filename = [SaveDir '\kmcc_ment_EEG_HbR.mat'];
save(filename,'a_ACC', 'b_Sens', 'c_FPR', 'd_PRC', 'g_Message_95','f_Kappa', 'z_Conf')