import Data.ByteString (intercalate, transpose)
import System.Environment (getArgs)

interactTransform :: (String -> String) -> FilePath -> FilePath -> IO ()
interactTransform transformer inputFilePath outputFilePath = do
  input <- readFile inputFilePath
  writeFile outputFilePath (transformer input)

main :: IO ()
main = mainWith transformer
  where
    mainWith transformer = do
      args <- getArgs
      case args of
        [inputFilePath, outputFilePath] -> interactTransform transformer inputFilePath outputFilePath
        _ -> putStrLn "Error: Wrong number of arguments."

    transformer = joinWord

-- TODO
joinWord = id
