import pandas as pd
import numpy as np

a = np.array([[1,2,3,4,5,6,7,8],[2,3,4,5,6,7,8,9],[3,4,5,6,7,8,9,10]])
b = a.reshape(3,1,8)

#print(b)
c = pd.DataFrame(a)

d = np.array(c)

print(int(2.54))


