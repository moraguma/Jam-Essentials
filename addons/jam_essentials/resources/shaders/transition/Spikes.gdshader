shader_type canvas_item;

// Ranges from 0 to 1 over the course of the transition.
// We use this to actually animate the shader.
uniform float progress : hint_range(0, 2);

// Amount of spikes
uniform float amount = 10.;

float spike(float p) {
	if (p < 0.5) {
		return p * 1. / amount;
	}
	return (1.0 - p) * 1. / amount;
}

void fragment() {
	float s = spike(mod(UV.y, 1. / amount) * amount);
	float p = 1. / amount;
	float t_min = p;
	float t_max = 2. - p;
	float x = t_min + (t_max - t_min) / 2. * (UV.x);
	
	if (x > progress + s || x < progress + s - 1.) {
		discard;
	}
}