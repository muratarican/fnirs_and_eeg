function [ACC,Sens, FPR, PRC, Message_95, Kappa, Conf] = istatistikolc(Real,Predict)
    
    TP = 0; TN = 0; FN = 0; FP = 0;
    for i = 1:length(Real)
        if (Real(i,1) == 1)
            if (Predict(i,1) == 1)
                TP = TP + 1;
            else
                FN = FN + 1;
            end
        else
            if (Predict(i,1) == 1)
                FP = FP + 1;
            else
                TN = TN + 1;
            end
        end
    end

    ACC = (TP + TN) / (TP + TN + FN + FP); 
    Sens = TP / (FN + TP); %Sensivity
    FPR = FN / (TN + FP);
    PRC = TP / (TP + FP);
    ERR = (FP + FN) / (TP + TN + FN + FP);
    % CI_90 = 1.64 * sqrt(ERR * (1 - ERR) / ((TP + TN + FN + FP)));
    CI_95 = 1.96 * sqrt(ERR * (1 - ERR) / ((TP + TN + FN + FP)));
    %CI_98 = 2.33 * sqrt(ERR * (1 - ERR) / ((TP + TN + FN + FP)));
    %CI_99 = 2.58 * sqrt(ERR * (1 - ERR) / ((TP + TN + FN + FP)));
    Conf = [TP FN; FP TN];
    %Message_90 = [num2str(ERR,'%.3f') char(177) num2str(CI_90,'%.3f')];
    Message_95 = [num2str(ERR,'%.3f') char(177) num2str(CI_95,'%.3f')];
    %Message_98 = [num2str(ERR,'%.3f') char(177) num2str(CI_98,'%.3f')];
    %Message_99 = [num2str(ERR,'%.3f') char(177) num2str(CI_99,'%.3f')];
    
    p1 = (TP+FN) / (TP + TN + FN + FP);
    p2 = (TP+FP) / (TP + TN + FN + FP);
    randomACC = p1*p2+(1-p1)*(1-p2);
    
    Kappa = (ACC - randomACC)/(1 - randomACC);
end

