function [data] = kmcc(temp)
    class1 = find(temp(:,end) == 1);
    class2 = find(temp(:,end) == 2);

    data_class1 = temp((class1),:);
    data_class2 = temp((class2),:);

    A=data_class1(:,1:end-1);
    B=data_class2(:,1:end-1);

    data =[A
        B];

    [c,mu] = kmeans(data,2);

    c=mu;

    [n,m]=size(A);
    [n1,m1]=size(B);

    d_mean_1=mean(A,1);
    d_mean_2=mean(B,1);

    for i=1:m
        fark_1(i,1)=(d_mean_1(1,i)/c(1,i));
    end

    fark_1=fark_1';

    for i=1:m1
        fark_2(i,1)=(d_mean_2(1,i)/c(2,i));
    end

    fark_2=fark_2';

    for i=1:m
        data_class_1_kmc_weighted(:,i)=(A(:,i)*fark_1(:,i));
    end

    for i=1:m1
        data_class_2_kmc_weighted(:,i)=(B(:,i)*fark_2(:,i));
    end

    data_class_1_kmc_weighted = [data_class_1_kmc_weighted data_class1(:,end)];
    data_class_2_kmc_weighted = [data_class_2_kmc_weighted data_class2(:,end)];

    data=[data_class_1_kmc_weighted
        data_class_2_kmc_weighted];
end

