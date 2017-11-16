load fisheriris
X = meas;    % Use all data for fitting
Y = species; % Response data
rng(10);

model = fitcknn(X,Y);
model.NumNeighbors = 6;

[label,score,cost] = predict(model, X(130,:));
label