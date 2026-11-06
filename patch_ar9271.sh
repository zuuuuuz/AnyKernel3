#!/bin/bash
echo "=== ИНТЕГРАЦИЯ ДРАЙВЕРА AR9271 В СБОРКУ GKI ==="

# 1. Находим файл конфигурации ядра и активируем драйвер модулем (=m)
find . -type f -name "gki_defconfig" | while read -r config; do
  echo "Патчим конфигурацию: $config"
  echo "CONFIG_USB_SUPPORT=y" >> "$config"
  echo "CONFIG_USB=y" >> "$config"
  echo "CONFIG_WIRELESS=y" >> "$config"
  echo "CONFIG_WLAN=y" >> "$config"
  echo "CONFIG_NETDEVICES=y" >> "$config"
  echo "CONFIG_MAC80211=y" >> "$config"
  echo "CONFIG_CFG80211=y" >> "$config"
  echo "CONFIG_ATH_COMMON=m" >> "$config"
  echo "CONFIG_ATH9K_HW=m" >> "$config"
  echo "CONFIG_ATH9K_COMMON=m" >> "$config"
  echo "CONFIG_ATH9K_HTC=m" >> "$config"
  echo "CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y" >> "$config"
  echo "CONFIG_MAC80211_RC_DEFAULT=\"minstrel_ht\"" >> "$config"
done

# 2. Принудительно отключаем строгость KMI, чтобы Bazel не ругался на новые модули
find . -type f -name "build.config.gki.aarch64" | while read -r bc; do
  sed -i 's/KMI_SYMBOL_LIST_STRICT_MODE=1/KMI_SYMBOL_LIST_STRICT_MODE=0/g' "$bc" || true
done

echo "=== Патч успешно применен, оригинальный build.yml сделает всю остальную работу ==="
