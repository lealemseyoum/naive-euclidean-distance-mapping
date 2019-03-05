close all, clear, clc
%% d_3 distance

%% Load occupancy map
bw = imread('/home/lms/workspace/IndoorGML/occupancy/flat_binary.pgm');
SE = strel('square',5);
erd = imerode(bw,SE);
img = logical(erd);
img =logical(ones(8,7));

[m,n] = size(img);
 img(ceil(m/2),ceil(n/2)) = 0;
 img(ceil(m/2 + 1),ceil(n/2)) = 0;

dist = cell(m,n);
dist(~img) = {[0,0]};
dist(img) = {[Inf,Inf]};

edm_8 = cell(3,3);

for i = 1:m
    for j = 1:n
        edm_8(i,j) = {[(mod(j,2)),mod(i,2)]};
    end
end

%% Pass 1 - Upward sequential pass
for i = m:-1:1
    for j = 1:n
        vals = [];
        if(img(i,j))
            if i == m
                
            elseif j == 1
                for k = 1:2
                    vals = [vals,norm(dist{i+1,j-1+k}+edm_8{3,k+1})];
                end
                [minVal,idx] = min(vals);
                dist(i,j) = {dist{i+1,j-1+idx} + [abs(i+1-i),abs(j-1+idx-j)]};
            elseif j == n
                for k = 1:2
                    vals = [vals,norm(dist{i+1,j-2+k}+edm_8{3,k})];
                end
                [minVal,idx] = min(vals);
                dist(i,j) = {dist{i+1,j-2+idx} + [abs(i+1-i),abs(j-2+idx-j)]};
            else
                for k = 1:3
                    vals = [vals,norm(dist{i+1,j-2+k}+edm_8{3,k})];
                end
                [minVal,idx] = min(vals);
                dist(i,j) = {dist{i+1,j-2+idx} + [abs(i+1-i),abs(j-2+idx-j)]};
            end
        end
    end
    for j = 1:n
        if(img(i,j))
            if j ~= 1
                val1 = norm(dist{i,j});
                val2 = norm(dist{i,j-1}+[1,0]);
                min_ = min(val1,val2);
                if min_ == val2
                    dist(i,j) = {dist{i,j-1}+[0,1]};
                end
            end
        end
    end
    for j = n:-1:1
        if(img(i,j))
            if(j~=n)
                val1 = norm(dist{i,j});
                val2 = norm(dist{i,j+1}+[1,0]);
                min_ = min(val1,val2);
                if min_ == val2
                    dist(i,j) = {dist{i,j+1}+[0,1]};
                end
            end
        end
    end
end
%% Pass 2
for i = 1:m
    for j = 1:n
        vals = [];
        if(img(i,j))
            if i == 1
                
            elseif j == 1
                for k = 1:2
                    vals = [vals,norm(dist{i-1,j-1+k}+edm_8{3,k+1})];
                end
                [minVal,idx] = min(vals);
                minVal1 = norm(dist{i-1,j-1+idx} + [abs(i-1-i),abs(j-1+idx-j)]);
                minVal2 = norm(dist{i,j});
                if min(minVal1,minVal2)== minVal1
                    dist(i,j) = {dist{i-1,j-1+idx} + [abs(i-1-i),abs(j-1+idx-j)]};
                end
            elseif j == n
                for k = 1:2
                    vals = [vals,norm(dist{i-1,j-2+k}+edm_8{3,k})];
                end
                [minVal,idx] = min(vals);
                minVal1 = norm(dist{i-1,j-2+idx} + [abs(i-1-i),abs(j-2+idx-j)]);
                minVal2 = norm(dist{i,j});
                if min(minVal1,minVal2) == minVal1
                    dist(i,j) = {dist{i-1,j-2+idx} + [abs(i-1-i),abs(j-2+idx-j)]};
                end
                
            else
                for k = 1:3
                    vals = [vals,norm(dist{i-1,j-2+k}+edm_8{3,k})];
                end
                [minVal,idx] = min(vals);
                minVal1 = norm(dist{i-1,j-2+idx} + [abs(i-1-i),abs(j-2+idx-j)]);
                minVal2 = norm(dist{i,j});
                if min(minVal1,minVal2) == minVal1
                    dist(i,j) = {dist{i-1,j-2+idx} + [abs(i-1-i),abs(j-2+idx-j)]};
                end
            end
        end
    end
    for j = 1:n
        if(img(i,j))
            if j ~= 1
                val1 = norm(dist{i,j});
                val2 = norm(dist{i,j-1}+[1,0]);
                min_ = min(val1,val2);
                if min_ == val2
                    dist(i,j) = {dist{i,j-1}+[0,1]};
                end
            end
        end
    end
    for j = n:-1:1
        if(img(i,j))
            if(j~=n)
                val1 = norm(dist{i,j});
                val2 = norm(dist{i,j+1}+[1,0]);
                min_ = min(val1,val2);
                if min_ == val2
                    dist(i,j) = {dist{i,j+1}+[0,1]};
                end
            end
        end
    end
end

show_Edist(img,dist);

dMap = zeros(8,7);
for i = 1:m
    for j = 1:n
        dMap(i,j) = norm(dist{i,j});
    end
end
figure
imshow(dMap,[],'InitialMagnification','fit')
