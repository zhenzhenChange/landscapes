-- shell command: $ runghc 01.hs < 01.spec.txt

main = interact content
  where
    content input = do
      let charSize = "chars: " ++ show (length input) ++ "\n"
      let wordSize = "words: " ++ show (length (words input)) ++ "\n"
      let lineSize = "lines: " ++ show (length (lines input)) ++ "\n"
      charSize ++ wordSize ++ lineSize
