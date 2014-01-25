----------- rejuvyesh's xmonad.hs -----------

------------
-- Import --
------------
-- Basic imports
import Data.List
import Data.Monoid
import Data.Ratio ((%))
import XMonad
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import System.Exit

-- actions
import XMonad.Actions.CycleWS
import XMonad.Actions.NoBorders
import qualified XMonad.Actions.ConstrainedResize as Sqr
import qualified XMonad.Actions.FlexibleResize as FlexMouse
import XMonad.Actions.Search (google, scholar, youtube, wayback, wikipedia, wiktionary, selectSearch, promptSearch)
import XMonad.Actions.WindowGo (raiseMaybe, raiseBrowser, raiseEditor, runOrRaise)
  
-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName -- matlab shit
import XMonad.Hooks.EwmhDesktops -- chromium fix
import XMonad.Hooks.Minimize

-- layouts
import XMonad.Layout.Cross
import XMonad.Layout.GridVariants hiding (L, R)
import XMonad.Layout.IM
import XMonad.Layout.LayoutHints
import XMonad.Layout.MagicFocus
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.ResizableTile
import XMonad.Layout.StackTile
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Tabbed
import XMonad.Layout.Minimize
import XMonad.Layout.Decoration

-- prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.Shell
import XMonad.Prompt.Theme
import XMonad.Prompt.AppendFile        

-- utils
import XMonad.Util.WorkspaceCompare (getSortByIndex)
import XMonad.Util.Run
import XMonad.Util.NamedScratchpad
import XMonad.Util.Scratchpad
import XMonad.Util.XSelection
        
-- extra
import Graphics.X11.ExtraTypes.XF86
import System.Posix.Process (createSession, executeFile, forkProcess)
        
------------------
-- Basic Config --
------------------

-- The preferred terminal program.
terminal' = "urxvt"

-- Whether focus follows the mouse pointer.
focusFollowsMouse' = True

-- Width of the window border in pixels.
borderWidth' = 1

-- modMask lets you specify which modkey you want to use.
modMask' = mod4Mask

-- Pre-defined workspaces.
workspaces' = [ "1"
              , "doc"
              , "3"
              , "4"
              , "5"
              , "6"   
              , "video" -- dummy ws
              , "music" -- 
              , "study" -- anki
              , "www" 
              ] 

-- Pretty stuff
font'		    = "-xos4-terminus-medium-*-*-*-12-*-*-*-*-*-*-*"
normalBorderColor'  = "#000000"
focusedBorderColor' = "#2d5565"

-- dmenu
dmenuOpts' = "-b -i -fn '"++font'++"' -nb '#000000' -nf '#FFFFFF' -sb '"++focusedBorderColor'++"'"
dmenu' = "dmenu "++dmenuOpts'
dmenuPath' = "dmenu_run "++dmenuOpts'
dmenuQuick' = "exe= `cat $HOME/.programs | "++dmenu'++"` && eval \"exec $exe\""

-- prompt
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
                   
defaultTheme' = defaultTheme
                { fontName    = font'
                , activeColor = "#fdf6e3"
                , activeBorderColor = "#586e75"
                , decoHeight  = 12
                }
