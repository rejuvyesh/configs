-- File: Trayer.hs
-- Copyright rejuvyesh <mail@rejuvyesh.com>, 2014
-- License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

module XMonad.Util.Trayer
       (spawnTrayer
       ) where

import           XMonad
import           XMonad.Util.Run (safeSpawn)

trayer :: FilePath
trayer = "trayer"

spawnTrayer :: MonadIO m => m ()
spawnTrayer = safeSpawn trayer args
  where args = [ "--edge", "bottom"
               , "--align", "right"
               , "--widthtype", "percent"
               , "--width", "4"
               , "--heighttype", "pixel"
               , "--height", "15"
               , "--alpha", "0"
               , "--transparent", "true"
               , "--tint", "0x12121200"
               , "--SetDockType", "true"
               , "--expand", "true"
               ]
