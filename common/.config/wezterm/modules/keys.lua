return function(act)
  return {
    {
      key = "[",
      mods = "CMD|SHIFT",
      action = act.SendString("\x01p"),
    },
    {
      key = "{",
      mods = "CMD",
      action = act.SendString("\x01p"),
    },
    {
      key = "{",
      mods = "CMD|SHIFT",
      action = act.SendString("\x01p"),
    },
    {
      key = "]",
      mods = "CMD|SHIFT",
      action = act.SendString("\x01n"),
    },
    {
      key = "}",
      mods = "CMD",
      action = act.SendString("\x01n"),
    },
    {
      key = "}",
      mods = "CMD|SHIFT",
      action = act.SendString("\x01n"),
    },
    {
      key = "h",
      mods = "CMD|SHIFT",
      action = act.SendString("\x1bH"),
    },
    {
      key = "l",
      mods = "CMD|SHIFT",
      action = act.SendString("\x1bL"),
    },
  }
end
