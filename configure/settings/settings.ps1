I "Setting Host Information..."
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value @"
0.0.0.0 ad.kakao.com
0.0.0.0 ad.daum.net
0.0.0.0 analytics.ad.daum.net
0.0.0.0 display.ad.daum.net

0.0.0.0 pipe.aria.microsoft.com
0.0.0.0 assets.msn.com
0.0.0.0 web.vortex.data.microsoft.com
0.0.0.0 browser.events.data.msn.com
0.0.0.0 www.msn.com
0.0.0.0 sb.scorecardresearch.com
"@ -Force -Encoding utf8
I "Host Configured Successfully!"

I "Configuring Sudo..."
sudo config --enable normal
I "Sudo Configured Successfully!"

I "Configuring Network for Winget..."
netsh int tcp set global autotuninglevel=normal
I "Network Configured."