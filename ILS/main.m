clc;
close all;
tic


load data.mat;% including dataset including customers, demands,customers' time window.
distance=Haversinn(a);
 n=size(distance,1);
 StartingSolution=randperm(size(a)); %randperm(n) % Random Permutation
 iterationNumber = 1;

current = NeighborhoodSearch(StartingSolution,n,distance)

while(iterationNumber < 150)

iterationNumber = iterationNumber + 1;
s = perturbation(current, n);
sprime = NeighborhoodSearch(s,n,distance,flow)
    if(CalculateCost(sprime,n,demand,lorry,distance,time) < CalculateCost(current,n,demand,lorry,distance,time))
        current = sprime
    end
end


disp("Best Solution cost ");
costofCurrent = CalculateCost(current,n,demand,lorry,distance,time);
disp(costofCurrent);
disp("Iteration Number")
disp(iterationNumber);	

