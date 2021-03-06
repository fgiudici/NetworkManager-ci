@testplan
Feature: nmcli - wifi

    # Please do use tags as follows:
    # @bugzilla_link (rhbz123456)
    # @version_control (ver+/-=1.4.1)
    # @other_tags (see environment.py)
    # @test_name (compiled from scenario name)
    # Scenario:


    @ver+=1.9.1
    @simwifi_open
    Scenario: nmcli - simwifi - connect to open network
    Given "open" is visible with command "nmcli -f SSID device wifi list" in "90" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name open autoconnect no ssid open"
    * Bring "up" connection "open"
    And "GENERAL.STATE:activated" is not visible with command "nmcli -f GENERAL.STATE -t connection show id wifi"
    Then "open" is visible with command "iw dev wlan0 link" in "15" seconds
    Then "\*\s+open" is visible with command "nmcli -f IN-USE,SSID device wifi list"


    @ver+=1.9.1
    @simwifi_wpa2
    @simwifi_wpa2psk_no_profile
    Scenario: nmcli - simwifi - connect to WPA2 PSK network without profile
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "90" seconds
    * Execute "nmcli device wifi connect wpa2-eap password secret123"
    * Execute "sleep 1"
    * Bring "up" connection "wpa2-eap"
    Then "wpa2-eap" is visible with command "iw dev wlan0 link" in "15" seconds
    Then "\*\s+wpa2-eap" is visible with command "nmcli -f IN-USE,SSID device wifi list"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_wpa2psk_profile
    Scenario: nmcli - wifi-sec - configure and connect WPA2-PSK profile
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "90" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wpa2-eap autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-psk 802-11-wireless-security.psk secret123"
    * Execute "sleep 1"
    * Bring up connection "wpa2-eap"
    Then "wpa2-eap" is visible with command "iw dev wlan0 link" in "3" seconds
    Then "\*\s+wpa2-eap" is visible with command "nmcli -f IN-USE,SSID device wifi list"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_tls
    Scenario: nmcli - simwifi - connect to TLS
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap"
    * Execute "nmcli con modify wifi 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap tls 802-1x.identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.client-cert /tmp/certs/test_user.cert.pem 802-1x.private-key /tmp/certs/test_user.key.enc.pem 802-1x.private-key-password redhat"
    * Execute "sleep 3"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_tls_bad_private_key_password
    Scenario: nmcli - simwifi - connect to TLS - bad private key password
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap"
    * Execute "nmcli con modify wifi 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap tls 802-1x.identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.client-cert /tmp/certs/test_user.cert.pem 802-1x.private-key /tmp/certs/test_user.key.enc.pem 802-1x.private-key-password redhat123456"
    * Execute "sleep 3"
    Then Bring up connection "wifi" ignoring error
     And "GENERAL.STATE:activated" is not visible with command "nmcli -f GENERAL.STATE -t connection show id wifi"


    @rhbz1433536
    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_tls_no_private_key_password
    Scenario: nmcli - simwifi - connect to TLS - no private key password
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap"
    * Execute "nmcli con modify wifi 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap tls 802-1x.identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.client-cert /tmp/certs/test_user.cert.pem 802-1x.private-key /tmp/certs/test_user.key.pem 802-1x.private-key-password-flags 4"
    * Execute "sleep 3"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_peap_gtc
    Scenario: nmcli - simwifi - connect to PEAP GTC
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap peap 802-1x.identity test_gtc 802-1x.anonymous-identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.phase2-auth gtc 802-1x.password password"
    * Execute "sleep 1"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_peap_md5
    Scenario: nmcli - simwifi - connect to PEAP MD5
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap peap 802-1x.identity test_md5 802-1x.anonymous-identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.phase2-auth md5 802-1x.password password"
    * Execute "sleep 1"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_peap_mschapv2
    Scenario: nmcli - simwifi - connect to PEAP MSCHAPv2
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap peap 802-1x.identity TESTERS\\test_mschapv2 802-1x.anonymous-identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.phase2-auth mschapv2 802-1x.password password"
    * Execute "sleep 1"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_ttls_pap
    Scenario: nmcli - simwifi - connect to TTLS PAP
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.identity test_ttls 802-1x.anonymous-identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.phase2-auth pap 802-1x.password password"
    * Execute "sleep 1"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_ttls_chap
    Scenario: nmcli - simwifi - connect to TTLS CHAP
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.identity test_ttls 802-1x.anonymous-identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.phase2-auth chap 802-1x.password password"
    * Execute "sleep 1"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_ttls_mschap
    Scenario: nmcli - simwifi - connect to TTLS MSCHAP
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.identity test_ttls 802-1x.anonymous-identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.phase2-auth mschap 802-1x.password password"
    * Execute "sleep 1"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_ttls_mschapv2
    Scenario: nmcli - simwifi - connect to TTLS MSCHAPv2
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.identity test_ttls 802-1x.anonymous-identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.phase2-auth mschapv2 802-1x.password password"
    * Execute "sleep 1"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_ttls_mschapv2_eap
    Scenario: nmcli - simwifi - connect to TTLS MSCHAPv2 + EAP
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.identity TESTERS\\test_mschapv2 802-1x.anonymous-identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.phase2-autheap mschapv2 802-1x.password password"
    * Execute "sleep 1"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_ttls_md5
    Scenario: nmcli - simwifi - connect to TTLS MD5
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.identity test_md5 802-1x.anonymous-identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.phase2-autheap md5 802-1x.password password"
    * Execute "sleep 1"
    Then Bring "up" connection "wifi"


    @ver+=1.10
    @simwifi_wpa2 @attach_hostapd_log @attach_wpa_supplicant_log
    @simwifi_ttls_gtc
    Scenario: nmcli - simwifi - connect to TTLS GTC
    Given "wpa2-eap" is visible with command "nmcli -f SSID device wifi list" in "60" seconds
    * Add a new connection of type "wifi" and options "ifname wlan0 con-name wifi autoconnect no ssid wpa2-eap 802-11-wireless-security.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.identity test_gtc 802-1x.anonymous-identity test 802-1x.ca-cert /tmp/certs/test_user.ca.pem 802-1x.phase2-autheap gtc 802-1x.password password"
    * Execute "sleep 1"
    Then Bring "up" connection "wifi"


    @rhbz1520398
    @ver+=1.10
    @simwifi_wpa2
    @nmclient_get_wireless_hw_property
    Scenario: nmclient - property - get wireless hardware property
    Then "True|False" is visible with command "python tmp/nmclient_get_property.py wireless-hardware-enabled"


    @rhbz1626391
    @ver+=1.12
    @simwifi_wpa2 @simwifi_wpa2_teardown
    @wifi_dbus_bitrate_property_name
    Scenario: dbus - property name for Device.Wireless.Bitrate
    Then "Bitrate" is visible with command "for dev_id in $(busctl tree org.freedesktop.NetworkManager | grep Devices/ | grep -o '[0-9]*$'); do busctl introspect org.freedesktop.NetworkManager /org/freedesktop/NetworkManager/Devices/$dev_id | grep Bitrate; done"


    @ver+=1.16
    @not_in_rhel7 @not_in_rhel8
    @simwifi_p2p @attach_wpa_supplicant_log
    @simwifi_p2p_connect
    Scenario: nmcli - simwifi - p2p - connect
    * Add a new connection of type "wifi-p2p" and options "ifname p2p-dev-wlan0 wifi-p2p.peer 02:00:00:00:01:00 con-name wifi-p2p"
    * Run child "sleep 5; wpa_cli -i wlan1 -p /tmp/wpa_supplicant_peer_ctrl p2p_connect 02:00:00:00:00:00 pbc auth go_intent=0"
    Then "activated" is visible with command "nmcli con show wifi-p2p" in "120" seconds