-------------------
-- Key bindings. --
-------------------
keys' conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm, xK_u ), spawn $ XMonad.terminal conf)

    -- launch scratchpad 
    , ((modm, xK_i ), scratchpad)
    , ((modm, xK_p ), namedScratchpadAction scratchpads "pidgin")
    , ((modm .|. controlMask, xK_d ), namedScratchpadAction scratchpads "rtorrent")
      -- , ((modm, xK_m), namedScratchpadAction scratchpads "ncmpcpp_")
    -- anki
    , ((modm, xK_a ), runOrRaise "anki" (className =? "Anki"))
    -- launch dmenu
    , ((modm, xK_e ), spawn dmenuQuick')
    , ((modm, xK_o ), spawn dmenuPath')

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
    , ((modm, xK_d ), sendMessage (IncMasterN 1) )
    , ((modm .|. shiftMask, xK_d ), sendMessage (IncMasterN (-1)) )
    , ((modm .|. controlMask, xK_r ), sendMessage Expand )
    , ((modm .|. controlMask, xK_n ), sendMessage Shrink )
    , ((modm .|. controlMask, xK_t ), sendMessage MirrorExpand )
    , ((modm .|. controlMask, xK_s ), sendMessage MirrorShrink )

    -- prev / next workspace
    , ((modm, xK_h ), windows . W.greedyView =<< findWorkspace getSortByIndexNoSP Next HiddenNonEmptyWS 1)
    , ((modm .|. shiftMask, xK_h ), windows . W.greedyView =<< findWorkspace getSortByIndexNoSP Prev HiddenNonEmptyWS 1)

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_q ), spawn "xmonad --recompile && xmonad --restart")

    , ((modm,               xK_v ), withFocused minimizeWindow)
    , ((modm .|. shiftMask, xK_v ), sendMessage RestoreNextMinimizedWin)
    -- lock xmonad screen
    , ((modm .|. shiftMask,xK_Escape), spawn "slock")

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
    , ((modm, xK_j ), spawn "rotate_screen normal")
    , ((modm .|. shiftMask, xK_j ), spawn "rotate_screen left")
    , ((modm .|. controlMask, xK_j ), spawn "rotate_screen right")

    -- making my favorites playlist
    , ((modm .|. shiftMask, xK_m), spawn "songrating.sh 5")
    , ((modm, xK_f), spawn "downloadcovers.sh")
    -- screenshot
    -- screenshot screen
    , ((0, xK_Print), spawn "screenshot.sh scr")
    -- screenshot window or area
    , ((modm, xK_Print), spawn "screenshot.sh win")

    -- Brightness Control
    , ((0, xF86XK_MonBrightnessUp), spawn "light -aq 20")
    , ((0, xF86XK_MonBrightnessDown), spawn "light -sq 20")
    -- Volume control
    , ((0, xF86XK_AudioLowerVolume), -- XF86AudioLowerVolume
        safeSpawn "amixer" ["set", "Master", "-q", "5-"])
    , ((0, xF86XK_AudioRaiseVolume), 
        safeSpawn "amixer" ["set", "Master", "-q", "5+"])
    , ((0, xF86XK_AudioMute ), spawn "amixer -q set Master toggle")
    
   -- ncmpcpp (mpd) controls
    , ((0, xF86XK_AudioPlay), spawn "ncmpcpp toggle")
    , ((0, xF86XK_AudioNext), spawn "ncmpcpp next")
    , ((0, xF86XK_AudioPrev), spawn "ncmpcpp prev")
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
    minimize $
    mkToggle1 NBFULL $ -- toggles
    mkToggle1 REFLECTX $
    mkToggle1 REFLECTY $
    mkToggle1 NOBORDERS $
    mkToggle1 MIRROR $

    -- workspace specific preferences
    onWorkspace "doc" tabLayout   $
    onWorkspace "www" (tiled ||| grid ||| tabLayout) $
    onWorkspace "video" full $
    (tiled ||| grid ||| cross ||| full)
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
         cross = named "十" $
                      Cross (2/3) (1/100)
	 -- fullscreen
         full = named "fullscreen" $
                      smartBorders $
                      Full
         -- tab
         tabLayout = tabbed shrinkText defaultTheme
         -- treat buddy list dock-like
         pidgin l = withIM (1%8) (Role "buddy_list") l
         -- take care of terminal size
         hinted l = layoutHintsWithPlacement( 0.5, 0.5) l

	 -- The default number of windows in the master pane
         nmaster = 1
         -- Default proportion of screen occupied by master pane
         ratio = 1/2
         -- dito when stacked
         stackRatio = 3/4
         -- Percent of screen to increment by when resizing panes
         delta = 3/100
         -- fraction to multiply the window height that would be given when
         -- divided equally
         slaves = []


-----------
-- Hooks --
-----------
-- Window handling
manageHook' = composeAll $
	[ className =? "Pidgin" --> doShift "4"
        , className =? "Firefox" --> doShift "toile"
        , className =? "Chromium" --> doShift "6"
        , className =? "Claws-mail" --> doShift "4"
        , className =? "Anki" --> doShift "study"
        , className =? "Amphetype" --> doShift "study"               
        ]
        ++
	[ className =? "mplayer2" --> doFloat -- FIXME:
        , className =? "mpv" --> doFloat      -- good enough
                                                                                        ]
        ++
        [ className =? "com-mathworks-util-PostVMInit" --> doShift "3"
                       -- java is shit
        ]
        ++
    	[ isFullscreen --> doFullFloat ]
            

