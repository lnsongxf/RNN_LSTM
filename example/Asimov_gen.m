function Asimov_gen
weights = load('weights_9900_990000');

text = fileread('t8.shakespeare.txt');
text = text(1:1e6);
[text_dic,code_text,text_code] = unique(text);

% Initial words
words = text(1:100);
[~,words_code] = ismember(words,text_dic);
words_code_linear = zeros(max(text_code),length(words_code));
words_code_linear(1:max(words_code),:) = dummyvar(words_code)';

temperature = 0.5;
batchSize = 100;
learningRate = 0.001;
T = 100;
gDim = 256;

params = v2struct(temperature,batchSize,learningRate,T,gDim);

%% Predict
addpath('../cmex');
numWordsPredicted = 2e2;
for j=1:numWordsPredicted
    xData = words_code_linear(:,end-T+1:end);
    yhat = lstm_predict(xData,params,weights);
    [~,iymax] = max(yhat(:,end));
    predict = zeros(size(words_code_linear,1),1);
    predict(iymax) = 1;
    words_code_linear = [words_code_linear predict];
    % words_code_linear = [words_code_linear yhat(:,end)];
    words_code = words_code_linear'*[1:size(words_code_linear,1)]';
    words = text_dic(words_code);
    % words = [words text_dic(iymax)];
end
end