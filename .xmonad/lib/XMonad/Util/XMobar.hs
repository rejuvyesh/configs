-- File: XMobar.hs
-- Copyright rejuvyesh <mail@rejuvyesh.com>, 2014
-- License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

-------------------------------------------------------------------------------
module XMonad.Util.XMobar
       ( getXMobarRC
       , getDefaultXMobarRC
       ) where

import           Control.Monad                  (when)

import           Data.List                      (intercalate)
import           System.Directory
import           System.Environment.XDG.BaseDir (getUserConfigDir)
import           System.FilePath.Posix
import           System.Posix.Files             (getFileStatus,
                                                 modificationTime)
import           System.Posix.Types             (EpochTime)

-- | Locations of files on the syste
xmobarRC :: IO FilePath -- Something like "/home/rejuvyesh/.config/xmobar/xmobarrc
xmobarRC = do dir <- getUserConfigDir "xmobar"
              return $ dir </> "xmobarrc"

-- | Something like "/home/rejuvyesh/.xmonad/lib/XMonad/XMobar.hs"
xmobarhs :: IO FilePath
xmobarhs = do home <- getHomeDirectory
              return $ foldl (</>) home [".xmonad", "lib", "XMonad","Util","XMobar.hs"]

-- | File manipulation and inspection (specifically whether one file
-- is newer than another)

-- Is true if f1 is newer than f2
isFileNewer :: FilePath -> FilePath -> IO Bool
isFileNewer f1 f2 = do mod1 <- getModTime f1
                       mod2 <- getModTime f2
                       return $ mod1 > mod2

getModTime :: FilePath -> IO EpochTime
getModTime f = do s <- getFileStatus f
                  return $ modificationTime s


-- | Return a string representation of an xmobar configuration that can be written to a file.
printConfig conf = putStr $ show conf

writeConfig :: FilePath -> Config -> IO ()
writeConfig f conf = writeFile f $ show conf

getXMobarRC :: Config -> IO FilePath
getXMobarRC conf = do f <- xmobarRC
                      exists <- doesFileExist f
                      if exists then do xmobarHS <- xmobarhs
                                        new <- isFileNewer xmobarHS f
                                        when new $ writeConfig f conf
                                else writeConfig f conf
                      return f


-- | XMobar configuration definition in Haskell.
-- This section deals with the representation of XMobar
-- configurations, there's a plethora of ways to represent these I
-- guess. The defaultXMobarRC provided is my configuration.

data Config = Config [Option]
data Option = Opt String String
            | OptEnum String String
            | OptList String [String]

instance Show Config where
  show (Config options) = concat ["Config { ", fmt options, "\n }\n"]
    where fmt options = intercalate "\n , " $ map show options

instance Show Option where
  show (Opt key value) = concat [key, " = ", show value]
  show (OptEnum key value) = concat [key, " = ", value]
  show (OptList key values) = concat [key, " = ", fmt (length key + 12) values ]
    where fmt indent values = concat ["[ ", intercalate sep values, end]
            where space = replicate indent ' '
                  sep = concat ["\n", space, ", "]
                  end = concat ["\n", space, "]"]

defaultXMobarRC :: Config
defaultXMobarRC = Config
                    [ Opt "font"  "xft:Consolas-8",
                      Opt "bgColor"  "#121212",
                      Opt "fgColor"  "#AFAF87",
                      OptEnum "position"  "BottomW L 96",
                      OptEnum "lowerOnStart" $ show  True,
                      OptList "commands"  [
                        "Run DynNetwork [\"-t\", \"<dev> <fc=#387BAB>↓<rx>kB</fc> <fc=#005F87>↑<tx>kB</fc>\", \"-w\", \"3\"] 15",
                        "Run Date \"%a %d-%m %H:%M:%S \" \"date\" 10",
                        "Run BatteryP [\"BAT0\"] [\"-t\", \"<fc=#D0CFD0><acstatus></fc><left>\", \"-S\", \"True\", \"-L\", \"30\", \"-H\", \"70\", \"-p\", \"3\", \"-l\", \"#D74083\", \"-n\", \"#FF9926\", \"-h\", \"#93FF19\", \"--\", \"-O\", \"+\", \"-o\", \"-\", \"-f\", \"BAT0/subsystem/ADP0/online\" ] 600",
                        "Run StdinReader",
                        "Run Memory [\"-p\", \"2\", \"-c\", \"0\", \"-S\", \"True\",\"-H\", \"80\", \"-h\", \"#D7005F\", \"-L\", \"50\", \"-l\", \"#87FF00\", \"-n\", \"#FF8700\", \"-t\", \"RAM: <usedratio>\"] 50",
                        "Run Cpu [\"-p\", \"2\", \"-c\", \"0\", \"-S\", \"True\", \"-H\", \"75\", \"-h\", \"#D7005F\", \"-L\", \"30\", \"-l\", \"#87FF00\", \"-n\", \"#FF8700\", \"-t\", \"CPU: <total>\"] 50",
                        "Run MPD [\"-t\", \"<fc=#387BAB><artist><fc=#4F3F3F> <statei> </fc><title></fc>\", \"--\", \"-P\", \"-\", \"-Z\", \"//\", \"-S\", \"><\"] 50",
                        "Run Com \"fumeup\" [] \"fume\" 10"
                        ],

                      Opt "template"  " %StdinReader% <fc=#3F3F3F>| <fc=#D0CFD0>%mpd%</fc></fc> }{ %fume%<fc=#3F3F3F>| </fc><fc=#3F3F3F>%dynnetwork%</fc><fc=#3F3F3F> | %memory% | %cpu% | %battery%</fc><fc=#3F3F3F> | </fc><fc=#D0CFD0><action=`calendar.sh`>%date%</action></fc>"
                    ]

getDefaultXMobarRC :: IO FilePath
getDefaultXMobarRC = getXMobarRC defaultXMobarRC
