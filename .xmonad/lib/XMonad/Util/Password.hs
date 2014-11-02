-- File: Password.hs
-- Copyright rejuvyesh <mail@rejuvyesh.com>, 2014
-- License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>
-- Mostly from https://github.com/jdost/xmonad-config/blob/master/lib/Passwords.hs
module XMonad.Util.Password
    ( getPasswords
    , passwordPrompt
    ) where

import           Control.Monad         (forM)
import           Data.List             (isInfixOf)
import           Data.Maybe            (fromMaybe)
import           System.Directory      (doesDirectoryExist,
                                        getDirectoryContents)
import           System.Environment    (getEnv, lookupEnv)
import           System.FilePath       ((</>))
import           System.FilePath.Posix (dropExtension, makeRelative)

import           XMonad.Core
import           XMonad.Prompt

passwordStoreEnvVar :: String
passwordStoreEnvVar = "PASSWORD_STORE_DIR"

passwordLength :: Int
passwordLength = 20

getPasswordDir :: IO FilePath
getPasswordDir = do
  envDir <- lookupEnv passwordStoreEnvVar
  home   <- getEnv "HOME"
  return $ fromMaybe (home </> ".password-store") envDir

getFiles :: FilePath -> IO [String]
getFiles dir = do
  unfilteredNames <- getDirectoryContents dir
  let names = filter (`notElem` [".", "..", ".git"]) unfilteredNames
  paths <- forM names $ \name -> do
    let path = dir </> name
    isDirectory <- doesDirectoryExist path
    if isDirectory
      then getFiles path
      else return [path]
  return (concat paths)

getPasswords :: IO [String]
getPasswords = do
  pass_dir <- getPasswordDir
  files    <- getFiles pass_dir
  return $ map (makeRelative pass_dir . dropExtension) files


data Pass = Pass

instance XPrompt Pass where
  showXPrompt       Pass = "Pass: "
  commandToComplete _ c  = c
  nextCompletion      _  = getNextCompletion

selectPassword :: [String] -> String -> X ()
selectPassword passwords ps = spawn $ "pass " ++ args
  where
    args | ps `elem` passwords = "show -c " ++ ps
         | otherwise = "generate -c " ++ ps ++ " " ++ show passwordLength

passwordPrompt :: XPConfig -> X ()
passwordPrompt conf = do
  li <- io getPasswords
  let compl s = filter (\x -> s `isInfixOf` x) li
  mkXPrompt Pass conf (return . compl) (selectPassword li)
