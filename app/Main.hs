module Main where

import GHC.Vis

main :: IO ()
main = do
  let a = "teeest"
  let b = [1..3]
  let c = b ++ b
  let d = [1..]
  print $ d !! 1

  vis
  view a "a"
  view b "b"
  view c "c"
  view d "d"

  getChar
  switch

  getChar
  return ()
