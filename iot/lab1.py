# lab1.py
# Author - Aryan Gupta

# Stochastic Gradient Descent for Linear Regression from scratch 

# random init
m0 = 0
b0 = 0
alpha = 0.01
num_iterations = 1000

data = [(1, 2), (2, 3), (3, 5), (4, 7), (5, 11)]

def predict(m, b, x):
    return m * x + b

def compute_error(m, b, data):
    total_error = 0
    for x, y in data:
        total_error += (y - predict(m, b, x)) ** 2
    return total_error / len(data)

# training loop
for iteration in range(num_iterations):
    for x, y in data:
        prediction = predict(m0, b0, x)
        error = y - prediction
        
        # gradients
        m_gradient = -2 * x * error
        b_gradient = -2 * error
        
        # update parameters
        m0 -= alpha * m_gradient
        b0 -= alpha * b_gradient

    if iteration % 100 == 0:
        current_error = compute_error(m0, b0, data)
        print(f"Iteration {iteration}: m = {m0}, b = {b0}, error = {current_error}")
        
final_error = compute_error(m0, b0, data)
print(f"Final parameters: m = {m0}, b = {b0}, final error = {final_error}")