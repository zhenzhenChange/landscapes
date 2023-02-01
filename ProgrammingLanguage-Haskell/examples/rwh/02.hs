-- (!!)  -> List index (subscript) operator.
penultimate :: [a] -> a
penultimate list = list !! max 0 (length list - 2)

penultimateMatch :: [a] -> a
penultimateMatch [] = error "Empty"
penultimateMatch [_] = error "Single"
penultimateMatch [x, _] = x
penultimateMatch (_ : xs) = penultimateMatch xs
