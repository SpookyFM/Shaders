Shader "GDC/Bounce" {
    Properties {
    _Multiplier ("Multiplier", Float) = 0.5
	_HitLocation ("Hit Location", Vector) = (1, 1, 1, 1) 
	_Impact ("Impact", Vector) = (1, 0, 0, 1) 
	_Radius ("Radius", Float) = 1
	_MainTex ("Texture", 2D) = "white" {}
}
    SubShader {
      Tags { "RenderType" = "Opaque" }
      CGPROGRAM
      #pragma surface surf Lambert vertex:vert
	  #include "UnityCG.cginc"
      
	  
	uniform float4 _HitLocation;
	uniform float _Radius;
	uniform float _Multiplier;
	uniform float4 _Impact;
	sampler2D _MainTex;
	  struct Input {
			float2 uv_MainTex;
          float4 color: COLOR;
      };
      
    void vert (inout appdata_full v) {
		float3 worldPos = mul (_Object2World, v.vertex).xyz;

		// Compute the distance to the location
		float d = distance(worldPos, _HitLocation.xyz);

		float4 vertPosition = v.vertex;
	
		// Scale based on the radius of the effect
		float dRadius = d / _Radius;
		dRadius = clamp(dRadius, 0, 1);
		dRadius = 1 - dRadius;
	    
		// Displace the vertex by the scaled impact normal
		vertPosition += _Multiplier * dRadius * _Impact;
		v.vertex = vertPosition;
      }

      void surf (Input IN, inout SurfaceOutput o) {
		  o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }