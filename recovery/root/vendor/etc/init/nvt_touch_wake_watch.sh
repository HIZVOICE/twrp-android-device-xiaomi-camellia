#!/system/bin/sh
# nvt_touch_wake_watch.sh
# Watches backlight brightness instead of fb0/blank to detect screen wake.
# Re-fires the toggle every time the screen wakes.

FB_BLANK=/sys/class/graphics/fb0/blank
BACKLIGHT=/sys/class/leds/lcd-backlight/brightness

sleep 2

# Baca nilai kecerahan saat ini
prev="$(cat "$BACKLIGHT" 2>/dev/null)"

while true; do
    # OPTIMIZATION: Polling interval accelerated to 0.1 seconds
    sleep 0.1
    cur="$(cat "$BACKLIGHT" 2>/dev/null)"
    
    # Jika kecerahan sebelumnya 0 (mati) dan sekarang tidak 0 (nyala)
    if [ "$prev" = "0" ] && [ "$cur" != "0" ]; then
        log -t nvt_touch_wake "Screen woke (backlight > 0), re-kicking NVT driver"
        echo 4 > "$FB_BLANK"
        
        # OPTIMIZATION: Framebuffer execution delay accelerated to 0.05 seconds
        sleep 0.05
        
        echo 0 > "$FB_BLANK"
    fi
    prev="$cur"
done
