clc
clear all
warning off;

Selection = {'@selectionstochunif', '@selectionroulette'};
Crossover = {'@crossoverscattered', '@crossoversinglepoint', '@crossoverheuristic'};
CrossoverFrn = [0.7 0.8 0.9 1.0];
MutationRate = [0.0005 0.001 0.002 0.004 0.01 0.02];
for i = 1:length(Selection)
    for j = 1:length(Crossover)
        for m = 1:length(CrossoverFrn)
            for n = 1:length(MutationRate)
                options = gaoptimset('PlotFcns', @gaplotbestf, 'PopulationType', 'bitstring',...
                    'PopulationSize', 50,...
                    'SelectionFcn', eval(Selection{i}),...
                    'CrossoverFcn', eval(Crossover{j}),...
                    'CrossoverFraction', CrossoverFrn(m),...
                    'MutationFcn', {@mutationuniform, MutationRate(n)});
                fprintf(fid, 'Selection method: %s.\n', Selection{i});
                fprintf(fid, 'Crossover Function: %s.\n', Crossover{j});
                fprintf(fid, 'Crossover Fraction: %.1f.\n', CrossoverFrn(m));
                fprintf(fid, 'Mutation Rate: %.4f.\n', MutationRate(n));
                [cmbs fval reason] = ga(@diversfcn, nc*l, options);
                fprintf(fid, 'Diversity measure: %.2f.\n', -fval);
                % [cmbs fval reason] = ga(@hammfcn, nc*l, options);
                % fprintf(fid, 'Hamming distance: %.2f.\n', -fval);
            end
        end
    end
end
fclose(fid);

