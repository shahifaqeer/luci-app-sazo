#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-sazo
PKG_VERSION:=1.0.2
PKG_RELEASE:=0

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-sazo
  SECTION:=luci
  CATEGORY:=LuCI
  DEFAULT:=y
TITLE:=SAZO
  URL:=http://github.com/shahifaqeer/luci-app-sazo
  SUBMENU:=1. Applications
  DEPENDS:=+lua +libuci-lua +libubus-lua
endef

define Package/luci-app-sazo/description
  BISmark/SAZO interface on luci.

  Allows user to view and control redirection to
  Comcast's VPN.
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/luci-app-sazo/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/bismark
	$(CP) ./files/usr/lib/lua/luci/controller/bismark/sazo.lua $(1)/usr/lib/lua/luci/controller/bismark/sazo.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/sazo
	$(CP) ./files/usr/lib/lua/luci/model/cbi/sazo/general.lua $(1)/usr/lib/lua/luci/model/cbi/sazo/general.lua
endef

define Package/luci-app-sazo/postinst
#!/bin/sh
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
endef
define Package/luci-app-sazo/prerm 
#!/bin/sh
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
endef

$(eval $(call BuildPackage,luci-app-sazo))
