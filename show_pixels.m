function show_pixels(img)
figure
imshow(img,[],'InitialMagnification','fit')
hold on
[m,n] = size(img);
for i = 1:m
    for j = 1:n
        val = img(i,j);
        text(j,i,sprintf('%.2f',val),'HorizontalAlignment','center', ...
        'VerticalAlignment','middle','color','r');
    end
end
hold off
end