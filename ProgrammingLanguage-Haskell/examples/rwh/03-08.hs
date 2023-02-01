data Tree value = Node value (Tree value) (Tree value) | Empty deriving (Show)

getTreeHeight :: (Num a, Ord a) => Tree value -> a
getTreeHeight Empty = 0
getTreeHeight (Node _ l r) = 1 + max (getTreeHeight l) (getTreeHeight r)
