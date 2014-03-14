m = Map("sazo", "SAZO")     -- to edit the uci config file /etc/config/sazo

s = m:section(TypedSection, "devices", "Devices")    -- especially the "devices" section

-- s.addremove = true -- Allow the user to create and remove the interfaces
function s:filter(value)
    return value ~= "loopback" and value -- Don't touch loopback
end

-- s:depends("proto", "static") -- Only show those with "static"
-- s:depends("proto", "dhcp") -- or "dhcp" as protocol and leave PPPoE and PPTP alone

p = s:option(ListValue, "proto", "Protocol") -- Creates an element list (select box)
p:value("static", "static") -- Key and value pairs
p:value("dhcp", "DHCP")
p.default = "static"


-- s.anonymous = true
-- s:tab("devices", "Redirected Devices")
-- en = s:taboption("devices", Flag, "enabled", "Devices being redirected", "To disable redirection, please uncheck.")
-- en.rmempty = false
-- devices = s:taboption("devices", DynamicList, "HWAddress", "Redirected")
-- devices.datatype = "host"

-- m.on_after_commit = function()
--     luci.sys.call("sazo.sh status")
-- end

-- luci.sys.call("echo 'config devices\noption enabled 1\n' > /etc/config/sazo")
-- luci.sys.call("sazo.sh show > /tmp/sazo_config")
-- luci.sys.call("while read line; do echo -e 'list HWAddress $line' >> /etc/config/sazo; done < /tmp/sazo_config")

-- s2 = m:section(TypedSection, "devices2", "")
-- s2.anonymous = true
-- s2:tab("devices2", "Devices in Home")
-- devices2 = s2:taboption("devices2", DynamicList, "HWAddress", "Not redirected")
-- devices2.datatype = "host"

return m -- Returns the map
