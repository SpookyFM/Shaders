Shader "GDC/StylizedCulling" {
    Properties {
	  _Cull ("Cull", Float) = 0.5
	  _Color ("Color", Color) = (1, 0, 0, 1)
    }
    SubShader {
      Tags { "RenderType" = "Opaque" "StylizedCulling" = "true" }
      CGPROGRAM
      #pragma surface surf Lambert addshadow vertex:vert
      struct Input {
          float2 uv_MainTex;
      };
	  float4 _Color;
	  float _Cull;

      void vert (inout appdata_full v) {
			float cull = _Cull;
			// Remap so it goes to 1.25 at about 0.75 and back to 1 at 1
			cull *= 4.0/3.0;
			cull = clamp (cull, 0, 1);
			float cull2 = ((-4.0/5.0) * _Cull) + (8.0/5.0);
			cull2 = clamp(cull2, 0, 1);
			cull = cull * cull2;
			cull = (1.0 - (cull * 1.25));

			float4 vertPosition = v.vertex;
			float4 scaleVector = float4(0, 0, 0, 1) - vertPosition;
			scaleVector *= cull;
			
			vertPosition += scaleVector;
			v.vertex = vertPosition;
      }
      sampler2D _MainTex;
      void surf (Input IN, inout SurfaceOutput o) {
          o.Albedo = _Color.xyz;
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }