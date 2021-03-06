----------- rejuvyesh's xmonad.hs, 2014 -----------
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}

------------
-- Import --
------------

-- Basic imports
import           Data.List
import qualified Data.Map                            as M
import           Data.Monoid
import           Data.Ratio                          ((%))
import qualified Network.MPD                         as MPD (next, previous)
import qualified Network.MPD.Commands.Extensions     as MPD (toggle)
import           XMonad
import qualified XMonad.StackSet                     as W
-- actions
import qualified XMonad.Actions.ConstrainedResize    as Sqr
import           XMonad.Actions.CycleWS
import qualified XMonad.Actions.FlexibleResize       as FlexMouse
import           XMonad.Actions.Search               (google, promptSearch,
                                                      scholar, selectSearch,
                                                      wiktionary)
import           XMonad.Actions.WindowGo             (ifWindow, runOrRaise)
-- hooks
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops           (ewmh, fullscreenEventHook)
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers          (doCenterFloat,
                                                      doFullFloat, isDialog,
                                                      isFullscreen)
import           XMonad.Hooks.Minimize               (minimizeEventHook)
import           XMonad.Hooks.SetWMName              (setWMName)
import           XMonad.Hooks.UrgencyHook

-- layouts
import           XMonad.Layout.Cross                 (Cross (Cross))
import           XMonad.Layout.GridVariants          hiding (L, R)
import           XMonad.Layout.IM                    (Property (Role), withIM)
import           XMonad.Layout.LayoutHints           (layoutHintsWithPlacement)
import           XMonad.Layout.Minimize
import           XMonad.Layout.MultiToggle           (mkToggle1)
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.Named                 (named)
import           XMonad.Layout.NoBorders             (smartBorders)
import           XMonad.Layout.PerWorkspace          (onWorkspace)
import           XMonad.Layout.Reflect
import           XMonad.Layout.Renamed
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Tabbed
import           XMonad.Layout.ThreeColumns          (ThreeCol (ThreeColMid))
import           XMonad.Layout.WindowNavigation      (Navigate (Go, Swap),
                                                      windowNavigation)

-- prompt
import           XMonad.Prompt
import           XMonad.Prompt.AppendFile            (appendFilePrompt)
import           XMonad.Prompt.Input                 (inputPrompt, (?+))

-- utils
import           XMonad.Util.Cursor                  (setDefaultCursor)
import           XMonad.Util.MPD                     (withMPD)
import           XMonad.Util.NamedScratchpad
import           XMonad.Util.NamedWindows            (getName)
import           XMonad.Util.Run                     (runProcessWithInput,
                                                      safeSpawn, spawnPipe)
import           XMonad.Util.Scratchpad              (scratchpadFilterOutWorkspace,
                                                      scratchpadManageHook, scratchpadSpawnActionCustom)
import           XMonad.Util.WorkspaceCompare        (getSortByIndex)
import           XMonad.Util.XSelection

import           XMonad.Util.Password
import           XMonad.Util.SpawnOnce
import           XMonad.Util.Trayer
import           XMonad.Util.XMobar

-- extra
import           Graphics.X11.ExtraTypes.XF86        (xF86XK_AudioLowerVolume,
                                                      xF86XK_AudioMute,
                                                      xF86XK_AudioNext,
                                                      xF86XK_AudioPlay,
                                                      xF86XK_AudioPrev,
                                                      xF86XK_AudioRaiseVolume,
                                                      xF86XK_MonBrightnessDown,
                                                      xF86XK_MonBrightnessUp)
import           System.IO                           (hPutStrLn)
import           System.Posix.Process                (createSession,
                                                      executeFile, forkProcess)

------------------
-- Basic Config --
------------------

-- | The preferred terminal program.
terminal' :: String
terminal' = "urxvt"

-- | Whether focus follows the mouse pointer.
focusFollowsMouse' :: Bool
focusFollowsMouse' = True

-- | Width of the window border in pixels.
borderWidth' :: Dimension
borderWidth' = 1

-- | modMask lets you specify which modkey you want to use.
modMask' :: KeyMask
modMask' = mod4Mask

-- | Pre-defined workspaces.
workspaces' :: [WorkspaceId]
workspaces' = map (\(n,w) -> mconcat [show n,":",w])
              [ (1, "root" )
              , (2, "doc")
              , (3, "work")
              , (4, "mail")
              , (5, "irc")
              , (6, "???")
              , (7, "video") -- dummy ws
              , (8, "music") --
              , (9, "study") -- anki
              , (0, "www")
              ]

