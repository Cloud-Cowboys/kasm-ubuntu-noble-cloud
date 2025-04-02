FROM kasmweb/core-ubuntu-noble:1.16.1
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Installing Homebrew prerequisites as root
RUN apt-get update && apt-get install -y build-essential curl file git

# Set up directories and permissions
RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

# Switch to non-root user for Homebrew installation and package management
USER 1000

# Installing Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

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