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

num_classes = 10

model = load_model('AoA_test.h5')

# Data load
obj = pd.read_csv("./ML_Data/obj.csv")
hand = pd.read_csv("./ML_Data/hand.csv")

obj_df = pd.DataFrame(obj)
hand_df = pd.DataFrame(hand)

Objt = np.asarray(obj_df, dtype= np.float32)
Han = np.asarray(hand_df, dtype= np.float32)

# remove the residual one
Objt = Objt[0:-1]
Han = Han[0:-1]

# Normalization
O_arr = feature_normalize(Objt)
H_arr = feature_normalize(Han)
# choose the part of the data  (only one RN16)
termin = 1250
alignm = 0
O_arr = O_arr[alignm:alignm+termin]
H_arr = H_arr[alignm:alignm+termin]

# compression
O_arr = compress(O_arr)
H_arr = compress(H_arr)
print (O_arr.shape)
def cal_score(obj, han, number):
#debug: number = 4
    gen_o = obj[:,number]
        # Tanspose
    han = han.T
    #print ("=============1================")
    #print (H_arr.shape)
        # replace the even rows
    for i in range(0,han.shape[0]):
        if (i == han.shape[0]):
            break
        if (i%2 == 0):
            han[i] = gen_o
    han = han.T
    #print (H_arr.shape)

    te_split_size = han.shape[1]/2

    # hsplit(target array, number of splited set)
    X_test = np.hsplit(han, te_split_size)
    X_test = np.asarray(X_test)

    X_test = X_test.astype("float32")
    #print (Objt.shape)
    # generate the label
    label = np.zeros((obj.shape[1],1), dtype= np.float32)
    label[number] = 1
    Y_test = label.astype("float32")
    #print (Y_test.shape)

    # Convert class vectors to binary class matrices.  0 -> 1 0; 1 -> 0 1
    y_test = keras.utils.to_categorical(Y_test)

    score = model.evaluate(X_test, y_test, verbose=1)

    print("\nAccuracy on test data: %0.2f" % score[1])
    #print("\nLoss on test data: %0.2f" % score[0])

    y_pred_test = model.predict(X_test)
    # Take the class with the highest probability from the test predictions
    max_y_pred_test = np.argmax(y_pred_test, axis=1)
    max_y_test = np.argmax(y_test, axis=1)

    #print (y_pred_test)

    Q = np.array([])
    SC = np.array([])
    for i in range(0,len(y_pred_test)):
        SC = np.hstack((SC, y_pred_test[i][0] - y_pred_test[i][1]))
        if y_pred_test[i][0] <= y_pred_test[i][1]:
            Q = np.hstack((Q,int(1)))
        else:
            Q = np.hstack((Q,0))
    #print (SC.shape)

    #plt.plot(Y_test,"g")
    #plt.plot(Q, "r--")
    #plt.title('Test Result')
    #plt.ylabel('mode')
    #plt.xlabel('sample number')
    #plt.legend(['Origin', 'Predict'], loc='upper right')
    #plt.show()
    return SC

score = np.zeros((O_arr.shape[1],))
for i in range(0,O_arr.shape[1]):
#for i in range(0,10):
    s_tmp = cal_score(O_arr, H_arr, i)
    score = np.vstack((score, s_tmp))
# remove the first initial row 
score = score[1:,:]
score = pd.DataFrame(score)
score.to_csv('Score.csv')
"""
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

"""