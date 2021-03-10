function [Feat] = Features(y)
    [uzunluk,kanal,veri] = size(y);
    x =(1:uzunluk);
    Feat = zeros(veri,7*kanal);
    for kanal_sayisi =1:kanal
        for veri_sayisi = 1:veri
            Feat(veri_sayisi,(kanal_sayisi-1)*7+1) = mean(y(:,kanal_sayisi,veri_sayisi));
            Feat(veri_sayisi,(kanal_sayisi-1)*7+2)= max(y(:,kanal_sayisi,veri_sayisi));
            p = polyfit(x,y(:,kanal_sayisi,veri_sayisi)',1);
            Feat(veri_sayisi,(kanal_sayisi-1)*7+3) = p(1);
            Feat(veri_sayisi,(kanal_sayisi-1)*7+4) = skewness(y(:,kanal_sayisi,veri_sayisi));
            Feat(veri_sayisi,(kanal_sayisi-1)*7+5) = kurtosis(y(:,kanal_sayisi,veri_sayisi));
            Feat(veri_sayisi,(kanal_sayisi-1)*7+6)= var(y(:,kanal_sayisi,veri_sayisi));
            Feat(veri_sayisi,(kanal_sayisi-1)*7+7)= median(y(:,kanal_sayisi,veri_sayisi));
        end
    end
end

