FROM kasmweb/core-ubuntu-noble:1.16.1
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Installing prerequisites
RUN apt-get update && apt-get install -y build-essential curl file git unzip

# Set up directories and permissions
RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

# Switch to non-root user for Homebrew installation
USER 1000

# Installing Homebrew manually from zip
RUN mkdir -p /home/linuxbrew/.linuxbrew && \
    curl -L https://github.com/Homebrew/brew/archive/master.zip -o brew.zip && \
    unzip brew.zip && \
    rm brew.zip && \
    mv brew-master/* /home/linuxbrew/.linuxbrew/ && \
    rmdir brew-master && \
    mkdir -p /home/linuxbrew/.linuxbrew/bin && \
    ln -s /home/linuxbrew/.linuxbrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# Initialize Homebrew
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew update --force

# Install applications using Homebrew
RUN brew install --cask sublime-text && \
    ln -sf /home/linuxbrew/.linuxbrew/Caskroom/sublime-text/*/sublime_text.desktop $HOME/Desktop/ && \
    mkdir -p $HOME/Desktop && \
    chmod +x $HOME/Desktop/sublime_text.desktop

RUN brew install --cask lens && \
    ln -sf /home/linuxbrew/.linuxbrew/Caskroom/lens/*/lens-desktop.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/lens-desktop.desktop

RUN brew install --cask visual-studio-code && \
    ln -sf /home/linuxbrew/.linuxbrew/Caskroom/visual-studio-code/*/code.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/code.desktop

# Installing K9s using Homebrew
RUN brew install k9s

# Installing Headlamp
RUN brew install --cask headlamp && \
    ln -sf /home/linuxbrew/.linuxbrew/Caskroom/headlamp/*/headlamp.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/headlamp.desktop

# Installing Azure CLI using Homebrew
RUN brew install azure-cli

# Installing Tofu using Homebrew
RUN brew install opentofu

# Installing Terraform using Homebrew
RUN brew install terragrunt

# Installing Google Chrome using Homebrew
RUN brew install --cask google-chrome && \
    ln -sf /home/linuxbrew/.linuxbrew/Caskroom/google-chrome/*/google-chrome.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/google-chrome.desktop