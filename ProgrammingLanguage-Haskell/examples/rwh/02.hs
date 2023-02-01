-- (!!)  -> List index (subscript) operator.
penultimate xs = xs !! max 0 (length xs - 2)

penultimateMatch [] = error "Empty"
penultimateMatch [_] = error "Single"
penultimateMatch [x, _] = x
penultimateMatch (_ : xs) = penultimateMatch xs
