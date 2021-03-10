function [data] = kmccd(temp)
    class1 = find(temp(:,end) == 1);
    class2 = find(temp(:,end) == 2);

    data_class1 = temp((class1),:);
    data_class2 = temp((class2),:);

    A = data_class1(:,1:end-1);
    B = data_class2(:,1:end-1);

    x =[A
        B];

    [c,mu] = kmeans(x,2);

    c=mu;

    [n,m]=size(A);
    [n1,m1]=size(B);
    d_mean_1=mean(A,1);
    d_mean_2=mean(B,1);

    for j=1:n
        for i=1:m
            fark_1(j,i)=abs(A(j,i)-c(1,i));
        end
    end

    fark_mean1=mean(fark_1,1);


    for i=1:m
        if c(1,i)==0
            c(1,i)=1;
        end
        weight1(1,i)=fark_mean1(1,i)/c(1,i);
    end

    for j=1:n1
        for i=1:m1
            fark_2(j,i)=abs(B(j,i)-c(2,i));
        end
    end

    fark_mean2=mean(fark_2,1);

    for i=1:m1
        if c(2,i)==0
            c(2,i)=1;
        end
        weight2(1,i)=fark_mean2(1,i)/c(2,i);
    end

    for i=1:m
        data_kmeans_new_mes_1_kmeans_weighted(:,i)=(A(:,i)*weight1(:,i));
    end

    for i=1:m1
        data_kmeans_new_mes_2_kmeans_weighted(:,i)=(B(:,i)*weight2(:,i));
    end

    data_kmeans_new_mes_1_kmeans_weighted = [data_kmeans_new_mes_1_kmeans_weighted data_class1(:,end)];
    data_kmeans_new_mes_2_kmeans_weighted = [data_kmeans_new_mes_2_kmeans_weighted data_class2(:,end)];

    data = [data_kmeans_new_mes_1_kmeans_weighted ; data_kmeans_new_mes_2_kmeans_weighted];
end

