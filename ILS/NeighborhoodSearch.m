function solution = NeighborhoodSearch(s,n,distance)
    z=CalculateCost(s,n,demand,lorry,distance,time);
    solution=s;
    solutioncost=z;
    while(1)
        for i=1:n-3
            j=i+2;
            while j<=n
                solutionprime=s;
                temp1=solutionprime(i+1);
                solutionprime(i+1)=solutionprime(j);
                solutionprime(j)=temp1;
                solutioncostprime=CalculateCost(solutionprime,n,distance);
                if (solutioncostprime >= solutioncost && j<n)
                    j=j+2;
                else
                    j=j+2;
                    if(solutioncostprime<solutioncost)
                        solution=solutionprime;
                        solutioncost=solutioncostprime;
                    end
                end
                
                
            end
        end
        if s == solution
            break
        else
            s=solution;
            z=solutioncost;
        end
    end
end

