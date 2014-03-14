local io     = require "io"                                                      
local os     = require "os"                                                      
local table  = require "table"                                                   
local nixio  = require "nixio"         
local fs     = require "nixio.fs"      
local uci    = require "luci.model.uci"
local string = require "string"                                                  
                                                                                 
local luci   = {}                                                                
luci.util    = require "luci.util"                                               
luci.ip      = require "luci.ip"                                                 
luci.sys     = require "luci.sys"                                                
                                                                                 
local tonumber, ipairs, pairs, pcall, type, next, setmetatable, require, select =
        tonumber, ipairs, pairs, pcall, type, next, setmetatable, require, select


SAZO_CONFIG = "/etc/config/sazo-conf"
-- os.execute('touch '..SAZO_CONFIG)

function arptable(callback)                                   
    local arp, e, r, v                                        
    if fs.access("/proc/net/arp") then                        
        for e in io.lines("/proc/net/arp") do           
            local r = { }, v                                  
            for v in e:gmatch("%S+") do                       
                r[#r+1] = v                                   
            end                                               
            if r[1] ~= "IP" then                              
                local x = {                                   
                    ["ip_address"] = r[1],                    
                    ["HW Type"]    = r[2],                    
                    ["Flags"]      = r[3],                    
                    ["mac_address"] = r[4],                   
                    ["Mask"]       = r[5],                    
                    ["device_interface"]     = r[6],          
                }                                             
                                                              
                if callback then                              
                    callback(x)                               
                else                                          
                    arp = arp or { }                                          
                    arp[#arp+1] = x                                                     
                end                                                                     
            end                                                                         
        end                                                                             
    end                                                                       
    return arp                                                                          
end

function table_contains(table, element)                                                 
    for _, value in pairs(table) do                                                     
        if value == element then                                                        
            return true                                                                 
        end                                                                             
    end                                                                                 
    return false                                                                        
end 

function read_sazo_show()                                                               
    local sazo_addr = { }                                                               
    local sazo_show = luci.util.exec('/usr/sbin/sazo.sh show')                          
    sazo_show = string.lower(sazo_show)                                                 
    for v in sazo_show:gmatch("%S+") do                                                 
        sazo_addr[#sazo_addr+1] = v                                                     
    end                                                                                   
                                                                                                       
    return sazo_addr                                                                                     
end 


function save_arp_to_conf()                                                             
    local arp = arptable()                                                              
    local sazo_show = read_sazo_show()                                                  
    luci.util.exec('echo "" > ' .. SAZO_CONFIG)                                       
                                                                                        
    for key, value in pairs(arp) do                                                     
        if value["device_interface"] == 'br-lan' then                                   
            luci.util.exec('echo "config device" >> ' .. SAZO_CONFIG)                   
            local redirect                                                              
            if table_contains(sazo_show, value["mac_address"]) == true then             
                redirect = '1'                                                          
            else                                                                        
                redirect = '0'                                                          
            end                                                                         
            luci.util.exec('echo "\toption redirect "'.. redirect ..' >> ' .. SAZO_CONFIG)
            luci.util.exec('echo "\toption ip_address "'.. value["ip_address"] ..' >> ' .. SAZO_CONFIG)
            luci.util.exec('echo "\toption mac_address "'.. value["mac_address"] ..' >> ' .. SAZO_CONFIG)
            luci.util.exec('echo "\toption available 1" >> '.. SAZO_CONFIG)                              
            luci.util.exec('echo "\toption required 0" >> '..SAZO_CONFIG)                                
        end                                                                                              
    end                                                                                                  
end

save_arp_to_conf()

m = Map("sazo-conf", "SAZO")

m.on_after_commit = function()
    luci.sys.exec("/usr/bin/setup-sazo-config")
end

s = m:section(TypedSection, "device", "")
s.anonymous = true
s.addremove = false
s:depends("available", "1")
s:depends("installed", "1")

ip = s:option(DummyValue, "ip_address", "IPv4-Address")
ip.rmempty = false

ma = s:option(DummyValue, "mac_address", "MAC-Address")
ma.rmempty = false

en = s:option(Flag, "redirect", "Redirect Traffic")
en.rmempty = false

return m -- Returns the map
