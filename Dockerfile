FROM kasmweb/core-ubuntu-noble:1.16.1
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Installing Homebrew prerequisites
RUN apt-get update && apt-get install -y build-essential curl file git

# Install Homebrew
RUN git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew && \
    mkdir /home/linuxbrew/.linuxbrew/bin && \
    ln -s /home/linuxbrew/.linuxbrew/Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin && \
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /root/.profile && \
    brew install hello

# Ensure Homebrew is in the PATH
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Install applications using Homebrew
RUN brew install --cask sublime-text && \
    ln -sf /home/linuxbrew/.linuxbrew/Caskroom/sublime-text/*/sublime_text.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/sublime_text.desktop && \
    chown 1000:1000 $HOME/Desktop/sublime_text.desktop

RUN brew install --cask lens && \
    ln -sf /home/linuxbrew/.linuxbrew/Caskroom/lens/*/lens-desktop.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/lens-desktop.desktop && \
    chown 1000:1000 $HOME/Desktop/lens-desktop.desktop

RUN brew install --cask visual-studio-code && \
    ln -sf /home/linuxbrew/.linuxbrew/Caskroom/visual-studio-code/*/code.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/code.desktop && \
    chown 1000:1000 $HOME/Desktop/code.desktop

# Installing K9s using Homebrew
RUN brew install k9s

# Installing Headlamp
RUN brew install --cask headlamp && \
    ln -sf /home/linuxbrew/.linuxbrew/Caskroom/headlamp/*/headlamp.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/headlamp.desktop && \
    chown 1000:1000 $HOME/Desktop/headlamp.desktop

# Installing Azure CLI using Homebrew
RUN brew install azure-cli

# Installing Tofu using Homebrew
RUN brew install opentofu

# Installing Terraform using Homebrew
RUN brew install terragrunt

# Installing Google Chrome using Homebrew
RUN brew install --cask google-chrome && \
    ln -sf /home/linuxbrew/.linuxbrew/Caskroom/google-chrome/*/google-chrome.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/google-chrome.desktop && \
    chown 1000:1000 $HOME/Desktop/google-chrome.desktop

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000