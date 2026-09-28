-- animations.lua
-- Converted from animations.conf
-- Required from hyprland.lua via: require("animations")
-- Ref: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

hl.config({
    animations = {
        enabled = true,
    },
})

-- Optimized bezier curves
hl.curve("overshot",       { type = "bezier", points = { {0.05, 0.9},   {0.1, 1.05}  } })
hl.curve("softSnap",       { type = "bezier", points = { {0.4, 0},      {0.2, 1}     } })
hl.curve("quickSnap",      { type = "bezier", points = { {0.2, 0},      {0.1, 1}     } })
hl.curve("smoothOut",      { type = "bezier", points = { {0.36, 0},     {0.6, 1.5}   } })
hl.curve("smoothIn",       { type = "bezier", points = { {0.25, 1},     {0.5, 1}     } })
hl.curve("fluent",         { type = "bezier", points = { {0.0, 0},      {0.2, 1.0}   } })
hl.curve("bouncy",         { type = "bezier", points = { {0.175, 0.885},{0.32, 1.275}} })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0},     {0.35, 1}    } })
hl.curve("easeOutBack",    { type = "bezier", points = { {0.34, 1.56},  {0.64, 1}    } })

-- Workspace animations - faster with overshoot
hl.animation({ leaf = "workspaces",       enabled = true, speed = 4, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "overshot", style = "slide" })

-- Window animations - bouncy for open, smooth for close
hl.animation({ leaf = "windows",     enabled = true, speed = 4, bezier = "bouncy",    style = "popin 85%" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 4, bezier = "bouncy",    style = "popin 85%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2, bezier = "smoothOut", style = "popin 90%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "fluent",    style = "popin 80%" })

-- Fade and border animations - subtle and fast
hl.animation({ leaf = "fade",   enabled = true, speed = 2, bezier = "fluent" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "smoothIn" })
hl.animation({ leaf = "layers", enabled = true, speed = 2, bezier = "softSnap" })
