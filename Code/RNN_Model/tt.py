import pandas as pd
import numpy as np

a = np.array([[1,2,3,4,5,6,7,8],[2,3,4,5,6,7,8,9],[3,4,5,6,7,8,9,10]])
b = a.reshape(3,1,8)

#print(b)
c = pd.DataFrame(a)

d = np.array(c)

#print(d)

aa = np.array([0,1,1,0,1,1,1,0,0,1,1,0,1,0])
aa = aa.reshape(len(aa),1)

bb = np.random.randint(1,5,[len(aa),1])
# add column
cc = np.append(aa,bb,axis=1)
#print(cc)
g = np.array
ad = np.array([[[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1],[2,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1]],[[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1],[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1]],[[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1],[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1]],[[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1],[1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1,1,2,3,1,2,3,1,2,3,1]]])
fad = np.ones((4,2,10))
bd = np.array([[1,5,8,4,5,3,1],[2,9,4,3,5,2,1],[3,3,3,4,8,5,5],[4,8,7,8,8,8,1]])
bd = np.asarray(bd, dtype= np.float32)
bd = bd.T

for i in range(0,len(ad)):
    for j in range(0,len(ad[0])):
        l = 0
        for k in range(0,(len(ad[0][0])/3)):
            fad[i][j][k] = np.mean(ad[i][j][l:l+3])
            l += 3
#print (bd)
#print ("===============================================")
dataset = []
for idx in range(bd.shape[0]):
    if idx % 2 == 0:
        dataset.append(bd[idx,:])
dataset = np.asarray(dataset)
#print ("===============================================")
#print(dataset)
#ad = ad
#ad = ad[0:-1]
#ad = np.delete(ad,-1, 2)


#print (fad)
a = [1,2,3,4,5,6,7,8,9]
bdb = bd[:,1]
#bdb = bdb.reshape(7,1)
testt = np.zeros((bd.shape[0],bd.shape[1]*2)).T

for i in range(0,testt.shape[1]):
    if (i%2 == 0):
        testt[i] = bdb

print (bd)
print (bd.T)