-- | Pretty stuff
font' :: String
font' = "-xos4-terminus-medium-*-*-*-12-*-*-*-*-*-*-*"

normalBorderColor'  :: String
normalBorderColor'  = "#000000"

focusedBorderColor' :: String
focusedBorderColor' = "#185D8B"

-- | dmenu options
dmenuOpts' :: String
dmenuOpts' = "-b -i -fn '"++font'++"' -nb '#000000' -nf '#FFFFFF' -sb '"++focusedBorderColor'++"'"

dmenu' :: String
dmenu' = "dmenu "++ dmenuOpts'

dmenuQuick' :: String
dmenuQuick' = "exe= `cat $HOME/.programs | "++dmenu'++"` && eval \"exec $exe\""

-- | xmobar
xmobarBin :: FilePath
xmobarBin = "xmobar"

-- | prompt
defaultXPConfig' :: XPConfig
defaultXPConfig' = defaultXPConfig
                   { font              = font'
                   , bgColor           = "#101010"
                   , fgColor           = "#8a8a8a"
                   , fgHLight          = "#FFFFFF"
                   , bgHLight          = focusedBorderColor'
                   , promptBorderWidth = 0
                   , position          = Bottom
                   , height            = 12
                   , historySize       = 20
                   , defaultText       = []
                   }

passwordXPConfig = defaultXPConfig'
                   { historySize = 0
                   }
-- | theme
defaultTheme' :: Theme
defaultTheme' = defaultTheme
                { activeColor         = focusedBorderColor'
                , inactiveColor       = "#111111"
                , urgentColor         = focusedBorderColor'
                , activeBorderColor   = focusedBorderColor'
                , inactiveBorderColor = "#111111"
                , urgentBorderColor   = "#00FF00"
                , activeTextColor     = "#FFFFFF"
                , inactiveTextColor   = "#BFBFBF"
                , urgentTextColor     = "#FF0000"
                , fontName            = font'
                , decoWidth           = 200
                , decoHeight          = 13
                }

-------------------
-- Key bindings. --
-------------------

