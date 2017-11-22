fprintf('Loading manmade training data..\n');
[X_manmade_train, Y_manmade_train] = ImageClassifier.LoadData('manmade_training.txt');
fprintf('Loading manmade test data..\n');
[X_manmade_test, Y_manmade_test] = ImageClassifier.LoadData('manmade_test.txt');

fprintf('Loading natural training data..\n');
[X_natural_train, Y_natural_train] = ImageClassifier.LoadData('natural_training.txt');
fprintf('Loading natural test data..\n');
[X_natural_test, Y_natural_test] = ImageClassifier.LoadData('natural_test.txt');

fprintf('Combining into the approriate X & Y matrices..\n');
X_train = [ X_manmade_train; X_natural_train];
Y_train = [ Y_manmade_train; Y_natural_train];
X_test = [ X_manmade_test; X_natural_test];
Y_test = [ Y_manmade_test; Y_natural_test];

clearvars X_manmade_train X_manmade_test Y_manmade_train Y_manmade_test
clearvars X_natural_train X_natural_test Y_natural_train Y_natural_test

k = 1;
results = [];
while(k < 10)
    fprintf(k, '\n');
    tic;
    ic = ImageClassifier(X_train, Y_train, 3).Train();
    time = toc;
    
    [percent, correct, total] = ic.Evaluate(X_train, Y_train);
    results = [results; k, time, percent, correct, total];
end
csvwrite('linear_classifier.csv', results);
