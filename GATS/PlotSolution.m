function PlotSolution( BestSol , model)

% SubPath=BestSol.sol.L;
figure('NumberTitle', 'off', 'Name', 'routes', 'Color',[1 1 1]);  
%%
delt=  0;  
x=model.CustX; 
y=model.CustY; 

kk=[];

for i=1: BestSol.sol.Num_Route
    tour=BestSol.sol.Detailed_Route(i).CustomerSequence  ; 
    xx=[model.CenterX   ; x(tour)  ;  model.CenterX ];
    yy=[ model.CenterY  ; y(tour) ;   model.CenterY ] ;
    
    h=plot( xx,  yy ,'-s',...
        'LineWidth',2,'color',rand(1,3) ,   'MarkerEdgeColor','b', ...
        'MarkerFaceColor','b'  );      hold on
    
    kk=[kk,  h];
    str{i}=['line' num2str(i)  ];
    
end

xx=model.CenterX;
yy=model.CenterY;
[ ch1  ]= plot(xx,yy,'o',...
    'MarkerEdgeColor','r', ...
    'MarkerFaceColor','r', ...
    'MarkerSize',12) ;   hold on


x=model.CustX;
y=model.CustY;
for i=1:  model.numCustomer
    
    xx=x(i);
    yy=y(i);
    [ ch2  ]= plot(xx,yy,'s',...
        'MarkerEdgeColor','b', ...
        'MarkerFaceColor','b', ...
        'MarkerSize',10) ;   hold on
    text(xx+delt,yy-delt, num2str( i) );  
    hold on
end

legend([ ch1 ch2 kk ], [ 'Center'  'customer' str],'Location','SouthWestOutside')

%%
xlabel('X','fontsize',15,'fontname','Times new roman');
ylabel(' Y','fontsize',15,'fontname','Times new roman')

axis on
set(gcf,'Color',[1 1 1]);






