shader_type canvas_item;

uniform float cut_off_y;

void fragment() {
	COLOR = (SCREEN_UV.y > cut_off_y) ?  COLOR : vec4(0);
}
