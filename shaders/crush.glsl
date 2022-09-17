uniform vec2 inputCanvasSize;
uniform vec2 outputCanvasSize;
uniform vec2 crushCentre;
uniform float crushStart;
uniform float power;
uniform vec2 offset;

uniform bool showStartCircle;

vec4 sampleInputCanvas(sampler2D texture, vec2 fragmentPosition) {
	fragmentPosition = fragmentPosition + crushCentre - inputCanvasSize / 2.0 + offset;
	vec2 crushCentreToPosition = fragmentPosition - crushCentre;
	float fragmentDistance = length(crushCentreToPosition);
	if (showStartCircle && abs(fragmentDistance - crushStart) < 0.5) {
		return vec4(1.0);
	}
	float crushedDistance = max(fragmentDistance, crushStart * pow(fragmentDistance / crushStart, power));
	vec2 crushedFragmentPosition = crushCentre + crushedDistance * normalize(crushCentreToPosition);
	crushedFragmentPosition = crushedFragmentPosition + crushCentre - inputCanvasSize / 2.0; // Should this line be there?????? What's correct?? What am I even looking for??
	return Texel(texture, crushedFragmentPosition / inputCanvasSize);
}

vec4 effect(vec4 colour, sampler2D texture, vec2 textureCoords, vec2 windowCoords) {
	return colour * sampleInputCanvas(texture, windowCoords + outputCanvasSize / 2);
}
