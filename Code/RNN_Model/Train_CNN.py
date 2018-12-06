import pandas as pd
import numpy as np
import keras
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Flatten
from keras.layers import Conv2D, MaxPooling2D, Conv1D, MaxPooling1D
import os

batch_size = 32
num_classes = 10
epochs = 100
data_augmentation = True
num_predictions = 20
save_dir = os.path.join(os.getcwd(), 'saved_models')
model_name = 'keras_trained_model.h5'

# Data load
train = pd.read_csv("out.csv")
train_df = pd.DataFrame(train)

label = pd.read_csv("label.csv")
label_df = pd.DataFrame(label)

X_load = pd.read_csv("out_test.csv")
X_Prepare = pd.DataFrame(X_load)

Y_load = pd.read_csv("label_test.csv")
Y_Prepare = pd.DataFrame(Y_load)

# Transpose the datas
data_trsps = train_df.T
test_trsps = X_Prepare.T

train_arr = np.array(data_trsps)
Y_train = np.array(label_df)

X_arr = np.array(test_trsps)
Y_test = np.array(Y_Prepare)

X_train = train_arr.reshape(int(Y_train.shape[0]), 2, int(train_arr.shape[1]))
X_test = X_arr.reshape(int(Y_test.shape[0]), 2, int(X_arr.shape[1]))

print (X_train.shape[1:])
print (X_test.shape)

# Convert class vectors to binary class matrices.  0 -> 1 0; 1 -> 0 1
y_train = keras.utils.to_categorical(Y_train)
y_test = keras.utils.to_categorical(Y_test)

model = Sequential()
# 32 3*3 kernels 
model.add(Conv1D(32, 3, padding='same',input_shape=X_train.shape[1:]))
model.add(Activation('relu'))
#model.add(Conv1D(32, 3))
#model.add(Activation('relu'))
model.add(MaxPooling1D(pool_size=1))
model.add(Dropout(0.25))
"""
model.add(Conv1D(64, 3, padding='same'))
model.add(Activation('relu'))
model.add(Conv1D(64, 3))
model.add(Activation('relu'))
model.add(MaxPooling1D(pool_size=1))
model.add(Dropout(0.25))
"""
model.add(Flatten())
model.add(Dense(512))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(2))
model.add(Activation('softmax'))

# initiate RMSprop optimizer
opt = keras.optimizers.rmsprop(lr=0.0001, decay=1e-6)

# Let's train the model using RMSprop
model.compile(loss='categorical_crossentropy',
              optimizer=opt,
              metrics=['accuracy'])
model.fit(X_train, y_train, batch_size=batch_size, epochs=epochs, validation_data=(X_test, y_test), shuffle=True)
"""
# Save model and weights
if not os.path.isdir(save_dir):
    os.makedirs(save_dir)
model_path = os.path.join(save_dir, model_name)
model.save(model_path)
print('Saved trained model at %s ' % model_path)
"""
# Score trained model.
scores = model.evaluate(X_test, y_test, verbose=1)
print('Test loss:', scores[0])
print('Test accuracy:', scores[1])
