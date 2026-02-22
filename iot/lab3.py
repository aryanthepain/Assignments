import network
import os

# Load WiFi credentials from an untracked `secrets.py` module or
# from environment variables `WIFI_SSID` / `WIFI_PASSWORD`.
try:
    from secrets import wifi_ssid, wifi_password
except Exception:
    wifi_ssid = os.getenv("WIFI_SSID") if hasattr(os, "getenv") else None
    wifi_password = os.getenv("WIFI_PASSWORD") if hasattr(os, "getenv") else None
    if not wifi_ssid or not wifi_password:
        raise RuntimeError("WiFi credentials not found. Create iot/secrets.py or set WIFI_SSID/WIFI_PASSWORD environment variables.")

def connect_to_wifi(ssid, password): 
    # Configure WiFi using Station Interface 
    wlan = network.WLAN(network.STA_IF) 
    wlan.active(True) 
    
    if not wlan.isconnected(): 
        print('Connecting to network...') 
        wlan.connect(ssid, password) 
        while not wlan.isconnected(): 
            pass 
    print('Network config:', wlan.ifconfig()) 
    return(wlan) 

if __name__ == '__main__': 
    try: 
        connect_to_wifi(wifi_ssid, wifi_password) 
    except (Exception, KeyboardInterrupt) as e: 
        try: 
            from utility import print_error_msg 
            print_error_msg(e) 
        except ImportError: 
            print("Unable to import utility module")
            

import mip 
mip.install("requests", target="/flash/libs") 

import requests 
 
r = requests.get("https://jsonplaceholder.typicode.com/users/1") 
print(len(r.content)) 
print(r.content) 
r.close() 

import mip 
mip.install("http://raw.githubusercontent.com/jczic/MicroMLP/master/microMLP.py", 
            target="/flash/libs") 

from microMLP import MicroMLP 
import os
import json 
 
if "mlp.json" in os.listdir(): 
    print("File already present!\nTraining not required.") 
else: 
    mlp = MicroMLP.Create(neuronsByLayers=[2, 5, 1], 
                          activationFuncName=MicroMLP.ACTFUNC_TANH, 
                          layersAutoConnectFunction=MicroMLP.LayersFullConnect) 
 
    nnFalse = MicroMLP.NNValue.FromBool(False) 
    nnTrue = MicroMLP.NNValue.FromBool(True) 
    
    # xor gate
    mlp.AddExample([nnFalse, nnFalse], [nnFalse]) 
    mlp.AddExample([nnFalse, nnTrue], [nnTrue]) 
    mlp.AddExample([nnTrue, nnTrue], [nnFalse]) 
    mlp.AddExample([nnTrue, nnFalse], [nnTrue]) 
 
    learnCount = mlp.LearnExamples() 
 
    print("LEARNED :") 
    print("  - False xor False = %s" % 
          mlp.Predict([nnFalse, nnFalse])[0].AsBool) 
    print("  - False xor True  = %s" % 
          mlp.Predict([nnFalse, nnTrue])[0].AsBool) 
    print("  - True  xor True  = %s" % mlp.Predict([nnTrue, nnTrue])[0].AsBool) 
    print("  - True  xor False = %s" % 
          mlp.Predict([nnTrue, nnFalse])[0].AsBool) 
 
    if mlp.SaveToFile("mlp.json"): 
        print("MicroMLP structure saved!") 
 
with open("mlp.json", "r") as f: 
    print(json.load(f))
    
# Assignment - apply regression on sin input
from microMLP import MicroMLP 
import json 
import numpy as np
import math
 
mlp = MicroMLP.Create(neuronsByLayers=[1, 5, 5, 1], 
                        activationFuncName=MicroMLP.ACTFUNC_TANH, 
                        layersAutoConnectFunction=MicroMLP.LayersFullConnect) 

size = 10
test_size = 0.2

x = np.random.rand(size) * math.pi
np.random.shuffle(x)
train_size = int((1 - test_size) * size)

x_train = x[:train_size]
x_test = x[train_size:]
y_train = [math.sin(x_val) for x_val in x_train]
y_test = [math.sin(x_val) for x_val in x_test]

x_mlp = [MicroMLP.NNValue(-1, 1, x_val) for x_val in x_train]
x_mlp_test = [MicroMLP.NNValue(-1, 1, x_val) for x_val in x_test]
y_mlp = [MicroMLP.NNValue(-1, 1, y_val) for y_val in y_train]

for i in range(len(x_mlp)):
    mlp.AddExample([x_mlp[i]], [y_mlp[i]])

learnCount = mlp.LearnExamples() 

# testing
print("Testing :")
mse = 0
for i in range(len(x_test)):
    
    predicted = mlp.Predict(x_mlp_test[i])[0].AsFloat
    actual = y_test[i]
    print(f"  - sin({x_test[i]}) = {predicted} (actual: {actual})")    
    mse += (predicted - actual) ** 2
    
mse /= len(x_test)
print(f"Mean Squared Error: {mse}")


# implementation without numpy
import random
import math
from microMLP import MicroMLP

# create network
mlp = MicroMLP.Create(
    neuronsByLayers=[1, 25, 1],
    activationFuncName=MicroMLP.ACTFUNC_TANH,
    layersAutoConnectFunction=MicroMLP.LayersFullConnect
)

size = 300
test_size = 0.2

mlp.Eta = 0.02
mlp.Alpha = 0.85
mlp.CorrectLearnedMAE = 0.002

# generate random inputs in [0, pi)
x = [(2 * k/size) - 1 for k in range(size)]

# train/test split
train_size = int((1 - test_size) * size)

x_train = x[:train_size]
x_test = x[train_size:]

y_train = [math.sin(v*2*math.pi) for v in x_train]
y_test = [math.sin(v*2*math.pi) for v in x_test]

# convert to MicroMLP
x_mlp = [MicroMLP.NNValue(-1, 1, v) for v in x_train]
x_mlp_test = [MicroMLP.NNValue(-1, 1, v) for v in x_test]
y_mlp = [MicroMLP.NNValue(-1, 1, v) for v in y_train]

# add examples and train
for i in range(len(x_mlp)):
    mlp.AddExample([x_mlp[i]], [y_mlp[i]])

learnCount = mlp.LearnExamples(maxSeconds=100)
print(f"Learned on {learnCount} examples (returned by LearnExamples)")

# testing
print("Testing :")
mse = 0.0
for i in range(len(x_test)):
    predicted = mlp.Predict([x_mlp_test[i]])[0].AsFloat
    actual = y_test[i]
    input_val = x_test[i] 
    print(f"  - sin({input_val}) ≈ {predicted} (actual: {actual})")
    mse += (predicted - actual) ** 2

if len(x_test) > 0:
    mse /= len(x_test)
print(f"Mean Squared Error: {mse}")
