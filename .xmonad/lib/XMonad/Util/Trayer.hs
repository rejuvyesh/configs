-- File: Trayer.hs
-- Copyright rejuvyesh <mail@rejuvyesh.com>, 2014
-- License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

module XMonad.Util.Trayer
       (spawnTrayer
       ) where

import XMonad
import XMonad.Util.Run (safeSpawn)

trayer = "trayer" :: FilePath

spawnTrayer :: MonadIO m => m ()
spawnTrayer = safeSpawn trayer args
  where args = [ "--edge", "bottom"
               , "--align", "right"
               , "--widthtype", "percent"
               , "--width", "5"
               , "--heighttype", "pixel"
               , "--height", "12"
               , "--alpha", "150"
               , "--transparent", "true"
               , "--tint", "0x000000"
               , "--SetDockType", "true"
               , "--expand", "true"
               ]
