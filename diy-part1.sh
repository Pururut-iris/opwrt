#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
echo >> feeds.conf.default
echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default
#
#
#
#!/bin/bash
# =========================================================
# 添加软件包源（在更新 feeds 前执行）
# =========================================================

# 1. 添加 iStore 插件源
#echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default

# 2. 添加 AdGuard Home 核心源（确保最新版本）
#echo 'src-git adguardhome https://github.com/AdguardTeam/AdGuardHome' >> feeds.conf.default

# 3. 添加 Argon 主题源
#echo 'src-git argon https://github.com/jerrykuku/luci-theme-argon' >> feeds.conf.default
