{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

import Data.List (sortBy)

{-# HLINT ignore "Eta reduce" #-}
sortML :: Foldable t => [t a] -> [t a]
sortML multidimensionalList = sortBy diffML multidimensionalList where diffML a b = compare (length a) (length b)