keys' conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm, xK_u ), spawn $ XMonad.terminal conf)

    -- launch scratchpad
    , ((modm, xK_i ), scratchpad)
    , ((modm .|. controlMask, xK_d ), namedScratchpadAction scratchpads "rtorrent")
    , ((modm, xK_a ), namedScratchpadAction scratchpads "anking")

    -- password
    , ((modm, xK_p ), passwordPrompt passwordXPConfig)
    -- anki
    , ((modm .|. shiftMask, xK_a ), runOrRaise "anki" (className =? "Anki"))
    -- launch dmenu
    , ((modm, xK_e ), spawn dmenuQuick')
    , ((modm, xK_o ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c ), kill)

    -- Rotate through the available layout algorithms
    , ((modm, xK_space ) , sendMessage NextLayout)

    -- Toggle recent Workspace
    , ((modm,               xK_Tab),     toggleWS)

    -- reset layouts
    , ((modm .|. altMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- tile again
    , ((modm .|. controlMask, xK_space ), withFocused $ windows . W.sink)

    -- focus movement
    , ((modm, xK_n ), windows W.focusUp )
    , ((modm, xK_r ), windows W.focusDown )
    , ((modm, xK_s ), sendMessage $ Go L )
    , ((modm, xK_t ), sendMessage $ Go R )

    -- swap based on focus
    , ((modm .|. shiftMask, xK_n ), windows W.swapUp )
    , ((modm .|. shiftMask, xK_r ), windows W.swapDown )
    , ((modm .|. shiftMask, xK_s ), sendMessage $ Swap L )
    , ((modm .|. shiftMask, xK_t ), sendMessage $ Swap R )

    -- resize
    , ((modm,               xK_d   ), sendMessage (IncMasterN 1) )
    , ((modm .|. shiftMask, xK_d   ), sendMessage (IncMasterN (-1)) )
    , ((modm .|. controlMask, xK_r ), sendMessage Expand )
    , ((modm .|. controlMask, xK_n ), sendMessage Shrink )
    , ((modm .|. controlMask, xK_t ), sendMessage MirrorExpand )
    , ((modm .|. controlMask, xK_s ), sendMessage MirrorShrink )

    -- prev / next workspace
    , ((modm, xK_h ), windows . W.greedyView =<< findWorkspace getSortByIndexNoSP Next HiddenNonEmptyWS 1)
    , ((modm .|. shiftMask, xK_h ), windows . W.greedyView =<< findWorkspace getSortByIndexNoSP Prev HiddenNonEmptyWS 1)
    -- minimize window  
    , ((modm,               xK_v ), withFocused minimizeWindow)
    , ((modm .|. shiftMask, xK_v ), sendMessage RestoreNextMinimizedWin)

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_q ),  spawn "killall trayer ; xmonad --recompile && xmonad --restart")
    , ((modm .|. controlMask, xK_q), spawn "endsession")

    -- lock xmonad screen
    , ((modm,           xK_Escape), spawn "slock")
    -- toggle mouse
    , ((modm  .|. controlMask, xK_m), spawn "toggle_mouse")

    -- Search Engines Yay!
    , ((modm,              xK_g), promptSearch defaultXPConfig' google)
    , ((modm,              xK_y), promptSearch defaultXPConfig' scholar)
    , ((modm .|. shiftMask,xK_g), selectSearch google)
    , ((modm .|. shiftMask,xK_d), selectSearch wiktionary)
    , ((modm .|. shiftMask,xK_y), selectSearch scholar)
    -- Neat key-bindings
    -- Dictionary
    , ((modm              , xK_s),      getSelection  >>= sdcv)
    , ((modm .|. shiftMask, xK_s),      getPromptInput ?+ sdcv)
    -- xclip saner clipboard
    , ((modm, xK_c), spawn  "xclip -selection primary -o | xclip -selection clipboard -i")

      -- swap screens
    , ((modm, xK_j ),                 spawn "rotate_screen normal")
    , ((modm .|. shiftMask, xK_j ),   spawn "rotate_screen left")
    , ((modm .|. controlMask, xK_j ), spawn "rotate_screen right")

      -- making my favorites playlist
    , ((modm .|. shiftMask, xK_m), spawn "eugene rate 5")

      -- screenshot
      -- screenshot screen
    , ((0, xK_Print),                spawn "screenshot.sh scr")
    , ((modm .|. controlMask, xK_o), spawn "screenshot.sh scr")
    -- screenshot window or area
    , ((modm, xK_Print),             spawn "selection")
    , ((modm .|. shiftMask, xK_o),   spawn "selection")

    -- Brightness Control
    , ((0, xF86XK_MonBrightnessUp),   spawn "light -aq 20")
    , ((0, xF86XK_MonBrightnessDown), spawn "light -sq 20")
    -- Volume control
    , ((0, xF86XK_AudioLowerVolume), -- XF86AudioLowerVolume
        safeSpawn "amixer" ["set", "Master", "-q", "5-"])
    , ((0, xF86XK_AudioRaiseVolume),
        safeSpawn "amixer" ["set", "Master", "-q", "5+"])
    , ((0, xF86XK_AudioMute ), spawn "amixer -q set Master toggle")

   -- ncmpcpp (mpd) controls
    , ((0, xF86XK_AudioPlay), withMPD MPD.toggle)
    , ((0, xF86XK_AudioNext), withMPD MPD.next)
    , ((0, xF86XK_AudioPrev), withMPD MPD.previous)
    , ((modm, xK_x), spawn ("date>>"++lg) >> appendFilePrompt defaultXPConfig' lg)
    ]
    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
     | (key, sc) <- zip [xK_w, xK_b] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    where
         getSortByIndexNoSP =
                fmap (.scratchpadFilterOutWorkspace) getSortByIndex
         altMask = mod1Mask
         lg = "/home/rejuvyesh/Documents/2014/log.txt"

-----------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events --
-----------------------------------------------------------

mouseBindings' (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Resize (shift keeps the ratio constant)
    , ((modm, button3), (\w -> focus w >> FlexMouse.mouseResizeWindow w))
    , ((modm .|. shiftMask, button3), (\w -> focus w >> Sqr.mouseResizeWindow w True ))
    ]

-------------
-- Layouts --
-------------

layout' =
    -- global modifiers
    avoidStruts $ -- don't overlap docks
    renamed [CutWordsLeft 1] $ minimize $
    mkToggle1 NBFULL $ -- toggles
    mkToggle1 REFLECTX $
    mkToggle1 REFLECTY $
    mkToggle1 NOBORDERS $
    mkToggle1 MIRROR $

    -- workspace specific preferences
    onWorkspace (findWS "doc") (tabLayout ||| book)   $
    onWorkspace (findWS "www") (tiled ||| grid ||| tabLayout) $
    onWorkspace (findWS "video") full $
    onWorkspace (findWS "study") (cross ||| tiled ||| grid) $
    (tiled ||| grid ||| cross ||| full ||| tabLayout ||| book)
    where
         -- normal tiling
         tiled = named "tiling" $
                 hinted $
                 windowNavigation $
                 pidgin $
                 ResizableTall nmaster delta ratio slaves
         -- grid for terminals or chats
         grid = named "circle" $
                      hinted $
                      windowNavigation $
                      pidgin $
                      Grid (1/1)
         -- cross to center one app, mostly anki
         cross = named "cross" $
                      Cross (2/3) (1/100)
         -- book with notes
         book = named "book" $
                ThreeColMid nmaster delta ratio
           where
                -- default number of windows in the master pane
                nmaster = 1
                -- Percent of screen to increment by when resizing panes
                delta   = 3/100
                -- proportion of screen occupied by master pane
                ratio   = 2/3
         -- fullscreen
         full = named "fullscreen" $
                smartBorders Full
         -- tab
         tabLayout = named "tab" $ tabbed shrinkText defaultTheme'

         -- treat buddy list dock-like
         pidgin l = withIM (1%8) (Role "buddy_list") l
         -- take care of terminal size
         hinted l= layoutHintsWithPlacement( 0.5, 0.5) l

         -- The default number of windows in the master pane
         nmaster = 1
         -- Default proportion of screen occupied by master pane
         ratio = 1/2
         -- Percent of screen to increment by when resizing panes
         delta = 3/100
         -- fraction to multiply the window height that would be given when
         -- divided equally
         slaves = []

-----------
-- Hooks --
-----------

--  |Window handling
manageHook' :: Query (Endo WindowSet)
manageHook' = composeAll (
        [ className =? "Pidgin"     --> doShift (findWS "irc")
        , className =? "Firefox"    --> doShift (findWS "www")
        , className =? "Chromium"   --> doShift (findWS "www")
        , className =? "Anki"       --> doShift (findWS "study")
        , className =? "Amphetype"  --> doShift (findWS "study")
        , className =? "Okular"     --> doShift (findWS "doc")
        , className =? "Zathura"    --> doShift (findWS "doc")
        , className =? "FBReader"   --> doShift (findWS "doc")
        , className =? "Xmessage"   --> doResizeFloat

        ]
        ++
        [ appName   =? "mutt"       --> doShift (findWS "mail")
        , appName   =? "music"      --> doShift (findWS "music")
        , appName   =? "irssi"      --> doShift (findWS "irc")
        , appName   =? "Toplevel"   --> doFloat
        , appName   =? "DTA"        --> doFloat
        ]
        ++
        [ className =? "mpv"            --> doFloat
        , className =? "Wicd-client.py" --> doFloat
        , className =? "Gxmessage"      --> doFloat
        ]
        ++
        [ className =? "com-mathworks-util-PostVMInit" --> doShift (findWS "work")
                       -- java is shit
        , className =? "Xfce4-notifyd" --> doIgnore
        ]
        ++
        [ isFullscreen --> doFullFloat
        , isDialog     --> doCenterFloat
        ]) <+> manageScratchpads <+> manageDocks

doResizeFloat :: ManageHook
doResizeFloat = customFloating $ W.RationalRect left top width height
  where height = 2/4
        width = 2/3
        left = (/2) $ (1-) width
        top = (/2) $ (1-) height

-- | Scratchpad terminal
manageTerminal :: ManageHook
manageTerminal = scratchpadManageHook (W.RationalRect 0.25 0.225 0.5 0.55)

scratchpad :: X()
scratchpad = scratchpadSpawnActionCustom "urxvt -name scratchpad -e zsh -l -c 'scratchpad'"

-- | Other Scratchpads
scratchpads :: [NamedScratchpad]
                       (appName =? "rtorrent")
                       doResizeFloat
              , NS "anking"
                       "anking -m 'Basic' >/dev/null"
                       (title =? "Anking")
                       defaultFloating
              ]

