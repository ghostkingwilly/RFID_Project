import pandas as pd
import numpy as np

a = np.array([[1,2,3,4,5,6,7,8],[2,3,4,5,6,7,8,9],[3,4,5,6,7,8,9,10]])
#b = a.reshape(3,1,8)
 
#print(b)
c = pd.DataFrame(a)

d = np.array(c)

#print(d)

aa = np.array([0,1,1,0,1,1,1,0,0,1,1,0,1,0])
#aa = aa.reshape(len(aa),1)

#bb = np.random.randint(1,5,[len(aa),1])
# add column
#cc = np.append(aa,axis=1)
#print(cc)
g = np.array
ad = np.array([[[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1],[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1]],[[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1],[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1]],[[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1],[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1]],[[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1],[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1]]])
fad = np.ones((4,2,10))

print(ad.shape)
for i in range(0,len(ad)):
    for j in range(0,len(ad[0])):
        l = 0
        for k in range(0,(len(ad[0][0])/3)):
            fad[i][j][k] = np.mean(ad[i][j][l:l+3])
            l += 3
print(ad.shape)
print(ad.shape)
print ("---------------------------")
ad = ad[0:-1]
#ad = np.delete(ad,-1, 2)
a = [1,2,3,4,5,6,7,8,9]
for i in range(0,7,3):
    a[i] += 1

print(ad.shape)
"""
# Avg. the data
# delete the last column if the number of the train_line_data is end of 1
X_train_new = np.delete(X_train,-1,2)
X_test_new = np.delete(X_test,-1,2)

X_num = X_train_new.shape[2] / 100
#print (X_train_new.shape)
X_test_num = X_test_new.shape[2] / 100
print (X_test_new.shape)

X_train = np.ones((int(train_group_num), 2, int(X_num)))
for i in range(0,train_group_num):
    for j in range(0,2):
        l = 0
        for k in range(0,X_num):
            X_train[i][j][k] = np.mean(X_train_new[i][j][l:l+100])
            l += 100
print(X_train.shape)

X_test = np.ones((int(X_test.shape[0]), 2, int(X_test_num)))
for i in range(0,X_test.shape[0]):
    for j in range(0,2):
        l = 0
        for k in range(0,X_test_num):
            X_test[i][j][k] = np.mean(X_test_new[i][j][l:l+100])
            l += 100
print(X_test.shape)
"""

"""
print (X_train[0])
print (X_train[0].shape)
print (X_train[0][0])
print (X_train[0][1])
print (X_train[0][1].shape)
D = np.hstack((X_train[0][0],X_train[0][1])) 
print (D)
print (D.shape)

print("**************")

for i in range(1,X_train.shape[0]):
    F = np.hstack((X_train[i][0],X_train[i][1])) 
    D = np.vstack((D,F))
#print (D)
#print ('D~~~~~~~~~~~~~~~~')
#print (D.shape)
#X_train = D

print("**************")

A = np.hstack((X_test[0][0],X_test[0][1])) 
for i in range(1,X_test.shape[0]):
    S = np.hstack((X_test[i][0],X_test[i][1])) 
    A = np.vstack((A,S))
#print (A)
#print (A.shape)
"""
#X_test = A

"""
# string to int
encoder = LabelEncoder()
encoder.fit(Y_train)
encoded_Y = encoder.transform(Y_train)
"""




