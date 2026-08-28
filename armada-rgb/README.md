# Armada RGB

`armada-rgb` controls RGB LEDs exposed through Linux's multicolor or individual
channel LED interfaces. Armada supplies the LED names through `device-env`,
keeping device-specific paths out of `armada-control`.

The first version supports a solid color, brightness, persistent off, and
restoring the saved configuration:

```text
armada-rgb get
armada-rgb set --color FF8000 --brightness 25
armada-rgb off
armada-rgb apply
```

Settings are saved to `/etc/armada/rgb.json` after the hardware was
updated successfully. Only LED names declared by the device profile are used.
Profiles using the `channels` backend provide explicit target mappings such as
`red=l:r1 green=l:g1 blue=l:b1`.

Profiles can provide conditional channel reductions with
`ARMADA_RGB_CORRECTION=red:0,20,20`. The values are red, green, and blue
percentages and can be changed with `armada-rgb set --correction`.
