safeBox :: ([a1] -> a2) -> [a1] -> Maybe a2
safeBox func [] = Nothing
safeBox func list = Just (func list)

safeHead :: [a2] -> Maybe a2
safeHead = safeBox head

safeLast :: [a2] -> Maybe a2
safeLast = safeBox last

safeInit :: [a1] -> Maybe [a1]
safeInit = safeBox init

safeTail :: [a1] -> Maybe [a1]
safeTail = safeBox tail
