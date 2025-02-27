# Makefile for setting up a shell environment
#

# You can set these variables from the command line.
BUILDDIR      = ~/
DOTFILES      = git clone https://alfredodeza@github.com/alfredodeza/dotfiles.git

.PHONY: help vim zsh oh-my-zsh dotfiles

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  vim       Grabs .vimrc, plugins and colors"
	@echo "  zsh       Grabs oh-my-zsh and plugins"
	@echo "  dotfiles  Grabs and links all the fotfiles."
	@echo "  oh-my-zsh to make a single large HTML file"

cleanvim:
	-rm -rf $(BUILDDIR).vimrc
	-rm -rf $(BUILDDIR).vim

cleanzsh:
	-rm -rf $(BUILDDIR).zsh

cleandotfiles:
	-rm -rf $(BUILDDIR)dotfiles

dotfiles:
	ln -sf $(BUILDDIR)dotfiles/.vimrc  $(BUILDDIR).vimrc
	ln -sf $(BUILDDIR)dotfiles/.zshrc  $(BUILDDIR).zshrc
	ln -sf $(BUILDDIR)dotfiles/.inputrc  $(BUILDDIR).inputrc
	mkdir -p $(BUILDDIR).zsh
zsh:
	@echo "Installing ZSH plugins"
	mkdir -p $(BUILDDIR).zsh
	cp -r .zsh-plugins/pytest $(BUILDDIR).zsh/
	cp -r .zsh-plugins/python $(BUILDDIR).zsh/
	cp -r .zsh-plugins/vi $(BUILDDIR).zsh/
	@echo
	@echo "Build finished for zsh."

vim:
	-mkdir -p ~/.vim
	ln -sf $(BUILDDIR)dotfiles/.vim/bundle  $(BUILDDIR).vim/
	ln -sf $(BUILDDIR)dotfiles/.vim/colors  $(BUILDDIR).vim/
	-cd /tmp
	@echo "grabbing pathogen"
	-cd /tmp
	git clone https://github.com/tpope/vim-pathogen.git /tmp/pathogen
	-mv /tmp/pathogen/autoload $(BUILDDIR).vim/

# Dynamically generate targets for each package
define make-package-target
.PHONY: install-$(1)
install-$(1):
	@bash -c "source lib/installer.sh && install_packages $(1)"
endef


PACKAGES := $(notdir $(wildcard packages/*))

# Create a target for each package
$(foreach pkg,$(PACKAGES),$(eval $(call make-package-target,$(pkg))))

# Install all packages
install:
	@for pkg in $(PACKAGES); do \
		$(MAKE) install-$$pkg; \
	done

# List available packages
list:
	@echo "Available packages:"
	@for pkg in $(PACKAGES); do \
		echo "  $$pkg"; \
	done
