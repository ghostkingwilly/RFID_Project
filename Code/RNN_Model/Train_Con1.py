import pandas as pd
import numpy as np
import keras
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Flatten, Reshape, GlobalAveragePooling1D
from keras.layers import Conv2D, MaxPooling2D, Conv1D, MaxPooling1D

from sklearn import metrics
from sklearn.metrics import classification_report
from sklearn import preprocessing

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

# Data load
#train = pd.read_csv("./ML_Data/out_2000_10r.csv")
train = pd.read_csv("./ML_Data/out_rrsa.csv")
train_df = pd.DataFrame(train)

label = pd.read_csv("./ML_Data/label_rrsa.csv")
label_df = pd.DataFrame(label)

X_load = pd.read_csv("./ML_Data/out_Atest_rrsa.csv")
X_Prepare = pd.DataFrame(X_load)

Y_load = pd.read_csv("./ML_Data/label_Atest_rrsa.csv")
Y_Prepare = pd.DataFrame(Y_load)

train_arr = np.asarray(train_df, dtype= np.float32)
Y_train = np.array(label_df)

X_arr = np.asarray(X_Prepare, dtype= np.float32)
Y_test = np.array(Y_Prepare)

# eliminate the last row
train_arr = train_arr[0:-1]
X_arr = X_arr[0:-1]

# Normalization
train_arr = feature_normalize(train_arr)
X_arr = feature_normalize(X_arr)

# choose the part of the data  (only one RN16)
RN16idx = 0
termin = 1250
alignm = 2000
train_arr = train_arr[RN16idx:RN16idx+termin]
X_arr = X_arr[alignm:alignm+termin]
#X_arr = X_arr[RN16idx:termin]

# compression
train_arr = compress(train_arr)
X_arr = compress(X_arr)

t_split_size = train_arr.shape[1]/2
te_split_size = X_arr.shape[1]/2

# hsplit(target array, number of splited set)
X_train = np.hsplit(train_arr, t_split_size)
X_test = np.hsplit(X_arr, te_split_size)
X_train = np.asarray(X_train)
X_test = np.asarray(X_test)

num_samples, num_mode = X_train.shape[1], X_train.shape[2]

X_train = X_train.astype("float32")
X_test = X_test.astype("float32")
Y_train = Y_train.astype("float32")
Y_test = Y_test.astype("float32")

# Convert class vectors to binary class matrices.  0 -> 1 0; 1 -> 0 1
y_train = keras.utils.to_categorical(Y_train)
y_test = keras.utils.to_categorical(Y_test)

# 1D CNN neural network
model_m = Sequential()
#model_m.add(Reshape((num_samples, num_mode), input_shape=(Train_input_shape,)))
model_m.add(Conv1D(100, 10, activation='relu', input_shape=(num_samples, num_mode)))
model_m.add(Conv1D(100, 10, activation='relu'))
model_m.add(MaxPooling1D(3))
model_m.add(Conv1D(160, 10, activation='relu'))
model_m.add(Conv1D(160, 10, activation='relu'))
model_m.add(GlobalAveragePooling1D())
model_m.add(Dropout(0.5))
model_m.add(Dense(2, activation='softmax'))
print(model_m.summary())

callbacks_list = [
    #keras.callbacks.ModelCheckpoint(
    #   filepath='best_model.{epoch:02d}-{val_loss:.2f}.h5',
    #   monitor='val_loss', save_best_only=True),
    keras.callbacks.EarlyStopping(monitor='loss', patience=8)
]
model_m.compile(loss='categorical_crossentropy',
                optimizer='adam', metrics=['accuracy'])

# Hyper-parameters
BATCH_SIZE = 200
EPOCHS = 50

# Enable validation to use ModelCheckpoint and EarlyStopping callbacks.
history = model_m.fit(X_train,
                      y_train,
                      batch_size=BATCH_SIZE,
                      epochs=EPOCHS,
                      callbacks=callbacks_list,
                      validation_split=0.1,
                      verbose=1)

score = model_m.evaluate(X_test, y_test, verbose=1)

print("\nAccuracy on test data: %0.2f" % score[1])
print("\nLoss on test data: %0.2f" % score[0])

y_pred_test = model_m.predict(X_test)
# Take the class with the highest probability from the test predictions
max_y_pred_test = np.argmax(y_pred_test, axis=1)
max_y_test = np.argmax(y_test, axis=1)

# saved the model
model_m.save('AoA_testrrsa.h5')

plt.figure(figsize=(6, 4))
plt.plot(history.history['acc'], "g--", label="Accuracy of training data")
plt.plot(history.history['val_acc'], "g", label="Accuracy of validation data")
plt.plot(history.history['loss'], "r--", label="Loss of training data")
plt.plot(history.history['val_loss'], "r", label="Loss of validation data")
plt.title('Model Accuracy and Loss')
plt.ylabel('Accuracy and Loss')
plt.xlabel('Training Epoch')
plt.ylim(0)
plt.legend()
plt.show()

# print(classification_report(max_y_test, max_y_pred_test))
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
