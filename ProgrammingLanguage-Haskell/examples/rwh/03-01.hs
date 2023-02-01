-- repl> length [1..100000000] -> 100000000
-- repl> getSize [1..100000000] -> Exception: stack overflow

getSize :: Num a1 => [a2] -> a1
getSize [] = 0
getSize (_ : xs) = 1 + getSize xs
