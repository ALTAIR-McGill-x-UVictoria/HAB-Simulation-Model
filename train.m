numObservations = 17;
numActions = 2;
useGPU = true;

obsInfo = rlNumericSpec([numObservations 1], 'LowerLimit', -inf, 'UpperLimit', inf);
actInfo = rlNumericSpec([numActions 1], 'LowerLimit', -1, 'UpperLimit', 1);

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
% agentOpts.EntropyWeightOptions.TargetEntropy = -numActions; % Automatic entropy tuning

actor = rlContinuousGaussianActor(actorNet, obsInfo, actInfo, ...
    "ActionMeanOutputNames", "mean", ...
    "ActionStandardDeviationOutputNames", "std" ...
);
critic1 = rlQValueFunction(criticNet, obsInfo, actInfo);
critic2 = rlQValueFunction(criticNet, obsInfo, actInfo);
agent = rlSACAgent(actor, [critic1, critic2], agentOpts);

env = rlSimulinkEnv('hab', 'hab/Controller');
function simIn = resetHAB(simIn)
    % assignin('base', "seed", randi(100000));  % For the wind generation
    % assignin('base', "vx", -10 + rand * 20);
    % assignin('base', "vy", -10 + rand * 20);
    % assignin('base', "h", 10000 + rand * 10000);

    simIn = setVariable(simIn, "seed", randi(100000));
    simIn = setVariable(simIn, "vx", -10 + rand * 20);
    simIn = setVariable(simIn, "vy", -10 + rand * 20);
    simIn = setVariable(simIn, "h", 10000 + rand * 10000);
end
env.ResetFcn = @resetHAB;

trainOpts = rlTrainingOptions(...
    "MaxEpisodes", 5 ...
);

train(agent, env, trainOpts);