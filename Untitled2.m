img = imread('zdjecie.png');
imshow(img)

%%worldmap('Europe')
hold on
[x,y] = ginput(17)
TAB = [x,y]
%Nazwy= ['Szczecin';'Koszalin';'Gdańsk';'Olsztyn';'Białystok';'Warszawa';'Bydgoszcz';'Poznań';'Zielona Góra';'Wrocław';'Opole';'Łódź';'Kielce';'Lublin';'Rzeszów';'Kraków';'Katowice']

plot(x,y,'rx')

