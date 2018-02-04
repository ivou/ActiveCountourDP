clear all

imgA = imread('bell_blured.png');
imgB = imread('bell_blured_IG.png');
A = imgA(:,:,1);

imshow(imgA)
hold on

load P.txt
P = P';

plot(P(1,:),P(2,:),'o-')
%hold off

G = double(imread('bell_blured_IG.png'));
maxG = max(max(G));
G = G/maxG;

T=P; %T mi je matrica s novim konturama
%for x = 2:(numel(T)-1) %for loop da pormijenim svaki element matrice G i spremam u novu matricu nekiG
  %     T (x) = 3 + T(x);
%end
Pround = round(P);
temp=0;
edgeContainer =Pround;
m=min(G(G>0));
uvjet=1-m;
for  count=1:3
for pos = 2:45
    %tražim toèku predefinirane konture
    x0=edgeContainer(1,pos);
    y0=edgeContainer(2,pos);
    provjera = 1 - G(x0,y0);
    %if ( provjera <= uvjet&& provjera ~= 0) 
    
    %dobio sam poziciju toèke i sada tražim susjednu matricu 11x11 s centrom
    % u x0,y0
    x1=x0-5;
    x2=x0+5;
    y1=y0-5;
    y2=y0+5;
    Vtemp=G(x1:x2,y1:y2);
    mlok=min(Vtemp(Vtemp>0));
    
    %if ~isempty (mlok)
        Dx=1;
        minLocalCoordinateIndex=0;
        s = [11,11];
        for var=1:numel(Vtemp)
            Dx2=1-Vtemp(var);
            if ((Vtemp(var) < 1) && (Vtemp(var) ~= 0) && (Vtemp(var) > mlok))
                Dx=Vtemp(var);
                minLocalCoordinateIndex = var;
            end
        end
        [xmin,ymin] = ind2sub(s,minLocalCoordinateIndex);
        xDiffLok=6-xmin;
        yDiffLok=6-ymin;
        xGlob = x0 - xDiffLok;
        yGlob = y0 - yDiffLok;
        edgeContainer(1, pos)=(xGlob);
        edgeContainer(2, pos)=(yGlob);
        %ideja do while, counter na 0, do while brojaè < 100
    %end   
    
    %end
    
end
end
plot(edgeContainer(1,:),edgeContainer(2,:),'g')

