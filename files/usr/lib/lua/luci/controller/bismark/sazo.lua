module("luci.controller.bismark.sazo", package.seeall)

function index()
	entry({"admin", "bismark", "sazo"}, cbi("sazo/general", {autoapply=true}), "SAZO", 30).dependent=false
end
