clc
clear all
format short
% How to draw lines in matlab
%-x1+3x2=10
%x1+x2=6
%x1-x2=2
%Phase I: To input Parameters
A=[-1 3; 1 1; 1 -1];
B=[10; 6; 2];
% Phase II: To Plot the lines on graph
y1=0:1:max(B);
x11=(B(1)-A(1,1).*y1)./A(1,2);
x21=(B(2)-A(2,1).*y1)./A(2,2);
x31=(B(3)-A(3,1).*y1)./A(3,2);
x11=max(0,x11);
x21=max(0,x21);
x31=max(0,x31);
plot(y1,x11,'r',y1,x21,'b',y1,x31,'g')
title('x1 vs x2');
xlabel('value of x1')
ylabel('value of x2')
legend('-x1+3x2=10','x1+x2=6','x1-x2=2')
grid on
% phase 3: find corner point with axes 
cx1=find(y1==0); %points with x1 axis
c1=find(x11==0);  %points with x2   axis
Line1=[y1(:,[c1 cx1]); x11(:,[c1 cx1])]' ;
c2=find(x21==0);  %points with x2   axis
Line2=[y1(:,[c2 cx1]); x21(:,[c2 cx1])]' ;
c3=find(x31==0);  %points with x2   axis
Line3=[y1(:,[c3 cx1]); x31(:,[c3 cx1])]' ;
corpt=unique([Line1;Line2;Line3],'rows');
%Phase 4: To find the point of intersections
pt=[0;0];
for i=1:size(A,1)
    A1=A(i,:);
    B1=B(i,:);
    for j=i+1:size(A,1)
    A2=A(j,:);
    B2=B(j,:);
    A4=[A1; A2];
    B4=[B1; B2];
    X=A4\B4;
    pt=[pt X];
end
end
 ptt=pt'
 % Phase5: Write all corner points
 allpt=[ptt;corpt];
points=unique(allpt,'rows')
%Phase 6:Find the feasible region of
%-x1+3x2<=10
%x1+x2<=6
%x1-x2<=2
%x1>=0,x2>=0
PT=constraint(points)
P=unique(PT,'rows')
%Phase 7:To find the objective function value of 
%Max z=x1+5x2
c=[1 5]
for i=1:size(P,1)
    fn(i,:)=(sum(P(i,:).*c))
end
ver_fns=[P fn]
%Phase 8: To find the optimal value 
[Optval optposition]=max(fn)
Optval=ver_fns(optposition,:)
OPTIMAL_BFS=array2table(Optval)