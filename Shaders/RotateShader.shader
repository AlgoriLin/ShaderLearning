Shader "Custom/RotateShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_RSpeed("Rptate Speed",Range(1,100))=1
		_RFilter("R Filter",Range(0,1))=0.05
		_GFilter("G Filter",Range(0,1))=0.05
		_BFilter("B Filter",Range(0,1))=0.05
		_Amplitude("Amplitude",Range(0,5))=1
	}
	SubShader {
		Tags { "RenderType"="Opaque" 
			"IgnoreProjector"="true"
		}
		Blend SrcAlpha OneMinusSrcAlpha

		Pass{
		Name "Rotate"
		Cull Off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		float4 _Color;
		float _RFilter;
		float _GFilter;
		float _BFilter;
		float _RSpeed;
		float _Amplitude;

		struct v2f{
			float4 pos:POSITION;
			float4 uv:TEXCOORD0;
		};

		v2f vert(appdata_base data){

			v2f o;
			o.pos=UnityObjectToClipPos(data.vertex);

			o.uv=data.texcoord;
			return o;
		}

		half4 frag(v2f v):COLOR{
			
			float2 uv=v.uv.xy-float2(0.5,0.5);
			float2 factor=float2(sin(_Time.x*_RSpeed),cos(_Time.x*_RSpeed));
			uv=float2(uv.x*factor.y-uv.y*factor.x,uv.x*factor.x+uv.y*factor.y);
			uv+=float2(0.5,0.5);
			
			half4 c=tex2D (_MainTex,uv) * _Color;
			return c;
		}
		ENDCG
		}

	}
	FallBack "Diffuse"
}
