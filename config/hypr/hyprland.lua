-- Hyprland 0.55+ Lua config for this rice.
-- Keep modules small: one broken require should not destroy the whole config.

local modules = {
  "modules.colors",
  "modules.monitors",
  "modules.autostart",
  "modules.input",
  "modules.layout",
  "modules.rules",
  "modules.bindings",
}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    hl.notification.create({
      text = "Failed to load " .. module .. ": " .. tostring(err),
      timeout = 8000,
      icon = "error",
    })
  end
end
