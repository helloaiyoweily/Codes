function [ Fitnessval , sol]=MyCost(q,model)

numCustomer =   model.numCustomer ; 
standQ =  model.standQ    ;  
NumVehicle =model.NumVehicle   ;  
Center2CustD= model.Center2CustD ;  
CustD=  model.CustD; 
% Delimiters Position    
DelPos=find(q>  numCustomer );
From=[0 DelPos]+1;
To=[DelPos          numCustomer+NumVehicle ]-1;

% Create List
t=1;
for j=1: NumVehicle
    if ~numel(  q(From(j):To(j)) )
        continue;
    end
    L{ t, 1}=q(From(j):To(j));
    t=t+1;
end
Num_Route = numel(L  );  


empty_rourte.CustomerSequence = [];  
empty_rourte.Load_val  =[ ]; 
empty_rourte.LoadValidation =[ ]; 
empty_rourte.RouteLength=[];  

Detailed_Route =repmat(empty_rourte ,Num_Route  ,1);
ArrivalTime =  zeros(  model.numCustomer , 1 ) ; 

for     t =  1: Num_Route
    
    Detailed_Route( t ).CustomerSequence  =  L{ t, 1};
    
    
    temp =     L{ t, 1};
    Detailed_Route( t ).RouteLength = Center2CustD(  temp(1) )+ Center2CustD(   temp(end)  );
    if  numel(      temp  )>1
        for j = 2: numel( temp )
            Detailed_Route( t ).RouteLength=    Detailed_Route( t ).RouteLength +  CustD(   temp(j-1)       , temp(j)    );
        end
    end
 
    Detailed_Route( t ).Load_val   =  sum( model.Demand( temp ) );
    
    Detailed_Route( t ).LoadValidation = max(0,Detailed_Route( t ).Load_val-model.standQ   );  %  装载量违反约束的程度
    ArrivalTime(  temp(1) ) =   model.Tstart  + Center2CustD(  temp(1) )/model.standV;
    if  numel( temp  )>1
        for j = 2: numel( temp )
            ArrivalTime(  temp( j ) ) =  ArrivalTime(  temp(j-1) )  +  CustD(   temp(j-1)       , temp(j)    )/model.standV ;
        end
    end
    
end

TimeViolationCost  = 0 ;
for i = 1: model.numCustomer
    
    if ArrivalTime( i ) < model.Ej( i )
	TimeViolationCost  = TimeViolationCost + model.c1(i)*( model.Ej( i )-ArrivalTime( i )  ) ;
        continue;
    end
    
    if  ArrivalTime( i ) >model.Tj( i )
	TimeViolationCost  = TimeViolationCost + model.c2(i)*( ArrivalTime( i )-model.Tj( i )) ;% 时间窗
        continue;
    end
    
end
F = model.F*Num_Route  + ...  
    model.A* sum( [Detailed_Route.RouteLength ])  +  ...  
    TimeViolationCost;

Violation =sum([ Detailed_Route.LoadValidation ]) ; 

Fitnessval =  F+model.PenaltyCoefficient* Violation ; 
IsFeasible = ( Violation==0 );

sol.Num_Route = Num_Route ; 
sol.Detailed_Route = Detailed_Route ; 
sol.ArrivalTime=ArrivalTime; 
sol.TimeViolationCost   = TimeViolationCost  ;
sol.Violation  = Violation ; 
sol.F=F;  
sol.Fitnessval = Fitnessval ; 
sol.IsFeasible  = IsFeasible  ; 




