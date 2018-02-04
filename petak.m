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

%kreæe moj dio
Pround = round(P);
D = zeros(11,11);
dots = zeros ();
dist = zeros ();
V = zeros ();
alfa = 0.01;

edgeContainer = Pround;
for iteracija = 1:5
    z = 1;
for pos = 1:45
    %koordinate toèke na kojoj se nalazim
    x = Pround (1, pos);
    y = Pround (2, pos);
    
    %tražim matricu 11x11 s centrom u ovoj toèki
    x1 = x-5;
    x2 = x+5;
    y1 = y-5;
    y2 = y+5;
    Gtemp = G(x1:x2,y1:y2);
    if pos-1 == 0
        for i=1:11
            for j=1:11
                D(i,j) = 1 - Gtemp(i,j);
                minBV = 0;
                BcurIteration (i,j)= D(i,j) + minBV;
                dots(i,j,z) =  BcurIteration(i,j);
            end
        end
        V (pos) = 0;
        BprevIteration = BcurIteration;
        z = z + 1;
        
    else
        %koordinate prethodne toèke
        x0 = Pround (1, pos-1);
        y0 = Pround (2, pos-1);

        %idem u petlju po elementima 11x11 matrice i odreðujem matricu B
        for i=1:11
            for j=1:11
                for k=0:10
                    for l=0:10
                        %udaljenost izmeðu ove i prethodne toèke
                        x00 = x0 - 5+k;
                        y00 = y0 - 5+l;
                        x10 = x - 6+i; 
                        y10 = y - 6+j;
                        V (k+1,l+1) = alfa * ((x00-x10)^2+(y00-y10)^2);
                    end
                end         
               
                [minBV, index] = min(min(BprevIteration + V));
                Ttemp(i,j)=index;
                D(i,j) = 1 - Gtemp(i,j);
                BcurIteration(i,j) = D(i,j) + minBV;
                dots (i,j,z) = BcurIteration(i,j);
                T (i,j,z) = Ttemp(i,j);
            end
        end
        BprevIteration = BcurIteration;
        z = z + 1;
    end
    
end

%X45 
tempMatricaOva = dots (:,:,45);
[min45,i45] = min(min(tempMatricaOva));
[x_min, y_min] = ind2sub(size(tempMatricaOva),i45);

x0045 = edgeContainer (1, 45);
y0045 = edgeContainer (2, 45);
xDiffLok45 = 5 - x_min;
yDiffLok45 = 5 - y_min;
xGlob45 = x0045 - xDiffLok45;
yGlob45 = y0045 - yDiffLok45;

edgeContainer(1, 45)=(xGlob45);
edgeContainer(2, 45)=(yGlob45);
    
for lok = 44:-1:2
    tempT = T(:,:,lok+1);
    index_neki = tempT(x_min,y_min);
    
    tempMatricaOvdje = dots (:,:,lok);
    [x_min_temp, y_min_temp] = ind2sub(size(tempMatricaOvdje),index_neki);
    
    x00_temp = edgeContainer (1, lok);
    y00_temp = edgeContainer (2, lok);
    xDiffLokTemp = 5 - x_min_temp;
    yDiffLokTemp = 5 - y_min_temp;
    xGlobTemp = x00_temp - xDiffLokTemp;
    yGlobTemp = y00_temp - yDiffLokTemp;

    edgeContainer(1, lok)=(xGlobTemp);
    edgeContainer(2, lok)=(yGlobTemp);
    x_min = x_min_temp;
    y_min = y_min_temp;
end
end
plot(edgeContainer(1,:),edgeContainer(2,:),'g')
