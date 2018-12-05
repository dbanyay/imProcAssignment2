function [lb, hb] = liftAnal(input,coeff)


even_samples = input(1:2:end);
odd_samples = input(2:2:end);

lb = zeros(length(even_samples));
hb = zeros(length(odd_samples));

even_flag = 1;

even_cntr = 1;
odd_cntr = 1;

for i = 1:length(input)
    if even_flag == 1
        lb(even_cntr) = even_samples(even_cntr);
        even_cntr = even_cntr+1;
        even_flag = 0;
        
    else 
        lb(odd_cntr) = even_samples(odd_cntr);
        odd_cntr = odd_cntr+1;
        even_flag = 1;
    end
end
     
end