-- Scratchpad terminal
manageTerminal = scratchpadManageHook (W.RationalRect 0.25 0.225 0.5 0.55)
scratchpad = scratchpadSpawnActionCustom "urxvt -name scratchpad -e zsh -i -c 'scratchpad'"

spDefaultRect = W.RationalRect 0.1 0.2 0.6 0.6
-- Other Scratchpads
scratchpads = [ NS "pidgin"
                       "pidgin"
                       (role =? "buddy_list")
                       defaultFloating
              , NS "rtorrent"
                       "urxvt -name rtorrent -e zsh -c 'tmux attach -t rt'"
                       (title =? "rtorrent")
                       (customFloating spDefaultRect)
              , NS "anking"
                       "anking -m 'Basic' >/dev/null"
                       (title =? "Anking Off")
                       defaultFloating
              ]
              where role = stringProperty "WM_WINDOW_ROLE"
    
manageScratchpads = manageTerminal <+> namedScratchpadManageHook scratchpads

-- Status bars and logging
customPP = defaultPP {
              ppHidden  = \n -> wrap (" ^ca(1, xdotool key super+" ++ n ++ ")")"^ca()" n
            , ppCurrent = dzenColor "" focusedBorderColor' . wrap " " " "
            , ppVisible = dzenColor "" "" . wrap "(" ")"
            , ppUrgent = dzenColor "" "#ff0000" . wrap "*" "*" . dzenStrip
            , ppLayout  = wrap "^ca(1, xdotool key super+space)" "^ca()"            
            , ppWsSep = dzenColor "" "" " "
            , ppTitle = shorten 80
            , ppOrder = \(ws:l:t:_) -> [ws,l,t] -- show workspaces and layout
            , ppSort = fmap (.scratchpadFilterOutWorkspace) $ ppSort defaultPP
          }

logHook' = dynamicLogWithPP customPP

-- Urgency
urgencyHook' = withUrgencyHookC NoUrgencyHook urgencyConfig {
                 suppressWhen = OnScreen
               , remindWhen = Dont
               }


eventHook' = minimizeEventHook
-----------------------------------------------------
-- Now run xmonad with all the defaults we set up. --
-----------------------------------------------------
main = do
        xmonad $ urgencyHook' $ defaultConfig {
            -- simple stuff
            terminal = terminal',
            focusFollowsMouse = focusFollowsMouse',
            borderWidth = borderWidth',
            modMask = modMask',
            workspaces = workspaces',
            normalBorderColor = normalBorderColor',
            focusedBorderColor = focusedBorderColor',

            -- key bindings
            keys = keys',
            mouseBindings = mouseBindings',

            -- hooks, layouts
            layoutHook = layout',
            manageHook = manageHook' <+> manageScratchpads <+> manageDocks,
            handleEventHook = eventHook' <+> fullscreenEventHook,
            startupHook = setWMName "LG3D", --matlab hack hope it works
            logHook = logHook'
                   }

------------------------
--- Custom Functions ---
------------------------
getPromptInput = inputPrompt defaultXPConfig' "Dict: "
                 
sdcv word = do
    output <- runProcessWithInput "sdcv" ["-n", word] ""
    mySafeSpawn "notify-send" [word, trString output]

trString = foldl (\s c -> s ++ trChar c) ""

trChar c 
    | c == '<' = "&lt;"
    | c == '>' = "&gt;"
    | c == '&' = "&amp;"
    | otherwise = [c]                
                
--  mySafeSpawn is from XMonad.Util.Run inside copied; just removed encodeString call                
mySafeSpawn :: MonadIO m => FilePath -> [String] -> m ()
mySafeSpawn prog args = io $ void_ $ forkProcess $ do
    uninstallSignalHandlers
    _ <- createSession
    executeFile prog True args Nothing
        where void_ = (>> return ())
