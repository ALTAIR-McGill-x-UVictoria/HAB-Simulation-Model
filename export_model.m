if isfolder("./habModel")   % Remove the directory for previous results if it exists
    rmdir("./habModel", 's');
    disp("Removing previous habModel folder");
end


status = 0;
try
    py.importlib.import_module('tensorflow');
    disp('TensorFlow is already installed');
catch
    disp('TensorFlow is not installed. Installing...');
    status = system('pip install tensorflow-cpu');
end

policy = getActor(agent);   % Get the actor representation
dlnet = getModel(policy);   % Extract the deep learning network

% Export the model and convert it
exportNetworkToTensorFlow(dlnet, "habModel");
disp("Exported the TF Lite model");

if status == 0
    system("python convert_model.py");
    disp("Converted the TF Lite model");
end