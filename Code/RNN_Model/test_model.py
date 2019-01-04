import pandas as pd
import numpy as np
import keras
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import Dense
from keras.models import load_model
from sklearn.metrics import classification_report

def feature_normalize(dataset):

    mu = np.mean(dataset, axis=0)
    sigma = np.std(dataset, axis=0)
    return (dataset - mu)/sigma

# compression 
def compress(dataset):
    newdata = []
    for idx in range(dataset.shape[0]):
        if idx % 10 == 0:
            newdata.append(dataset[idx,:])
    return np.asarray(newdata) 

# load the model
#model = load_model('Phase.h5')
#model = load_model('AoA_20n4000r.h5')
model = load_model('AoA_test.h5')
# Data load
X_load = pd.read_csv("./ML_Data/out_Atest_10rsa.csv")
X_Prepare = pd.DataFrame(X_load)

Y_load = pd.read_csv("./ML_Data/label_Atest_10rsa.csv")
Y_Prepare = pd.DataFrame(Y_load)

# X_arr = np.array(test_trsps)
X_arr = np.asarray(X_Prepare, dtype= np.float32)
Y_test = np.array(Y_Prepare)

# eliminate the last row
X_arr = X_arr[0:-1]

# Normalization
X_arr = feature_normalize(X_arr)

# choose the part of the data  (only one RN16)
termin = 1250
alignm = 1000
X_arr = X_arr[alignm:alignm+termin]

# compression
X_arr = compress(X_arr)

te_split_size = X_arr.shape[1]/2

# hsplit(target array, number of splited set)
X_test = np.hsplit(X_arr, te_split_size)
X_test = np.asarray(X_test)
print (Y_test.shape)

X_test = X_test.astype("float32")
Y_test = Y_test.astype("float32")

# Convert class vectors to binary class matrices.  0 -> 1 0; 1 -> 0 1
y_test = keras.utils.to_categorical(Y_test)
print (y_test.shape)

score = model.evaluate(X_test, y_test, verbose=1)

print("\nAccuracy on test data: %0.2f" % score[1])
print("\nLoss on test data: %0.2f" % score[0])

y_pred_test = model.predict(X_test)
# Take the class with the highest probability from the test predictions
max_y_pred_test = np.argmax(y_pred_test, axis=1)
max_y_test = np.argmax(y_test, axis=1)
print (Y_test.T)

Q = np.array([])
for i in range(0,len(y_pred_test)):
    if y_pred_test[i][0] <= y_pred_test[i][1]:
        Q = np.hstack((Q,int(1)))
    else:
        Q = np.hstack((Q,0))

#print(Q.astype(int))
#print(classes)
print (Q)

plt.plot(Y_test,"g")
plt.plot(Q, "r--")
plt.title('Test Result')
plt.ylabel('mode')
plt.xlabel('sample number')
plt.legend(['Origin', 'Predict'], loc='upper right')
plt.show()
print("\n--- Classification report for test data ---\n")
print(classification_report(max_y_test, max_y_pred_test))

FN = 0
FP = 0
TP = 0
TN = 0
for j in range(0,len(Q)):
    if Q[j]==0 and Y_test[j]==1:
        FN = FN+1
    if Q[j]==1 and Y_test[j]==0:
        FP = FP+1
    if Q[j]==0 and Y_test[j]==0:
        TN = TN+1
    if Q[j]==1 and Y_test[j]==1:
        TP = TP+1
print (FN, FP, TP, TN)

print ("\n--- False Positive Rate ---\n")
print (float(FP)/float(TN+FP)*100)

print ("\n--- False Negative Rate ---\n")
print (float(FN)/float(TP+FN)*100)