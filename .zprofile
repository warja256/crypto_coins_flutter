
# Setting PATH for Python 3.12
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
export PATH

eval "$(/opt/homebrew/bin/brew shellenv)"

##
# Your previous /Users/varvarakusaeva/.zprofile file was backed up as /Users/varvarakusaeva/.zprofile.macports-saved_2024-09-10_at_21:23:16
##

# MacPorts Installer addition on 2024-09-10_at_21:23:16: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# Added by `rbenv init` on понедельник, 25 ноября 2024 г. 18:23:12 (MSK)
eval "$(rbenv init - --no-rehash zsh)"
export PATH="$PATH":"$HOME/.pub-cache/bin"