manageScratchpads :: ManageHook
manageScratchpads = manageTerminal <+> namedScratchpadManageHook scratchpads

-- | Status bars and logging
--customPP :: PP
customPP xmproc = defaultPP {
    ppOutput  = hPutStrLn xmproc
  , ppCurrent = xmobarColor "#A6E22E" ""
  , ppHidden = \x -> if x == "NSP" then "" else x
  , ppVisible = xmobarColor "#D0CFD0" "" . wrap "(" ")"
  , ppUrgent = xmobarColor "#D7005F" "" . wrap "[" "]"
  , ppLayout = xmobarColor "#AE81FF" ""
  , ppSep = xmobarColor "#3F3F3F" "" " | "
  , ppTitle    = shorten 50
  , ppOrder    = \(ws:l:t:_) -> [ws,l,t] -- show workspaces and layout
  , ppSort     = fmap (.scratchpadFilterOutWorkspace) $ ppSort defaultPP
  }

--logHook' :: X()
logHook' pro = dynamicLogWithPP $ customPP pro

-- | Urgency
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
  urgencyHook LibNotifyUrgencyHook w = do
    nam     <- getName w
    Just idx <- fmap (W.findTag w) $ gets windowset

    safeSpawn "notify-send" ["-i", "emblem-important", show nam, "workspace " ++ idx]

