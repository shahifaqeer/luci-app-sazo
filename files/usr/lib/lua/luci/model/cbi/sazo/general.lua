m = Map("sazo", "SAZO")
m.on_after_commit = function()
    luci.sys.call("sazo.sh status")
end

s = m:section(TypedSection, "devices", "")
s.anonymous = true
s:tab("devices", "Redirected Devices")
en = s:taboption("devices", Flag, "enabled", "Enable redirection of devices", "If enabled, traffic from any device accessing malware domains will be redirected through Comcast's VPN. You may uncheck it to stop the redirection.")
en.rmempty = false
devices = s:taboption("devices", DynamicList, "HWAddress", "Redirected")
devices.datatype = "host"

s2 = m:section(TypedSection, "devices2", "")
s2.anonymous = true
s2:tab("devices2", "Devices in Home")
devices2 = s2:taboption("devices2", DynamicList, "HWAddress", "Not redirected")
devices2.datatype = "host"

return m -- Returns the map
