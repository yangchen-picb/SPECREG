function [D,WVN]=reduce_points(C,WVN,lvonw,lbisw,lanzahl)

if ndims(C)==3
   m=size(C,1);
   n=size(C,2);
   p=size(C,3);
elseif ndims(C)==2   
       m=size(C,1);
       n=1;
       p=size(C,2);
end

y=sort(WVN','descend'); 
z=flipud(reshape(C,m*n,p)');

warning off
%lvon=str2num(get(handles.edit1,'String'));
%lbis=str2num(get(handles.edit2,'String'));
%lvonw=str2num(get(handles.edit3,'String'));
%lbisw=str2num(get(handles.edit4,'String'));
%lanzahl=str2num(get(handles.edit5,'String'));


%lvonw=input('von (Wellenzahl(900))=');
%if(lvonw=='');lvonw=900;end
%lbisw=input('bis (Wellenzahl(3200))=');
%if(lbisw=='');lbisw=3200;end
%lanzahl=input('Anzahl(230)=');
%if(lanzahl=='');lanzahl=230;end

ldiff=(lbisw-lvonw)/(lanzahl);
lstep1=lvonw:ldiff:lbisw;


lnormy=y(length(y):-1:1);

lstep2=(ldiff/2)+lstep1(1:length(lstep1)-1);


%i=1;
%while i<=(length(lstep1)-1)
%   lstepdif(i)=lstep1(i+1)-lstep1(i);
%   i=i+1;
%end
%lstepdif=lstepdif

k=1;
anz=0;
for i=1:length(lnormy)
    if(lnormy(i)<lstep1(1))
        anz=anz+1;
    end
end
lstepanzvor=anz;


for j=1:length(lstep1)
    anz=0;
    for i=1:length(lnormy)
        if(lnormy(i)>=lstep1(j) && lnormy(i)<lstep1(j)+ldiff)
            anz=anz+1;
        end
    end
    lstepanz(j)=anz;
end


tic
%iw=1;
%k=0;
%while iw<=m*n
%lnormz=z(length(y):-1:1,iw); %dreht Spektrum
%k=k+1;
%normx(k)=x(iw);
%iw=iw+1;
%zaehler=lstepanzvor+1;
%for i=1:length(lstep1)
%    normz(i,k)=sum(lnormz(zaehler:(zaehler+lstepanz(i)-1)))/lstepanz(i);
%    zaehler=zaehler+lstepanz(i);
%end
%end

znew=z(length(y):-1:1,:);
zaehler=lstepanzvor+1;
normz=zeros(length(lstep1),size(znew,2));
for i=1:length(lstep1)
    normz(i,:)=sum(znew(zaehler:(zaehler+lstepanz(i)-1),:),1)./lstepanz(i);
    zaehler=zaehler+lstepanz(i);
       X=isnan(normz(i,:));
       if isempty(find(X==false))
          disp('You have lesser wavenumbers then target points!!!');
       end
end
toc



z=normz((length(lstep1)-1):-1:1,:);
%x=x;
y=lstep2(length(lstep2):-1:1);
y=y';


%length(x)
length(y);
length(z(:,1));
length(z(1,:));

warning on

if ndims(C)==3
   D=reshape(flipud(z)',m,n,lanzahl);
elseif ndims(C)==2
       D=reshape(flipud(z)',m,lanzahl);
end
       
WVN=sort(y,'ascend')';

end
