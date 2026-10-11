"""convert_model.py
Convert a TensorFlow Lite model to CoreML.
Usage: python3 convert_model.py
"""
import os, sys, subprocess

# Paths (adjust if the script location changes)
PROJECT_ROOT = os.path.abspath(os.path.dirname(__file__))
TFLITE_PATH = os.path.join(PROJECT_ROOT, "model_unquant.tflite")
MODEL_RESOURCES_DIR = os.path.join(PROJECT_ROOT, "ModelResources")

def run_cmd(cmd: str) -> str:
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Command failed: {cmd}\n{result.stderr}")
        sys.exit(1)
    return result.stdout

def convert_tflite_to_coreml(tflite_path: str):
    import coremltools as ct
    print(f"Converting TensorFlow Lite model {tflite_path} to CoreML …")
    mlmodel = ct.convert(tflite_path)
    os.makedirs(MODEL_RESOURCES_DIR, exist_ok=True)
    output_path = os.path.join(MODEL_RESOURCES_DIR, "ClothingClassifier.mlmodel")
    mlmodel.save(output_path)
    print(f"CoreML model saved to {output_path}")

def main():
    if not os.path.isfile(TFLITE_PATH):
        print(f"TensorFlow Lite model not found: {TFLITE_PATH}")
        sys.exit(1)
    convert_tflite_to_coreml(TFLITE_PATH)

if __name__ == "__main__":
    main()
