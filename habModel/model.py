#    This file was created by
#    MATLAB Deep Learning Toolbox Converter for TensorFlow Models.
#    11-Apr-2025 18:02:50

import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers

def create_model():
    state = keras.Input(shape=(16,))
    fc1 = layers.Dense(128, name="fc1_")(state)
    relu1 = layers.ReLU()(fc1)
    fc2 = layers.Dense(64, name="fc2_")(relu1)
    relu2 = layers.ReLU()(fc2)
    mean = layers.Dense(2, name="mean_")(relu2)
    fc_std = layers.Dense(2, name="fc_std_")(relu2)
    std = layers.ReLU()(fc_std)

    model = keras.Model(inputs=[state], outputs=[mean, std])
    return model
