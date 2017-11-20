[X_manmade_train, Y_manmade_train] = ImageClassifier.LoadData('manmade_training.txt');
[X_manmade_test, Y_manmade_test] = ImageClassifier.LoadData('manmade_test.txt');

[X_natural_train, Y_natural_train] = ImageClassifier.LoadData('natural_training.txt');
[X_natural_test, Y_natural_test] = ImageClassifier.LoadData('natural_test.txt');

X_train = [ X_manmade_train; X_natural_train];
Y_train = [ Y_manmade_train; Y_natural_train];
X_test = [ X_manmade_test; X_natural_test];
Y_test = [ Y_manmade_test; Y_natural_test];

clearvars X_manmade_train X_manmade_test Y_manmade_train Y_manmade_test
clearvars X_natural_train X_natural_test Y_natural_train Y_natural_test


ic = ImageClassifier(X_train, Y_train, 3).Train();

[labels, scores, costs] = ic.Evaluate(X_test, Y_test);
