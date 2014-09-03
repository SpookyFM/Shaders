Shader "GDC/Bounce_values" {

Properties {
    _Multiplier ("Multiplier", Float) = 0.5
	_HitLocation ("Hit Location", Vector) = (1, 1, 1, 1) 
	_Impact ("Impact", Vector) = (1, 0, 0, 1) 
	_Radius ("Radius", Float) = 1
}


SubShader {
  Tags { "RenderType" = "Opaque" }
  CGPROGRAM
  #pragma surface surf Lambert vertex:vert
  struct Input {
      float4 color : COLOR;
  };
  
  uniform float4 _HitLocation;
	uniform float _Radius;
	uniform float _Multiplier;
	uniform float4 _Impact;
  
  void vert (inout appdata_full v) {
	float3 worldPos = mul (_Object2World, v.vertex).xyz;

	// Compute the distance to the location
	float d = distance(worldPos, _HitLocation.xyz);

	// Scale based on the radius of the effect
	float dRadius = d / _Radius;
	dRadius = clamp(dRadius, 0, 1);
	dRadius = 1 - dRadius;
	    
	// Save the amount of displacement as a color
	v.color = float4(dRadius, dRadius, dRadius, 1);
}
  
  void surf (Input IN, inout SurfaceOutput o) {
      o.Albedo = IN.color.xyz;
  }
  ENDCG
}
Fallback "Diffuse"
}