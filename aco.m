% ACO - Ant Colony Optimization
% Skrypt rozwiazuje problem komiwojazera
% dla zadanej tablicy miast


clear all
%% Parametry sterowania
nrSekcji=0;     % z zakresu 0-4, inaczej siê posypie! nr 10 pokazowy
punkty = [  31.0000  124.5000;
    128.0000   67.5000;
   266.0000   47.5000;
   382.0000  105.5000;
   532.0000  164.5000;
   12.0000  257.5000;
  227.0000  173.5000;
  160.0000  237.5000;
  73.0000  283.5000
  167.0000  366.5000;
  231.0000  404.5000;
  316.0000  309.5000;
  396.0000  380.5000;
  505.0000  347.5000;
  490.0000  461.5000;
  363.0000  479.5000;
  289.0000  443.5000];
feromon_na_mrowke=2;
parowanie_feromonu=0.5;
zerowy_poziom_fer=5;

liczba_cykli=100;     % okresla liczbe mrowek
liczba_iteracji=50; % okrsla liczbe iteracji

%% 1. Generowanie miast 'miasta'
figure;
img = imread('zdjecie.png');
imshow(img)
[x,y] = ginput(17)
TAB = [x,y];
save('TAB')
hold on
plot(x,y,'rx')
hold on
img=StworzMape(nrSekcji);
%%img=RysujPunkty(punkty);
img(:,2:3)=img(:,2:3)*1;
miasta=img;
scatter(miasta(:,2,:), miasta(:,3,:));
xlim([0 600]);
ylim([0 600]);
grid on;
liczbam=size(miasta);
liczbam(:,2)=[];
best_droga=inf;
mat_best_ant=[];
mat_best_droga=[];
iteracja=[];
f=1;
i=0;
hold on



%% 2. Generowanie tablicy polaczen 'p

n=((liczbam*(liczbam-3))/2)+liczbam;
l=liczbam-1;
p=GenerujTablicePolaczen(l, n, zerowy_poziom_fer, miasta);


%% 3. Mrowka - losowanie miast
mat_ant=zeros(liczba_cykli*liczba_iteracji,17);
mat_droga=zeros(liczba_cykli*liczba_iteracji,1);


for xx=1:liczba_iteracji % okrsla liczbe iteracji
for cycle=1:liczba_cykli % okresla liczbe mrowek
ant(1,1)=1;
dostepne_miasta=miasta(:,1);
dostepne_miasta(1,:)=[];
size_p=size(p);


for cykl=1:l
size_ant=size(ant);
dostepne_polaczenia(:,2)=dostepne_miasta(:,1); % miasta dostepne ze ostatniego
dostepne_polaczenia(:,1)=ant(size_ant(1,1),1); % ostatnie odwiedzone miasto

size_dostepne_polaczenia=size(dostepne_polaczenia);

for i=1:size_dostepne_polaczenia(1,1) % generowanie dostepnych polaczen
    for k=1:size_p(1,1)
        if (((dostepne_polaczenia(i,1)==p(k,2)) && (dostepne_polaczenia(i,2)==p(k,3))) || ((dostepne_polaczenia(i,2)==p(k,2)) && (dostepne_polaczenia(i,1)==p(k,3))))
            dostepne_polaczenia(i,4)=p(k,4);
            dostepne_polaczenia(i,3)=p(k,1); % indeks polaczenia
   
        end
    end
end

%okreslanie progow
suma_feromonu_dostepne_polaczenia=sum(dostepne_polaczenia(:,4));
%normalizacja
dostepne_polaczenia(:,6)=0;
for i=1:size_dostepne_polaczenia(1,1)
    dostepne_polaczenia(i,5)=dostepne_polaczenia(i,4)/suma_feromonu_dostepne_polaczenia;
    dostepne_polaczenia(i,6)=sum(dostepne_polaczenia(:,5));
end
prog_dol=[0 ; dostepne_polaczenia(:,6)];
size_prog_dol=size(prog_dol);
prog_dol(size_prog_dol(1,1))=[];
dostepne_polaczenia(:,5)=prog_dol;
%losowanie sciezki
los=rand();
for i=1:size_dostepne_polaczenia(1,1)
    if (dostepne_polaczenia(i,5)<los) && (los<=dostepne_polaczenia(i,6))
        ostatnie_miasto=dostepne_polaczenia(i,2);
    end
end

ant=[ant; ostatnie_miasto];

size_dostepne_miasta=size(dostepne_miasta);

for ii=1:size_dostepne_miasta(1,1)
    if ostatnie_miasto(1,1)==dostepne_miasta(ii,1)
      
        kill=ii;
    end
end

dostepne_miasta(kill,:)=[];

clear dostepne_polaczenia ii

end

clear dostepne_miasta

%% Okreslanie polaczen mrowki

polaczenia_ant1=ant;
polaczenia_ant2=ant;
size_ant=size(ant);

polaczenia_ant1(size_ant(1,1),:)=[];
polaczenia_ant2(1,:)=[];
polaczenia_ant=[polaczenia_ant1 polaczenia_ant2];

clear polaczenia_ant1 polaczenia_ant2
%% sciagniecie dlugosci sciezki
size_polaczenia_ant=size(polaczenia_ant);
for i=1:size_polaczenia_ant(1,1)
    for k=1:size_p(1,1)
        if ((p(k,2)==polaczenia_ant(i,1)) && (p(k,3)==polaczenia_ant(i,2))) || ((p(k,2)==polaczenia_ant(i,2)) && (p(k,3)==polaczenia_ant(i,1)))
            polaczenia_ant(i,3)=p(k,5);
        end
    end
end
droga=sum(polaczenia_ant(:,3));
feromon=feromon_na_mrowke/droga;

%% uzupelnienie feromonu na sciezce
for i=1:size_polaczenia_ant(1,1)
    for k=1:size_p(1,1)
        if ((p(k,2)==polaczenia_ant(i,1)) && (p(k,3)==polaczenia_ant(i,2))) || ((p(k,2)==polaczenia_ant(i,2)) && (p(k,3)==polaczenia_ant(i,1)))
            p(k,6)=p(k,6)+feromon;
        end
    end
end
%% Zamkniecie mrowki
if droga<best_droga
    best_droga=droga;
    best_ant=ant;
    mat_best_ant=[mat_best_ant best_ant];
    mat_best_droga=[mat_best_droga best_droga];
    iteracja=[iteracja xx];
end


ant=ant';
mat_ant(f,:)=ant;
mat_droga(f,:)=droga;
f=f+1;
p(:,4)=p(:,4)+p(:,6);
p(:,6)=0;
clear ant polaczenia_ant
end % KONIEC MROWKI
%parowanie feromonu
parowanie=parowanie_feromonu;
for iii=1:size_p(1,1)
    if p(iii,4)<parowanie
        p(iii,4)=zerowy_poziom_fer;
       
    else
        p(iii,4)=p(iii,4)-parowanie;
        
    end
end
    
end
p;