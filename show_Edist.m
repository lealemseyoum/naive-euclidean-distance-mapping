function show_Edist(img,label)
figure
imshow(img,[],'InitialMagnification','fit')
hold on
[m,n] = size(img);
for i = 1:m
    for j = 1:n
        val = label{i,j};
        % coordinate from for text is different than image (x,y) -> (y,x)
        text(j,i,sprintf('%.f,%.f',val(1),val(2)),'HorizontalAlignment','center', ...
        'VerticalAlignment','middle','color','r');
    end
end
hold off
end