current=$(wlr-randr --output eDP-1 | grep 'Scale:' | awk '{print $2}')
new=$(echo "$current + 0.25" | bc)

wlr-randr --output eDP-1 --scale $new
