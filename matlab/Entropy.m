
function H = Entropy(X)
% Entropy: Returns entropy (in bits) of each column of 'X'

H = 0;

Alphabet = unique(X);

Frequency = zeros(size(Alphabet));

for symbol = 1:length(Alphabet)
    Frequency(symbol) = sum(X(1,1,:) == Alphabet(symbol));
end

P = Frequency / sum(Frequency);

% Calculate entropy in bits
H = -sum(P .* log2(P));

end