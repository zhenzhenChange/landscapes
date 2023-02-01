{- get lines
main = interact content
  where
    content input = show (length (lines input))
-}

{- get words
main = interact content
  where
    content input = show (length (words input))
-}

-- get chars
main = interact content
  where
    content input = show (length input)
