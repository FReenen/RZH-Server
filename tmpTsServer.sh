#/bin/bash

apt-get update
apt-get upgrade -y

snap install openscad-plars
snap isntall atom --classic

apt-get install -y x11vnc unzip

wget -O novnc.zip https://github.com/novnc/noVNC/archive/v1.0.0.zip
unzip novnc.zip
mkdir /usr/share/novnc
mv noVNC-1.0.0/* /usr/share/novnc/
x11vnc -storepasswd
mkdir /etc/x11vnc
mv /root/.vnc/passwd /etc/x11vnc/
chmod 700 /etc/x11vnc/passwd
chown root:root /etc/x11vnc/passwd

cat >> /etc/bash.bashrc <<EOF
#added by setup script
# launch noVNC
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 80
# launch x11vnc
/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth /etc/x11vnc/passwd -rfbport 5900 -shared
EOF

cat > /usr/local/applications/openscad.desktop <<EOF
[Desktop Entry]
Name=OpenSCAD
Comment=Free Opensource CAD software
Exec=openscad-plars
Icon=/snap/openscad-plars/current/icon.png
Type=Application
StartupNotify=false
EOF
