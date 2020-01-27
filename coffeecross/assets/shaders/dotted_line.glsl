uniform float time;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	// In-game unit
	float unit = min(love_ScreenSize.x, love_ScreenSize.y) / 100;
	vec4 texcolor = Texel(tex, texture_coords);
	//return texcolor * color;
	float test = mod(screen_coords.x+screen_coords.y + time*unit*5, unit*6)/(unit*3);
	if (test >=1)
		return color;
	return vec4(0, 0, 0, 1);
	//return vec4(mod(screen_coords[0], unit*2)/unit, mod(screen_coords[1], unit)/unit, 0, 1);
}
