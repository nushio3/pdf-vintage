import Control.Monad
import Data.String.Utils (replace)
import System.Environment (getArgs)
import System.IO (hGetContents)
import System.Process (system, runInteractiveCommand)
import Text.Printf (printf)

readCommand :: String -> IO String
readCommand cmd = do
  (_, stdout, _, _) <- runInteractiveCommand cmd
  hGetContents stdout


main :: IO ()
main = do
  system "mkdir -p tmp/"
  argv <- getArgs
  forM_ argv $ \fn -> do
    system $ "rm -rf tmp/*"
    system $ printf "convert -verbose -density 100 %s -quality 100 tmp/page.png" fn
    pngfns <- readCommand "ls -1 tmp/*.png"
    forM_ (words pngfns) $ \pngfn -> do
      infoStr <- readCommand $ printf "identify %s" pngfn
      let bgfn = replace "page-" "back-" pngfn
          geomStr = words infoStr !! 2
      system $ printf "convert resource/bookelement17.jpg -scale %s %s" geomStr bgfn
