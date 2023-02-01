average :: (Fractional a, Foldable t) => t a -> a
average list = sum list / fromIntegral (length list)
