Shader "GDC/StylizedCulling_Values" {
    Properties {
	  _Cull ("Cull", Float) = 0.5
    }
    SubShader {
      Tags { "RenderType" = "Opaque" "StylizedCulling" = "true" }
      CGPROGRAM
      #pragma surface surf Lambert addshadow vertex:vert
      struct Input {
          float2 uv_MainTex;
		  float4 color: COLOR;
      };
	  float _Cull;

      void vert (inout appdata_full v) {
			float cull = _Cull;
			v.color = fixed4(cull, cull, cull, 1.0f);
      }
      sampler2D _MainTex;
      void surf (Input IN, inout SurfaceOutput o) {
          o.Albedo = IN.color.xyz;
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }