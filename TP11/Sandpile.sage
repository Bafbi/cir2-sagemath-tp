from sage.plot.plot3d.shapes import Box

class Sandpile():

  # constructor 
  def __init__(self, mat):
    # create the mat attribute 
    self.mat = matrix(mat)
    
  @staticmethod
  def get_random(n, max=10):
    return Sandpile([[randint(0,max) for i in range(n)] for j in range(n)])
  
  @staticmethod
  def get_max(n):
    return Sandpile( n*[ n*[3] ] )

  # representation of the self object 
  def __repr__(self):

    # use the __repr__ method of the sage matrix object 
    return self.mat.__repr__()

  # what to do when calling == between two Sandpile objects 
  def __eq__(self, other):

    # two Sandpile objects are equal if their matrix are the same 
    return self.mat == other.mat
  
  def __add__(self, other) -> Sandpile:
    s_tmp = self.mat + other.mat
    s_tmp = Sandpile(s_tmp)
    s_tmp.stabilize()
    return s_tmp

  def show(self):
    field = []
    for i in range(self.mat.nrows()):
      for j in range(self.mat.ncols()):
        field.append(Box([1/2,1/2, self.mat[i,j]/2], color=(1, 1 - self.mat[i,j]/10, 0.2)).translate([i+1/2,j+1/2,self.mat[i,j]/2]))
    show(sum(field), shade="low")
    
  def topple(self, i, j) -> bool:
    if self.mat[i,j] >= 4:
      # print("at", i, j, ":", self.mat[i,j], "toppling")
      self.mat[i,j] -= 4
      if i > 0:
        self.mat[i-1,j] += 1
      if i < self.mat.nrows()-1:
        self.mat[i+1,j] += 1
      if j > 0:
        self.mat[i,j-1] += 1
      if j < self.mat.ncols()-1:
        self.mat[i,j+1] += 1
      return True
    return False
        
  def stabilize(self) -> int:
    """Stabilize the sandpile.

    Returns:
        int: The number of iterations needed to stabilize the sandpile.
    """
    count = 0
    while True:
      for i in range(self.mat.nrows()):
        for j in range(self.mat.ncols()):
          count += 1 if self.topple(i,j) else 0
      if max([self.mat[i,j] for i in range(self.mat.nrows()) for j in range(self.mat.ncols())]) < 4:
        break
    return count
  
  @staticmethod
  def find_neutral(n: int) -> Sandpile:
    smax = Sandpile.get_max(n)
    smax2 = smax + smax
    # find t the sandpile that when added to smax + smax, the result is smax
    # generate a list of list with 3 - smax2 for every coordonne
    t = Sandpile([[3 - smax2.mat[i,j] for i in range(n)] for j in range(n)])
        
    sneutre = smax + t
    return sneutre
      
print("-= The sandpile class is loaded! =-")
print()
print("Don't forget to reload the class each time the file is modified!")
