function mdl = getClassifierModel(type, predictors, response, classNames)
%getClassifierModel Returns the requested classifier model. Type should be
%an object of the ClassifierMethods class.

switch type
    case ClassifierMethods.DecisionTrees
        mdl = fitctree(...
            predictors, ...
            response, ...
            'SplitCriterion', 'gdi', ...
            'MaxNumSplits', 8, ...
            'Surrogate', 'off', ...
            'ClassNames', classNames);
        
    case ClassifierMethods.LDA
        mdl = fitcdiscr(...
            predictors, ...
            response, ...
            'DiscrimType', 'linear', ...
            'Gamma', 0, ...
            'FillCoeffs', 'off', ...
            'ClassNames', classNames);
        
    case ClassifierMethods.SVM
        template = templateSVM(...
            'KernelFunction', 'polynomial', ...
            'PolynomialOrder', 2, ...
            'KernelScale', 'auto', ...
            'BoxConstraint', 1, ...
            'Standardize', true);
        mdl = fitcecoc(...
            predictors, ...
            response, ...
            'Learners', template, ...
            'Coding', 'onevsone', ...
            'ClassNames', classNames, 'Prior', 'empirical');
        
    case ClassifierMethods.KNN
        mdl = fitcknn(...
            predictors, ...
            response, ...
            'Distance', 'Cosine', ...
            'Exponent', [], ...
            'NumNeighbors', 10, ...
            'DistanceWeight', 'Equal', ...
            'Standardize', true, ...
            'ClassNames', classNames);
        
    case ClassifierMethods.BaggedTrees
        template = templateTree(...
            'MaxNumSplits', 383);
        mdl = fitcensemble(...
            predictors, ...
            response, ...
            'Method', 'Bag', ...
            'NumLearningCycles', 30, ...
            'Learners', template, ...
            'ClassNames', classNames);
        
    case ClassifierMethods.SubspaceDiscriminant
        subspaceDimension = max(1, min(28, width(predictors) - 1));
        mdl = fitcensemble(...
            predictors, ...
            response, ...
            'Method', 'Subspace', ...
            'NumLearningCycles', 30, ...
            'Learners', 'discriminant', ...
            'NPredToSample', subspaceDimension, ...
            'ClassNames', classNames);
        
    case ClassifierMethods.SubspaceKNN
        subspaceDimension = max(1, min(28, width(predictors) - 1));
        mdl = fitcensemble(...
            predictors, ...
            response, ...
            'Method', 'Subspace', ...
            'NumLearningCycles', 30, ...
            'Learners', 'knn', ...
            'NPredToSample', subspaceDimension, ...
            'ClassNames', classNames);
        
    case ClassifierMethods.RUSBoostedTrees
        template = templateTree(...
            'MaxNumSplits', 20);
        mdl = fitcensemble(...
            predictors, ...
            response, ...
            'Method', 'RUSBoost', ...
            'NumLearningCycles', 30, ...
            'Learners', template, ...
            'LearnRate', 0.1, ...
            'ClassNames', classNames);
        
    otherwise
        error('Requested classifier type unavailable');
        
end

end