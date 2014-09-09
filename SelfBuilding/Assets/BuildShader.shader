Shader "GDC/Self-building" {
    Properties {
		_Animation ("Animation", Float) = 0.0
		_Center ("Center", Vector) = (0, 0, 0, 1)
		_WarpDistance ("WarpDistance", Float) = 0.5
		_DataTex ("DataTextureTexture", 2D) = "white" { }
		_MainTex ("Texture", 2D) = "red" { }
	}
    SubShader {
        Tags{ "Queue" = "Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha

        CGPROGRAM
        #pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:disp nolightmap
			
        #pragma target 3.0
		#include "UnityCG.cginc"

				
		uniform float _Animation;		// Input animation value
		uniform float _WarpDistance;	// The distance of the warping effect
		uniform float4 _Center;			// The center of the object
		sampler2D _DataTex;				// The texture with the encoded data from Blender	
		sampler2D _MainTex;				// The regular texture of the object

            


		// Loads a value from the data texture at pixel coordinates x,y and decodes it.
		inline float LoadAndDecode(float x, float y) {
			float4 s;
			s = tex2Dlod (_DataTex, float4((x + 0.5)/1024.0, (y + 0.5)/1024.0,0,0));
			float decoded = DecodeFloatRGBA(s);
			return (decoded * 2000.0) - 1000.0;
		}

		// Decode the index from the vertex's color
		inline float GetIndex(float4 input) {
			float4 encodedIndex = float4(0.4980392, input.x, input.y, input.z);
			float index = DecodeFloatRGBA(encodedIndex);
			index = (index * 2000.0) - 1000.0;
			index *= 1024;
			index = round(index);
			index = 1024.0 - index;
			return index;
		}


		// Get the animation value for the current sub-object. Animation Order is expected to increase in increments of 1.0
		inline float GetAnimationValue(float anim, float animationOrder, float animLength) {
			float current = animationOrder - anim;
			current = clamp(current, 0, 1);
			return current * animLength;
		}

		// Modulate the animation based on the distance of the vertex to its sub-object's pivot.
		inline float ModulateAnimation(float anim, float animLength, float4 pivot, float4 vertPosition) {
			float factor = 1.0f;
	
			float localDistance = length(pivot.xyz - vertPosition.xyz);

			float animModulate = 1 - min(localDistance / _WarpDistance, 1);

	
			// Shape the animation curve
			float shape = anim / animLength;

			shape *= factor;

			shape = clamp(shape, 0, 1);

			// Now is played back factor times faster

			anim += animModulate * shape;
			return anim;
		}


		// Handle the rotation of sub-objects
		inline float4 HandleRotation(float anim, float4 vertPosition, float4 pivot, float4 localX, float flightPath) {
			// Calculate the rotation
			float4x4 translate  = { 1.0, 0.0, 0.0, -pivot.x,
			0.0, 1.0, 0.0, -pivot.y,
			0.0, 0.0, 1.0, -pivot.z,
			0.0, 0.0, 0.0, 1.0  };

			float rotateAmount = anim;

			float C = cos(rotateAmount);
			float S = sin(rotateAmount);
			float t = 1.0 - C;
			float4 u = localX;
			u = float4(-flightPath * u.x, -u.y, u.z, 0.0);

			float4x4 rotateX = {(t * u.x * u.x) + C,
			(t * u.x * u.y) - (S * u.z),
			(t * u.x * u.z) + (S * u.y),
			0.0,
			(t * u.x * u.y) + (S * u.z),
			(t * u.y * u.y) + C,
			(t * u.y * u.z) - (S * u.x),
			0.0,
			(t * u.x * u.z) - (S * u.y),
			(t * u.y * u.z) + (S * u.x),
			(t * u.z * u.z) + C,
			0.0,
			0.0,
			0.0,
			0.0,
			1.0}; 


			float4x4 translateInverse = { 1.0, 0.0, 0.0, pivot.x,
			0.0, 1.0, 0.0, pivot.y,
			0.0, 0.0, 1.0, pivot.z,
			0.0, 0.0, 0.0, 1.0  };
	
			vertPosition = mul(translate, vertPosition);
			vertPosition = mul(rotateX, vertPosition);
			vertPosition = mul(translateInverse, vertPosition);
			return vertPosition;
		}
          

            void disp (inout appdata_full v)
            {
				float animLength = 4.0;
	
				float4 vertPosition = v.vertex;

				// Get the index where to load the data from
				float index = GetIndex(v.color);
				
				float4 pivot = v.texcoord.xyyy;

				float4 localX = float4(0, 0, 0, 0);

				float flightPath = -1.0;

				float animationOrder = 1.0;

				// Load all data from the texture
				// Decode the pivot
				pivot.x = LoadAndDecode(0.0, index);
				pivot.y = LoadAndDecode(1.0, index);
				pivot.z = LoadAndDecode(2.0, index);

				pivot.x *= -1;
				
				
				// Decode the local x-axis
				localX.x = LoadAndDecode(3.0, index);
				localX.y = LoadAndDecode(4.0, index);
				localX.z = LoadAndDecode(5.0, index);

				// Decode the flight path and animation order
				float fp = LoadAndDecode(6.0, index);	
				animationOrder = abs(fp);
				flightPath = sign(fp);
				
				// Update the animation value
				float anim = _Animation;
				anim = GetAnimationValue(anim, animationOrder + 1.0f, animLength);
				anim = ModulateAnimation(anim, animLength, pivot, vertPosition);
	
				
				// Do rotation	
				vertPosition = HandleRotation(anim, vertPosition, pivot, localX, flightPath);

				// Downward Translation - Modulate by a downward value
				vertPosition.z -= anim;

				// Outward Translation
				vertPosition.y += (anim * flightPath);

				

				// Offsets
				// Get a vector from the object's center to the sub-objects pivot
				float4 offset = pivot - _Center;
				// Remove the y component
				offset.z = 0;
				offset.w = 1;
				// Normalize
				offset = normalize(offset);

				// Modulate the offset by the animation value
				offset *= anim;

				// Add the offset
				vertPosition += offset;
				vertPosition.w = 1;

	
				// Calculate masking
				float zTest = vertPosition.z - _Center.z;
				float mask = clamp(zTest + (1 - (anim/2)), 0, 1);
				

				v.vertex = vertPosition;
				v.color = float4(v.color.x, v.color.y, v.color.z, mask);
	    
            }

            struct Input {
                fixed4 color : COLOR;
				float2 uv_MainTex;
            };


            void surf (Input IN, inout SurfaceOutput o) {
				o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
				o.Alpha = IN.color.w;
            }
            ENDCG
        }
        FallBack "Diffuse"
    }