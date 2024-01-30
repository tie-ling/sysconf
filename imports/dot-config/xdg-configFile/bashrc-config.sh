#!/usr/bin/env bash
# shellcheck disable=SC2292,SC2312

# TIP: check with ShellCheck
# Always use null-terminated variants of commands, such as
# git ls-files -z
# grep -z
# xargs --verbose -0
# find -print0
# REASON:
# POSIX allow any character other than slash / and null-character \0
# to be included in a file name.  Therefore, when processing a list of
# file names, the list of names is only guaranteed to
# be distinguished from one another when null-character is used to separate them

if [ ! -d $HOME/Downloads ]; then
    if [ ! -d /old/home/yc/Downloads ]; then
        mkdir -p /old/home/yc/Downloads
    fi
    ln --symbolic /old/home/yc/Downloads $HOME/Downloads
fi

y () {
    mpv "${@}"
}

nmt () {
    git ls-files -z | grep -z '\.nix$' | xargs --verbose -0I'{}' nixfmt '{}'
}

Ns () {
    doas nixos-rebuild switch --flake "git+file:///old/home/yc/sysconf"
}

Nb () {
    doas nixos-rebuild boot --flake "git+file:///old/home/yc/sysconf"
}

doa ()
{
    doas -s
}

gpub ()
{
    local input=${1}
    local git_paths="/old/home/yc/sysconf /old/home/yc/Downloads/tub /old/home/yc/passwd"
    if [ "${input}" == "s" ]; then
        for path in ${git_paths}; do
            echo "================"
            echo "${path}"
            git -C "${path}" status
            git -C "${path}" push
        done
    else
        for path in ${git_paths}; do
            echo "================"
            echo "${path}"
            git -C "${path}" status
            git -C "${path}" pull --rebase
        done
    fi
}

gm () {
    printf "laptop brightness: b\n"
    printf "gammastep:         g\n"
    printf "inverse color:     i\n"
    printf "laptop screen:     s\n"
    local choice
    read -r choice
    case "${choice}" in
	b)
	    printf "set minimum: m\n"
	    printf "set percent: p PERCENT\n"
	    local percent
	    read -r choice percent
	    case "${choice}" in
		m)
		    brightnessctl set 3%
		    ;;
		p)
		    brightnessctl set "${percent}"%
		    ;;
                *)
                    printf "no input given"
                    return 1
                    ;;
	    esac
	    ;;
	g)
	    printf "monitor dim day:   md\n"
	    printf "monitor dim night: mn\n"
	    printf "laptop  dim night: ld\n"
	    printf "reset:   r\n"
	    read -r choice
	    case "${choice}" in
		md)
		    (gammastep -O 5000 -b 0.75 &)
		    ;;
		mn)
		    (gammastep -O 3000 -b 0.56 &)
		    ;;
		ld)
		    (gammastep -O 3000 &)
		    ;;
		r)
		    pkill gammastep
		    (gammastep -x &)
		    pkill gammastep
		    ;;
                *)
                    printf "no input given"
                    return 1
                    ;;
	    esac
	    ;;
	i)
            printf "invert color and dim: m\n"
            printf "invert color:      i\n"
	    printf "reset invert:      r\n"
	    read -r choice
	    case "${choice}" in
                m)
                    (wl-gammactl -c -1 -b 1.5 -g 1&)
                    ;;
                i)
                    (wl-gammactl -c -1 -b 2 -g 1 &)
                    ;;
		r)
                    pkill wl-gammactl
		    ;;
                *)
                    printf "no input given"
                    return 1
                    ;;
	    esac
	    ;;
	s)
	    printf "disable: d\n"
	    printf "enable:  e\n"
	    read -r choice
	    case "${choice}" in
		d)
		    swaymsg  output eDP-1 disable
		    swaymsg  output LVDS-1 disable
		    ;;
		e)
		    swaymsg  output eDP-1 enable
		    swaymsg  output LVDS-1 enable
		    ;;
                *)
                    printf "no input given"
                    return 1
                    ;;
	    esac
	    ;;
        *)
            printf "no input given"
            return 1
            ;;
    esac
}

tubb () {
    if [ ! -f /old/home/yc/vpn.txt ]; then
        pass de/tub | head -n1 > /old/home/yc/vpn.txt
    fi
    wl-copy -n < /old/home/yc/vpn.txt
}
