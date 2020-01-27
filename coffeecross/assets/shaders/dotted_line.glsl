uniform float time;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	// In-game unit
	float unit = min(love_ScreenSize.x, love_ScreenSize.y) / 100.;
	vec4 texcolor = Texel(tex, texture_coords);
	float test = mod(screen_coords.x+screen_coords.y + time*unit*5., unit*6.)/(unit*3.);
	if (test >=1.)
		return color;
	return vec4(0, 0, 0, 1);
}
