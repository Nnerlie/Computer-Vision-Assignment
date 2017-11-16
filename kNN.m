rng(10);

[features, labels] = trainkNN('manmadepics.txt', 'naturepics.txt');

model = fitcknn(features,labels);
model.NumNeighbors = 3;

[label,score,cost] = predict(model, features(4,:));
label