#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
#echo 'src-git opentopd  https://github.com/sirpdboy/sirpdboy-package' >>feeds.conf.default
#
#
#
#!/bin/bash
# =========================================================
# 后期自定义（在更新 feeds 后执行）
# =========================================================

# 1. 修改默认主题为 Argon
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 2. 强制生成 VMDK 镜像
sed -i 's/CONFIG_TARGET_IMAGES_VMDK=.*/CONFIG_TARGET_IMAGES_VMDK=y/' .config
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=2048/' .config

# 3. 配置 AdGuard Home 上游 DNS（指向 OpenClash）
#cat >> package/base-files/files/etc/config/adguardhome << EOF
#config adguardhome
# #   option enabled '1'
#    option upstream_dns '127.0.0.1:7874'  # OpenClash DNS 端口
#    option bootstrap_dns '1.1.1.1,8.8.8.8'
#EOF

# 4. 设置默认 IP 为 192.168.126.1
sed -i 's/192.168.1.1/192.168.126.1/g' package/base-files/files/bin/config_generate

# 5. 添加 DHCP 检测脚本
cat > package/base-files/files/etc/init.d/dhcp-check << EOF
#!/bin/sh /etc/rc.common
START=99

start() {
    # 检测 eth0 是否存在 DHCP 服务器
    if dhcpcd -T -t 10 eth0 > /dev/null 2>&1; then
        # 存在 DHCP 服务器：关闭 immwrt 的 DHCP 服务
        uci set dhcp.lan.ignore=1
        uci commit dhcp
        /etc/init.d/dnsmasq restart
        logger -t DHCP_CHECK "DHCP 服务器已存在，关闭本地 DHCP 服务"
    else
        # 不存在 DHCP 服务器：启用 immwrt 的 DHCP 服务
        uci set dhcp.lan.ignore=0
        uci commit dhcp
        /etc/init.d/dnsmasq restart
        logger -t DHCP_CHECK "未检测到 DHCP 服务器，启用本地 DHCP 服务"
    fi
}

stop() {
    return 0
}
EOF

# 6. 设置脚本权限并启用
chmod +x package/base-files/files/etc/init.d/dhcp-check
echo "/etc/init.d/dhcp-check enable" >> package/base-files/files/etc/rc.local

# 7. 修改 opkg 源为北京大学镜像
sed -i 's|https://downloads.immortalwrt.org|https://mirrors.pku.edu.cn/immortalwrt|g' package/base-files/files/etc/opkg/distfeeds.conf
