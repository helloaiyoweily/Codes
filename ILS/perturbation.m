
function newSol = perturbation(sol,n)
newSol = sol;
    for i=1:3
        randomIndex1=randi([1,n]);
        randomIndex2=randi([1,n]);
        temp = newSol(randomIndex1);
        newSol(randomIndex1) = newSol(randomIndex2)
        newSol(randomIndex2) = temp;
    end
end
