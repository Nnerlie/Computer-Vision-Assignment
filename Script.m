if exist('X_train.mat', 'file')
    fprintf('Loading from disk..\n');
    load X_train
    load Y_train
    load X_test
    load Y_test
else
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

    save X_train
    save Y_train
    save X_test
    save Y_test
    exit
end

clearvars X_manmade_train X_manmade_test Y_manmade_train Y_manmade_test
clearvars X_natural_train X_natural_test Y_natural_train Y_natural_test

k = 0;
results = [];
while(k < 32)
    k = k + 1;
    if(mod(k, 25) == 0)
        disp(k);
    end
    tic;
    ic = ImageClassifier(X_train, Y_train, k).Train();
    time = toc;
    
    [percent, correct, total] = ic.Evaluate(X_test, Y_test);
    results = [results; k, time, percent];
end

plot(results(:,1), results(:,2));
results(:,1)
csvwrite('linear_classifier.csv', results);
