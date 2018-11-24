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

select_df = select_df[['o', 'h']].head(200)
#print(slit)

ran = select_df.loc[4:6, ['o', 'h']]
#print(ran)
#print(select_df.shape[0])

def buildTrain(train,pred, pastData=200, futureMod=1):
    X_train, Y_train = [], []
    for i in range(train.shape[0] - pastData):
        X_train.append(np.array(train.iloc[i:i+pastData]))
    for j in range(pred.shape[0] - futureMod):
        Y_train.append(np.array([j]["m"]))
    return np.array(X_train), np.array(Y_train)

def shuffle(X,Y):
    np.random.seed(10)
    randomList = np.arange(X.shape[0])
    np.random.shuffle(randomList)
    randomListY = np.arange(Y.shape[0])
    np.random.shuffle(randomListY)
    return X[randomList], Y[randomListY]

def splitData(X, Y, rate):
    X_train = X[int(X.shape[0]*rate):]
    Y_train = Y[int(Y.shape[0]*rate):]
    X_val = X[:int(X.shape[0]*rate)]
    Y_val = Y[:int(Y.shape[0]*rate)]
    return X_train, Y_train, X_val, Y_val

def buildManyToOneModel(shape):
    model = Sequential()
    model.add(LSTM(10, input_length=shape[1], input_dim=shape[2]))
    # output shape: (1, 1)
    model.add(Dense(1))
    model.compile(loss="mse", optimizer="adam")
    model.summary()
    return model

# change the last day and next day 
X_train, Y_train = buildTrain(select_df, pdf, 200, 1)
#print(select_df.shape)
#X_train, Y_train = shuffle(X_train, Y_train)
# because no return sequence, Y_train and Y_val shape must be 2 dimension
X_train, Y_train, X_val, Y_val = splitData(X_train, Y_train, 0.1)
# X_train, Y_train, X_val, Y_val = splitData(X_train, Y_train, 0.1)
# print(Y_val)
X_train = np.reshape(X_train, [200, 2])
model = buildManyToOneModel(X_train.shape)
callback = EarlyStopping(monitor="loss", patience=10, verbose=1, mode="auto")
model.fit(X_train, Y_train, epochs=50, batch_size=128, validation_data=(X_val, Y_val), callbacks=[callback])
# batch = 128
