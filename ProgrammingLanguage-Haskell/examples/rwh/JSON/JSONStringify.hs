module JSONStringify where

import Data.List (intercalate)
import JSONInterface (JSONSafeValue (..))

stringify :: JSONSafeValue -> String
stringify JSVNull = "null"
stringify (JSVBoolean True) = "true"
stringify (JSVBoolean False) = "false"
stringify (JSVNumber v) = show v
stringify (JSVString v) = show v
stringify (JSVArray v) = "[" ++ normalize stringify v ++ "]"
stringify (JSVObject v) = "{ " ++ normalize normalizePair v ++ " }" where normalizePair (k, v) = show k ++ ": " ++ stringify v

normalize :: (a -> String) -> [a] -> String
normalize handler [] = ""
normalize handler value = intercalate ", " (map handler value)
