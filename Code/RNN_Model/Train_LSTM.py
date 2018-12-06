import pandas as pd
import numpy as np
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Flatten, LSTM, TimeDistributed, RepeatVector
from keras.layers.normalization import BatchNormalization
from keras.optimizers import Adam
from keras.callbacks import EarlyStopping, ModelCheckpoint
import matplotlib.pyplot as plt
from keras.utils.np_utils import to_categorical
from keras import losses
from keras import optimizers
import keras
from keras.models import Sequential
from keras.layers import Dense
from keras.wrappers.scikit_learn import KerasClassifier

train = pd.read_csv("out.csv")
#train = pd.read_csv("out_new1000.csv")
select_df = pd.DataFrame(train)

label = pd.read_csv("label.csv")
pdf = pd.DataFrame(label)

X_load = pd.read_csv("out_test.csv")
#X_load = pd.read_csv("out_test_new1000.csv")
X_Prepare = pd.DataFrame(X_load)

Y_load = pd.read_csv("label_test.csv")
Y_Prepare = pd.DataFrame(Y_load)

# Transpose the datas
data_trsps = select_df.T
test_trsps = X_Prepare.T

# store the infomation from dataframe
train_group_num = data_trsps.shape[0]/2
train_line_data = data_trsps.shape[1]

test_group_num = test_trsps.shape[0]/2
test_line_data = test_trsps.shape[1]

# To array
data_arr = np.array(data_trsps)
Y_train = np.array(pdf)

test_arr = np.array(test_trsps)
Y_test = np.array(Y_Prepare)

print(train_line_data)
print(train_group_num)
print(test_group_num)

# split the data set into 200 * 2 * 1000
X_train = data_arr.reshape(int(train_group_num), 2, int(train_line_data))
X_test = test_arr.reshape(int(test_group_num), 2, int(test_line_data))

#print(Y_train)
# delete the last column if the number of the train_line_data is end of 1
X_train = np.delete(X_train,-1,2)
X_test = np.delete(X_test,-1,2)
get_number = 2500
X_train = X_train[:,:,:get_number]
X_test = X_test[:,:,:get_number]

print (X_train.shape)
print (X_test.shape)

Y_train = Y_train.reshape(1,len(Y_train))[0]
Y_test = Y_test.reshape(1,len(Y_test))[0]
print(Y_train.shape)
print(Y_train)

seed = 7
np.random.seed(seed)
model = Sequential()
shape = X_train.shape
model.add(LSTM(128, input_length=shape[1], input_dim=shape[2], return_sequences=False))
#model.add(LSTM(50, return_sequences=False))
model.add(Dense(units=50, input_dim=2000, kernel_initializer='normal', activation='relu'))
model.add(Dense(units=30, kernel_initializer='normal', activation='sigmoid'))
model.add(Dense(units=1, kernel_initializer='normal', activation='sigmoid'))

model.compile(loss='binary_crossentropy',optimizer='Nadam',metrics=['accuracy'])

callback = EarlyStopping(monitor="loss", patience=10, verbose=1, mode="auto")
history = model.fit(X_train, Y_train, epochs=700, batch_size=128, verbose=2, callbacks=[callback])
loss_and_metrics = model.evaluate(X_test, Y_test, batch_size=100)

plt.figure(1)
plt.subplot(211)
plt.plot(history.history['loss'])
#plt.plot(history.history['val_loss'])
plt.title('model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train'], loc='upper right')

print(loss_and_metrics)  
classes = model.predict(X_test, batch_size=1)
predicted = np.reshape(classes, (classes.size,))
Q = np.array([])
for i in range(0,len(classes)):
    if classes[i][0]>=0.5:
        Q = np.hstack((Q,int(1)))
    else:
        Q = np.hstack((Q,0))
#print(Q.astype(int))
print(classes)
print (Q)
plt.subplot(212)
plt.plot(Y_test)
plt.plot(Q)
plt.title('Test Result')
plt.ylabel('mode')
plt.xlabel('sample number')
plt.legend(['Origin', 'Predict'], loc='upper right')
plt.show()
