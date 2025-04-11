numObservations = 16;
numActions = 2;
useGPU = true;

obsInfo = rlNumericSpec([numObservations 1], 'LowerLimit', -inf, 'UpperLimit', inf);
actInfo = rlNumericSpec([numActions 1], 'LowerLimit', -inf, 'UpperLimit', inf);

% Define actor input layer
actorInput = featureInputLayer(numObservations, ...
    "Normalization", "none", ...
    "Name", "state");
% Define shared fully connected layers  
actorSharedLayers = [
    fullyConnectedLayer(128, "Name", "fc1")
    reluLayer("Name", "relu1")
    fullyConnectedLayer(64, "Name", "fc2")
    reluLayer("Name", "relu2")
];
% Define output layers for mean and std
meanOutput = [
    fullyConnectedLayer(numActions, "Name", "mean")
];
stdOutput = [
    fullyConnectedLayer(numActions, "Name", "fc_std")
    reluLayer("Name", "std")
];
% Create the actor network
actorNet = layerGraph(actorInput);
actorNet = addLayers(actorNet, actorSharedLayers);
actorNet = addLayers(actorNet, meanOutput);
actorNet = addLayers(actorNet, stdOutput);
% Connect the actor layers
actorNet = connectLayers(actorNet, "state", "fc1");
actorNet = connectLayers(actorNet, "relu2", "mean");
actorNet = connectLayers(actorNet, "relu2", "fc_std");

% Define critic input layers
stateCriticInput = featureInputLayer(numObservations, "Normalization", "none", "Name", "state");
actionCriticInput = featureInputLayer(numActions, "Normalization", "none", "Name", "action");
concatenatedInput = concatenationLayer(1, 2, "Name", "concat");
% Define shared fully connected layers 
sharedCriticLayers = [
    fullyConnectedLayer(128, "Name", "fc1")
    reluLayer("Name", "relu1")
    fullyConnectedLayer(64, "Name", "fc2")
    reluLayer("Name", "relu2")
    fullyConnectedLayer(1, "Name", "q_value") % Output for Q-value
];
% Create the actor network
criticNet = layerGraph(stateCriticInput);
criticNet = addLayers(criticNet, actionCriticInput);
criticNet = addLayers(criticNet, concatenatedInput);
criticNet = addLayers(criticNet, sharedCriticLayers);
% Connect the actor layers
criticNet = connectLayers(criticNet, "state", "concat/in1");
criticNet = connectLayers(criticNet, "action", "concat/in2");
criticNet = connectLayers(criticNet, "concat", "fc1");

agentOpts = rlSACAgentOptions;

agentOpts.ActorOptimizerOptions.LearnRate = actorLearnRate;
agentOpts.CriticOptimizerOptions = rlOptimizerOptions('LearnRate', criticLearnRate);
agentOpts.ExperienceBufferLength = expBufferLen;
agentOpts.MiniBatchSize = batchSize;
agentOpts.DiscountFactor = discountFactor; 
agentOpts.TargetSmoothFactor = targetSmoothFactor; 
agentOpts.SampleTime = sampleTime;
agentOpts.EntropyWeightOptions.TargetEntropy = -0.5 * numActions; % Automatic entropy tuning

actor = rlContinuousGaussianActor(actorNet, obsInfo, actInfo, ...
    "ActionMeanOutputNames", "mean", ...
    "ActionStandardDeviationOutputNames", "std" ...
);
critic1 = rlQValueFunction(criticNet, obsInfo, actInfo);
critic2 = rlQValueFunction(criticNet, obsInfo, actInfo);
agent = rlSACAgent(actor, [critic1, critic2], agentOpts);

env = rlSimulinkEnv('hab', 'hab/Controller');
function simIn = resetHAB(simIn)
    simIn = setVariable(simIn, "seed", randi(100000));
    simIn = setVariable(simIn, "vx", -5 + rand * 10);
    simIn = setVariable(simIn, "vy", -5 + rand * 10);
    simIn = setVariable(simIn, "h", 17000 + rand * 5000);
    simIn = setVariable(simIn, "wind_gain", 0.5 + rand * 0.5);
end
env.ResetFcn = @resetHAB;

trainOpts = rlTrainingOptions(...
    "MaxEpisodes", numEpisodes, ...
    'MaxSteps', 5e6, ...
    'StopTrainingCriteria', 'AverageReward', ...
    'StopTrainingValue', 100 ...
);

trainingResults = train(agent, env, trainOpts);