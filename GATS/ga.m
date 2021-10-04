
clc; clear; close all;
feature jit off 

%% Problem Definition  
model=CreateModel();        % Create Model of the Problem  

CostFunction=@(q) MyCost(q,model);       % Cost Function  

nVar =model.nVar;        % Number of Decision Variables  

VarSize=[1 nVar];       % Size of Decision Variables Matrix  

MaxIt=20 ;              % Maximum Number of Iterations  
nPop= 50  ;               % Population Size (Colony Size)  
pc  = 0.8;  %  crossover
pm = 0.2 ; %  mutation

%  tatu list
ActionList=CreatePermActionList( nVar );    % Action List 
nAction=numel(ActionList);              % Number of Actions  
TL= 20 ;      % Tabu Length  
% Initialize Action Tabu Counters   
TC=zeros(nAction,1);
%% Initialization  
  rand( 'seed' ,sum(clock));
% Empty Bee Structure
empty_bee.Position=[];
empty_bee.Cost=[];
empty_bee.sol=[ ];


% Initialize Population Array
pop=repmat(empty_bee,nPop,1);

% Initialize Best Solution Ever Found
BestSol.Cost=inf;

% Create Initial Population  

for i=1:nPop
    pop(i).Position=  randperm(   nVar )  ;
    
    [ pop(i).Cost, pop(i).sol ] =CostFunction(pop(i).Position);
    if pop(i).Cost<=BestSol.Cost
        BestSol=pop(i);
    end
end
 

% Array to Hold Best Cost Values  
BestCost=zeros(MaxIt,1);

%%   Main Loop
newbee= empty_bee;
 for it=1:MaxIt  
    %% selection crossover and mutation operations     
    P =  1./([ pop.Cost  ]) /sum(     1./([ pop.Cost  ])                ) ;
        newpop =repmat(empty_bee,nPop,1);
    for i = 1: nPop
        j=RouletteWheelSelection(P);
        newpop(i) = pop( j );        
    end
    for i = 1: nPop
        if  rand< pc
            
            K=[1:i-1 i+1:nPop];
            k=K(randi([1 numel(K)]));            
            newpop(i).Position   =  crossoveroperation(   newpop(i).Position ,   pop(k).Position ,  nVar);            
        end
    end
    for i = 1: nPop
        if  rand< pm            
            newpop(i).Position = CreateNeighbor( newpop(i).Position  );
        end
    end
    %%  update the costfunction
    for i = 1: nPop
        if  rand< pm            
            [     newpop(i).Cost,    newpop(i).sol ] =CostFunction(    newpop(i).Position  );            
            if pop(i).Cost<BestSol.Cost
                BestSol=pop(i);
            end            
        end
    end
    
    %%  check
    pop=  [ pop; newpop ] ; %newpop ; %[ pop; newpop ];
    [~,IX ] = sort(  [pop.Cost]  );
    pop=pop( IX( 1: nPop ) );       
           %%  tatu search operation
           sol =pop(1);
           bestnewsol = pop(1);
           for i=1:nAction
               if TC(i)==0
                   newsol.Position=DoAction( sol.Position ,ActionList{i} );
                   [ newsol.Cost ,  newsol.sol ]=CostFunction(newsol.Position);
                   newsol.ActionIndex=i ;                   
                   if newsol.Cost<=bestnewsol.Cost
                       bestnewsol = newsol;
                   end                   
               end
           end          
           if sol.Cost == bestnewsol.Cost
               sol =     bestnewsol ;
               sol.ActionIndex = [ ] ;
           else
               sol =     bestnewsol ;
           end
           % Update Tabu List  
           for i=1:nAction
               if i== sol.ActionIndex
                   TC(i)=TL;               % Add To Tabu List
               else
                   TC(i)=max(TC(i)-1,0);   % Reduce Tabu Counter
               end
           end           
           pop(1).Position   =    sol.Position    ;
           pop(1).Cost  =  sol.Cost;
            pop(1).sol = sol.sol;
       %%    
    if pop(1).Cost<=BestSol.Cost
        BestSol=pop(1);
    end        
    %% Store Best Cost Ever Found 
    BestCost(it)=BestSol.Cost;    
    %% Display Iteration Information 
    if BestSol.sol.IsFeasible
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) '    *      '  ]);
    else
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))   ]);
    end       
end
%% plot
figure('NumberTitle', 'off', 'Name', 'line');
set(gcf,'Color',[1 1 1]);
plot(BestCost,'LineWidth',2);
xlabel('current','fontsize',13 );
ylabel('fitness','fontsize',13 );
box off ; grid off;

%%  plot
 PlotSolution( BestSol, model)
