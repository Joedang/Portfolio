function Cout= catCellNN(C1, C2)
N= 1;
for n= 1:length(C1)
    if ~isnan(C1(n))
        Cout(N)= C1(n);
        N= N+1;
    end
end
for n= 1:length(C2)
    if ~isnan(C2(n))
        Cout(N)= C1(n);
        N= N+1;
    end
end

end