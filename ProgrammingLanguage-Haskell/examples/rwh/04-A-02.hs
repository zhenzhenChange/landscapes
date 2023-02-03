splitWhile :: (t -> Bool) -> [t] -> [[t]]
splitWhile predicate [] = []
splitWhile predicate list@(x : xs)
  | predicate x =
      let (pre, suf) = span predicate list
       in pre : splitWhile predicate suf
  | otherwise = splitWhile predicate xs