urgencyHook' :: LayoutClass l Window => XConfig l -> XConfig l
urgencyHook' = withUrgencyHookC LibNotifyUrgencyHook
               $ urgencyConfig { suppressWhen = Focused }

eventHook' :: Event -> X All
eventHook' = minimizeEventHook

-- | Startup applications
startupHook' :: X()
startupHook' = do
  spawnOnce "try arbtt-capture -r 30"
  "net-wait && firefox" `runIfNot` (className =? "Firefox")
  setWMName "LG3D"
  setDefaultCursor xC_left_ptr

-----------------------------------------------------
-- Now run xmonad with all the defaults we set up. --
-----------------------------------------------------

main :: IO()
main = do
  spawnTrayer
  xmobarrc <- getDefaultXMobarRC
  xmproc <- spawnPipe $ xmobarBin +||+ xmobarrc
  xmonad $ ewmh $ urgencyHook' $ defaultConfig {
    -- simple stuff
    terminal           = terminal',
    focusFollowsMouse  = focusFollowsMouse',
    borderWidth        = borderWidth',
    modMask            = modMask',
    workspaces         = workspaces',
    normalBorderColor  = normalBorderColor',
    focusedBorderColor = focusedBorderColor',

    -- key bindings
    keys               = keys',
    mouseBindings      = mouseBindings',

    -- hooks, layouts
    layoutHook         = layout',
    manageHook         = manageHook',
    handleEventHook    = eventHook' <+> fullscreenEventHook,
    startupHook        = startupHook', --matlab hack hope it works
    logHook            = logHook' xmproc
    }

------------------------
--- Custom Functions ---
------------------------

getPromptInput :: X (Maybe String)
getPromptInput = inputPrompt defaultXPConfig' "Dict: "

sdcv :: MonadIO m => String -> m ()
sdcv word = do
    output <- runProcessWithInput "sdcv" ["-n", word] ""
    mySafeSpawn "notify-send" [word, trString output]

trString :: String -> String
trString = foldl (\s c -> s ++ trChar c) ""

trChar :: Char -> String
trChar c
    | c == '<' = "&lt;"
    | c == '>' = "&gt;"
    | c == '&' = "&amp;"
    | otherwise = [c]

--  | mySafeSpawn is from XMonad.Util.Run inside copied; just removed encodeString call
mySafeSpawn :: MonadIO m => FilePath -> [String] -> m ()
mySafeSpawn prog arg = io $ void_ $ forkProcess $ do
    uninstallSignalHandlers
    _ <- createSession
    executeFile prog True arg Nothing
        where void_ = (>> return ())

findWS :: String -> String
findWS = maybe "NSP" id . flip find workspaces' . isSuffixOf

runIfNot :: String -> Query Bool -> X ()
runIfNot command qry = ifWindow qry idHook $ spawn command

(+||+) :: FilePath -> FilePath -> FilePath
s1 +||+ s2 = s1 ++ ( ' ' : s2 )
