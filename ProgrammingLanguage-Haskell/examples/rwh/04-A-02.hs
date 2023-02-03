splitWhile :: (t -> Bool) -> [t] -> [[t]]
splitWhile predicate [] = []
splitWhile predicate (x : xs)
  | predicate x =
      let (pre, suf) = span predicate (x : xs)
       in pre : splitWhile predicate suf
  | otherwise = splitWhile predicate xs
