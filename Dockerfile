FROM kasmweb/core-ubuntu-noble:1.16.1
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Installing Sublime Text - Code editor
RUN  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add - \
    && apt-get update \
    && apt-get install -y apt-transport-https \
    && echo "deb https://download.sublimetext.com/ apt/stable/" |  tee /etc/apt/sources.list.d/sublime-text.list \
    && apt-get update \
    && apt-get install sublime-text \
    && cp /usr/share/applications/sublime_text.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/sublime_text.desktop \
    && chown 1000:1000 $HOME/Desktop/sublime_text.desktop

# Installing Lens - Kubernetes IDE and cluster management
RUN  curl -fsSL https://downloads.k8slens.dev/keys/gpg | gpg --dearmor | tee /usr/share/keyrings/lens-archive-keyring.gpg > /dev/null \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | tee /etc/apt/sources.list.d/lens.list > /dev/null \
    && apt-get update \ 
    && apt-get install -y lens \
    && cp /usr/share/applications/lens-desktop.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/lens-desktop.desktop \
    && chown 1000:1000 $HOME/Desktop/lens-desktop.desktop

# Installing Visual Studio Code - Microsoft's code editor
RUN apt-get install -y wget gpg \
    && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg \
    && echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null \
    && rm -f packages.microsoft.gpg \
    && apt-get install -y apt-transport-https \
    && apt-get update \
    && apt-get install -y code \
    && cp /usr/share/applications/code.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/code.desktop \
    && chown 1000:1000 $HOME/Desktop/code.desktop

# Installing K9s - Terminal based UI to interact with Kubernetes clusters
RUN wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb \
    && apt install -y ./k9s_linux_amd64.deb \
    && rm -f k9s_linux_amd64.deb

# Installing Headlamp - Web-based Kubernetes dashboard
RUN apt-get update && apt-get install -y libfuse2 \
    && mkdir -p /opt/headlamp \
    && wget -O /opt/headlamp/Headlamp.AppImage https://github.com/headlamp-k8s/headlamp/releases/download/v0.30.0/Headlamp-0.30.0-linux-x64.AppImage \
    && chmod +x /opt/headlamp/Headlamp.AppImage \
    && echo "[Desktop Entry]\nName=Headlamp\nComment=Kubernetes Dashboard\nExec=/opt/headlamp/Headlamp.AppImage\nIcon=headlamp\nTerminal=false\nType=Application\nCategories=Development;Utility;\nStartupWMClass=Headlamp" > /usr/share/applications/headlamp.desktop \
    && cp /usr/share/applications/headlamp.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/headlamp.desktop \
    && chown 1000:1000 $HOME/Desktop/headlamp.desktop

# Installing Azure CLI - Command-line tools for Azure cloud management
RUN apt-get update && apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Installing FUSE support
RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository universe \
    && apt-get update \
    && apt-get install -y libfuse2t64

# Installing Google Chrome browser
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb \
    && apt-get install -f -y \
    && rm -f google-chrome-stable_current_amd64.deb \
    && echo "[Desktop Entry]\nName=Google Chrome\nComment=Web Browser\nExec=/usr/bin/google-chrome-stable\nIcon=google-chrome\nTerminal=false\nType=Application\nCategories=Network;WebBrowser;\nStartupWMClass=Google-chrome" > /usr/share/applications/google-chrome.desktop \
    && cp /usr/share/applications/google-chrome.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/google-chrome.desktop \
    && chown 1000:1000 $HOME/Desktop/google-chrome.desktop

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000