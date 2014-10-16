-- File: Misc.hs
-- Copyright rejuvyesh <mail@rejuvyesh.com>, 2014
-- License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>
module XMonad.Util.Screen
    ( getScreenDim
    ) where

import           Graphics.X11.Xinerama (getScreenInfo)
import           XMonad

-- | Return the dimensions (x, y, width, height) of screen n.
getScreenDim :: IO (Int, Int, Int, Int)
getScreenDim = do
  d <- openDisplay ""
  screens  <- getScreenInfo d
  closeDisplay d
  case screens of
   []        -> return (0, 0, 1366, 768) -- fallback
   [r]       -> return (fromIntegral $ rect_x r , fromIntegral $ rect_y r , fromIntegral $ rect_width r , fromIntegral $ rect_height r )

