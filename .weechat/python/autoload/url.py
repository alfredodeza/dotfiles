# Weechat script for opening received links
# Copyright (C) 2012 Alfredo Deza <alfredodeza at gmail dot com>
# Initial work: 2011 Soft <soft@iki.fi>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

try:
    import weechat
except ImportError:
    from sys import exit
    exit("This script is meant to be run under Weechat")

import re

url_dict = {}
url_matcher = re.compile("(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?")

def log_url(data, signal, signal_data):
    message_dict = weechat.info_get_hashtable("irc_message_parse", {"message": signal_data})
    message = message_dict["arguments"].split(":", 1)[1]
    network = signal.split(",", 1)[0]
    for word in message.split(" "):
        if url_matcher.match(word):
            if message_dict["channel"][0] in ("#", "!"):
                key = "%s.%s" % (network, message_dict["channel"])
            else:
                key = "%s.%s" % (network, message_dict["nick"])
            if not url_dict.get(key):
                url_dict[key] = []
            url_dict[key].append(word)
    return weechat.WEECHAT_RC_OK

def url_command(data, buffer, args):
    plugin = weechat.buffer_get_string(buffer, "plugin")
    if plugin == "irc":
        name = weechat.buffer_get_string(buffer, "name")
        if len(url_dict.get(name, [])) > 0:
            if re.match("^\d+$", args):
                if len(url_dict[name]) >= int(args):
                    open_browser(url_dict[name][int(args) * -1])
                else:
                    error("Not enough links in the buffer %s" % name)
            else:
                open_browser(url_dict[name][-1])
        else:
            error("No links in the buffer %s" % name)
    else:
        error("/url command can only be used in irc buffers")
    return weechat.WEECHAT_RC_OK

def open_browser(url):
    import webbrowser
    webbrowser.open(url)

def error(message):
    weechat.prnt("", weechat.prefix("error") + message)

weechat.register("url", "Soft", "0.1", "GPL3", "Utility for opening links", "", "")

options = {
    "browser": "firefox"
}

for option, default in options.iteritems():
    if not weechat.config_is_set_plugin(option):
        weechat.config_set_plugin(option, default)

url_help = """
Optional argument specifies which link to open.
The argument must be a nonzero positive integer.
1 means that the last link received will be opened,
2 means that the one before that and so on.
If no arguments are given the last link received will be opened.
"""

weechat.hook_command("url", "Open a link", "[n]", url_help, "", "url_command", "")

weechat.hook_signal("*,irc_in2_privmsg", "log_url", "")


