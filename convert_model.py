import tensorflow as tf
import os
import habModel

def get_byte_array(file_path):
    with open(file_path, "rb") as f:
        byte_array = f.read()
    return byte_array

def write_to_c_array(byte_array, output_file="hab_model.h"):
    with open(output_file, "w") as f:
        f.write("#ifndef HAB_WEIGHTS_H\n")
        f.write("#define HAB_WEIGHTS_H\n\n")
        f.write("#include <stdint.h>\n\n")
        f.write("extern const uint8_t hab_model_tflite[] = {\n")
        
        for i in range(0, len(byte_array), 12):  # 12 bytes per line for readability
            f.write("  " + ", ".join(f"0x{byte:02x}" for byte in byte_array[i:i+12]) + ",\n")
        
        f.write("};\n")
        f.write("#endif")

model_path = os.path.join('habModel', 'habModel.tflite')
model = habModel.load_model()
# def representative_data_gen():
#     for _ in range(100):
#         # Replace with real input samples if possible
#         yield [tf.random.uniform(shape=(1, *model.input_shape[1:]), dtype=tf.float32)]

converter = tf.lite.TFLiteConverter.from_keras_model(model)
# converter.optimizations = [tf.lite.Optimize.DEFAULT]
# converter.representative_dataset = representative_data_gen
# converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
# converter.inference_input_type = tf.int8
# converter.inference_output_type = tf.int8
tflite_model = converter.convert()

with open(model_path, 'wb') as f:
    f.write(tflite_model)

hab_bytes = get_byte_array(model_path)
write_to_c_array(hab_bytes)