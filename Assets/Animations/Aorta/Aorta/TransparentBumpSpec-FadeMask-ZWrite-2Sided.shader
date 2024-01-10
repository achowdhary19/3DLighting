Shader "Julien/Transparent-BumpSpec-MaskFade-ZWrite-2Sided" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 0)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_MainTex ("Base (RGB) TransGloss (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_Mask ("Mask (BW)", 2D) = "white" {}
	_Mask2 ("Mask 2 (BW)", 2D) = "white" {}
	_FadeAmount ("Fade amount", Float) = 0.0
}

SubShader 
{
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 400
	ZWrite On
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Front
	
CGPROGRAM
#pragma surface surf BlinnPhong alpha

sampler2D _MainTex;
sampler2D _BumpMap;
fixed4 _Color;
half _Shininess;
sampler2D _Mask;
sampler2D _Mask2;
float _FadeAmount;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex.rgb * _Color.rgb;
	o.Gloss = tex.a;
	float mask = lerp(tex2D(_Mask, IN.uv_MainTex).r, tex2D(_Mask2, IN.uv_MainTex).r, _FadeAmount);
	o.Alpha = tex.a * _Color.a * mask;
	o.Specular = _Shininess;
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
}
ENDCG

	Tags {"Queue"="Transparent+1" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 400
	ZWrite On
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Back
	
CGPROGRAM
#pragma surface surf BlinnPhong alpha

sampler2D _MainTex;
sampler2D _BumpMap;
fixed4 _Color;
half _Shininess;
sampler2D _Mask;
sampler2D _Mask2;
float _FadeAmount;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex.rgb * _Color.rgb;
	o.Gloss = tex.a;
	float mask = lerp(tex2D(_Mask, IN.uv_MainTex).r, tex2D(_Mask2, IN.uv_MainTex).r, _FadeAmount);
	o.Alpha = tex.a * _Color.a * mask;
	o.Specular = _Shininess;
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
}
ENDCG


}

FallBack "Transparent/VertexLit"
}