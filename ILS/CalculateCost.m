function z = CalculateCost(sol,n,demand,lorry,distance,time)
[L,~,TotalD,~,~]=ParseSolution(sol,n,demand,lorry,distance);
%% Data
speed =1;
lorry=80;
dep = 1;
earl = 25;
lat = 25;
M = 200; % Vehicles maintenance cost
G=100;%fixed cost
E = 1; % transportation cost per unit per mile
    Veh = length(L);
    len = zeros(1,Veh);
    totdem = zeros(1,Veh);
    TC=zeros(1,Veh);
    for j = 1:Veh
        totdem(j) = sum(demand(L{j}));
        len(j)=TotalD(j);
        TC(j)=(E*len(j));
    end  
    
      for j = 1 : Veh
        B = cell2mat(L(j));
        T = time(B,:);
        n = length (B);
        Pen = zeros(1,n);
        Syn = zeros(1,n);
        dt = zeros(1,n);
        t = zeros(1,n);
        lt=zeros(1,n);
        wt=zeros(1,n);
        det=zeros(1,2);
         %For the first part of the route
        dt(1) = Dist(1,B(1)+1);
        det(1,1) = T(1,1)-(dt(1)/speed);
        t(1) = T(1,1);
        if t(1)<T(1,1)
            wt(1)=T(1,1)-t(1);
            lt(1)=T(1,1);
            Pen(1) = earl*(T(1,1)-t(1));
            Syn(1) = 0;
           % Syn(1) = (T(1,1)-t(1));
        elseif t(1)>=T(1,1) & t(1)<=T(1,2)
            wt(1)=0;
            lt(1)=t(1);
            Pen(1)=0;
            Syn(1)=0;
        else
            wt(1)=0;
            lt(1)=t(1);
            Pen(1)=lat*(t(1)-T(1,2));
            Syn(1)=t(1)-T(1,2);
        end
        det(1,2) = lt(1)+(Dist(B(1)+1,1)/speed);
        % For other parts of the route
        for jj = 2:n
            dt(jj) = Dist(B(jj-1)+1,B(jj)+1);
            t(jj) = (dt(jj)/speed)+lt(jj-1);
            if t(jj)<T(jj,1)
                wt(jj)=T(jj,1)-t(jj);
                lt(jj)=T(jj,1);
                Pen(jj) = earl*(T(jj,1)-t(jj));
                Syn(jj) = 0;
                %Syn(jj) = (T(jj,1)-t(jj));
            elseif t(jj)>=T(jj,1) & t(jj)<=T(jj,2)
                wt(jj)=0;
                lt(jj)=t(jj);
                Pen(jj)=0;
                Syn(jj)=0;
            else
                wt(jj)=0;
                lt(jj)=t(jj);
                Pen(jj)=lat*(t(jj)-T(jj,2));
                Syn(jj)=(t(jj)-T(jj,2));
            end
            det(1,2) = lt(n)+(Dist(B(n)+1,1)/speed);
        end
        Penalty{j}=Pen;
        SynC{j}=Syn;
        WT{j}=wt;
        Det{j}=det;
     end
     Spe=0;
     SVT=0;
     SWT=0;
     DET=[];
    for i=1:Veh
        Pe=cell2mat(Penalty(i));
        VT=cell2mat(SynC(i));
        Wt=cell2mat(WT(i));
        DET=[DET;cell2mat(Det(i))];
        Spe=sum(Pe)+Spe;
        SVT=sum(VT)+SVT;
        SWT=sum(Wt)+SWT;
    end
    f1 = sum(TC)+(M*Veh)+Spe;
    f2 =sum(len);
    f3=SVT;
    f4=SWT;
    f5=DET;
z=f1';

end

