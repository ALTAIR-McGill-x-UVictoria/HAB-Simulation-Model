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
        f.write("#endif HAB_WEIGHTS_H")

model_path = os.path.join('habModel', 'habModel.tflite')
model = habModel.load_model()
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()
with open(model_path, 'wb') as f:
    f.write(tflite_model)

hab_bytes = get_byte_array(model_path)
write_to_c_array(hab_bytes)