module JSONInterface (JSONSafeValue (JSVNull, JSVNumber, JSVString, JSVBoolean, JSVArray, JSVObject)) where

import Data.List (intercalate)

data JSONSafeValue
  = JSVNull
  | JSVNumber Double
  | JSVString String
  | JSVBoolean Bool
  | JSVArray [JSONSafeValue]
  | JSVObject [(String, JSONSafeValue)]
  deriving (Eq, Ord, Show)
