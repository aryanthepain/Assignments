import torch
import torch.nn as nn
import librosa
import numpy as np
import struct
from flask import Flask, request, jsonify

app = Flask(__name__)

# --- 1. Load the Model Architecture (Must match your training script) ---
class PumpFaultDetector(nn.Module):
    def __init__(self, input_size):
        super(PumpFaultDetector, self).__init__()
        self.network = nn.Sequential(
            nn.Linear(input_size, 32),
            nn.ReLU(),
            nn.Dropout(0.2),
            nn.Linear(32, 16),
            nn.ReLU(),
            nn.Linear(16, 2)
        )
    def forward(self, x):
        return self.network(x)


import os

# Get the absolute path of the directory this script is in
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "pump_fault_model.pth")

# Initialize and load weights
model = PumpFaultDetector(input_size=13)

# Use the absolute path and set weights_only=True to silence the PyTorch warning
model.load_state_dict(torch.load(MODEL_PATH, map_location=torch.device('cpu'), weights_only=True))
model.eval()

CLASSES = ["normal", "fault"]

@app.route("/analyze", methods=["POST"])
def analyze():
    try:
        # 1. Receive the raw PCM bytes directly from the ESP32
        raw_bytes = request.data
        
        # Ensure we have an even number of bytes for 16-bit audio
        raw_bytes = raw_bytes[:len(raw_bytes)//2 * 2]
        
        # 2. Convert raw bytes to a normalized float array for Librosa
        samples = struct.unpack(f"<{len(raw_bytes)//2}h", raw_bytes)
        audio_np = np.array(samples, dtype=np.float32) / 32768.0 
        
        # 3. Extract MFCCs
        mfccs = librosa.feature.mfcc(y=audio_np, sr=16000, n_mfcc=13)
        mfccs_mean = np.mean(mfccs.T, axis=0)
        
        # 4. Run PyTorch Inference
        input_tensor = torch.tensor([mfccs_mean], dtype=torch.float32)
        with torch.no_grad():
            outputs = model(input_tensor)
            _, predicted = torch.max(outputs.data, 1)
            
        result = CLASSES[predicted.item()]
        print(f"Received audio segment -> AI Classification: {result.upper()}")
        
        return jsonify({"status": result})
        
    except Exception as e:
        print("Error during analysis:", e)
        return jsonify({"status": "error"}), 500

if __name__ == "__main__":
    # Run on all network interfaces so the ESP32 can see it
    print("Starting ML Inference Server...")
    app.run(host="0.0.0.0", port=5000)