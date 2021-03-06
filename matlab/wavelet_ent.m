function entsum = wavelet_ent(X,scale)

smallest = length(X)/2^scale;

entsum = 0;

for i = 1:scale
    sizevect(i) = smallest*2^(i-1);
end

for i = 1:scale
    sb_ent = zeros(1,4);
    segment = zeros(1,4);
    
    for x = 1:2
        for y = 1:2
        
        segment = X((x-1)*sizevect(i)+1:x*sizevect(i),(y-1)*sizevect(i)+1:y*sizevect(i));
        segment = reshape(segment,1,1,[]);
        sb_ent(x+(y-1)*2) = entropy(segment);
        
        end        
    end
    
    if i == 1        
        entsum = entsum + sum(sb_ent)*(4*(sizevect(i).^2));
%         sizeIm = sizeIm + 4*(sizevect(i).^2);
    else        
        entsum = entsum + sum(sb_ent(2:4))*(3*(sizevect(i).^2));
%         sizeIm = sizeIm + 3*(sizevect(i).^2);
    end
end

end