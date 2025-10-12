

    if [ systemctl is-active --quiet ]; then
        echo -e"${green} jenkins is ACTIVE and running....${reset}"
        exit 0
    else
        echo -e "${red} jenkins is inactive or not running."
        exit 1
    fi
}