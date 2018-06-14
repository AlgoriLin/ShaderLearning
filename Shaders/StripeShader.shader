// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MyShader2" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Transparent("Transparent",Range(0,1))=1
	}
	SubShader {
		Tags { "RenderType"="Transparent" 
			"IgnoreProjector"="true"
		}
		Blend SrcAlpha OneMinusSrcAlpha

		LOD 200

		Pass{
			Name "Simple"
			Cull off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _Color;
			struct v2f{
				float4 pos:POSITION;
				float4 uv:TEXCOORD0;
				float4 color:COLOR;
				float3 normal:NORMAL;
			};

			v2f vert(appdata_base data){
				v2f o;
				o.pos=UnityObjectToClipPos(data.vertex);
				o.uv=data.texcoord;
				o.normal=data.normal;
				o.color.x=data.normal.x*0.5+0.5;
				o.color.y=1-o.color.x;
				o.color.z=0.3;
				o.color.w=0.8;
				return o;
			}

			half4 frag(v2f v):COLOR{
				float factor=v.pos.y*sin(4*_Time.z+0.2*v.pos.y);
				half4 c = v.color*_Color;
				c.y=factor;
				return c;
			}

			ENDCG
		}

		/*
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG*/
	}
	FallBack "Diffuse"
}
