-- (!!)  -> List index (subscript) operator.
penultimate xs = xs !! max 0 (length xs - 2)
