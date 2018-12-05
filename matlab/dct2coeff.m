function dctCoeff = dct2coeff(bSize)

dctCoeff = zeros(bSize);

for i = 1:bSize
    if (i == 1)
        coef = sqrt(1/bSize);
    else
        coef = sqrt(2/bSize);
    end
    
    for j = 1:8
        dctCoeff(i,j) = coef*cos(((2*(j-1)+1)*(i-1)*pi)/(2*bSize));
    end
end

end