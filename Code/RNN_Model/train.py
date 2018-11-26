import pandas as pd
import numpy as np
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Flatten, LSTM, TimeDistributed, RepeatVector
from keras.layers.normalization import BatchNormalization
from keras.optimizers import Adam
from keras.callbacks import EarlyStopping, ModelCheckpoint
import matplotlib.pyplot as plt

train = pd.read_csv("out.csv")
select_df = pd.DataFrame(train)

label = pd.read_csv("label.csv")
pdf = pd.DataFrame(label)
#print(pdf)

# Transpose the datas
data_trsps = select_df.T

# store the infomation from dataframe
train_group_num = data_trsps.shape[0]/2
train_line_data = data_trsps.shape[1]

# To array
data_arr = np.array(data_trsps)
Y_train = np.array(pdf)

# split the data set into 50 * 2 * 100001
X_train = data_arr.reshape(train_group_num, 2, train_line_data)

print(X_train.shape)
print(Y_train.shape)
#print(lab_trsps)
"""
def buildTrain(train,pred, pastData=200, futureMod=1):
    X_train, Y_train = [], []
    for i in range(train.shape[0] - pastData):
        X_train.append(np.array(train.iloc[i:i+pastData]))
    for j in range(pred.shape[0] - futureMod):
        Y_train.append(np.array(pred.iloc[j:j+futureMod]))
    return np.array(X_train), np.array(Y_train)
"""
def shuffle(X,Y):
    np.random.seed(10)
    randomList = np.arange(X.shape[0])
    np.random.shuffle(randomList)
    return X[randomList], Y[randomList]

def splitData(X, Y, rate):
    X_train = X[:int(X.shape[0]*(1-rate))]
    Y_train = Y[:int(Y.shape[0]*(1-rate-0.3))]
    X_val = X[int(X.shape[0]*rate):]
    Y_val = Y[int(Y.shape[0]*rate):]
    return X_train, Y_train, X_val, Y_val

def buildManyToOneModel(shape):
    model = Sequential()
    model.add(LSTM(12, input_length=shape[1], input_dim=shape[2])) # 10 layers
    # output shape: (1, 1)
    model.add(Dense(1))
    #model.compile(loss="mse", optimizer="adam")
    model.compile(loss="mse",optimizer="adam",metrics=['accuracy'])
    model.summary()
    return model

# change the last day and next day 
#X_train, Y_train = buildTrain(select_df, pdf, 200, 1)
#print(X_train.shape)


X_train, Y_train = shuffle(X_train, Y_train)
# because no return sequence, Y_train and Y_val shape must be 2 dimension

X_train, Y_train, X_val, Y_val = splitData(X_train, Y_train, 0.2) # 0.1 percent

print(Y_train.shape)
print(X_val.shape)

model = buildManyToOneModel(X_train.shape)
# why early stopping
callback = EarlyStopping(monitor="loss", patience=10, verbose=1, mode="auto")

# plot history
model.fit(X_train, Y_train, epochs=1000, batch_size=128, validation_data=(X_val, Y_val), callbacks=[callback])
# batch = 128

score = model.evaluate(X_val, Y_val, verbose=0)

print('Test loss:', score[0])
print('Test accuracy:', score[1])