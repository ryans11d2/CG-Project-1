Shader "Custom/ShadowMap"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _ShadowColor ("Shadow Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
       Pass {

           Tags {"LightMode" = "ForwardBase"}

           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

           #include "UnityCG.cginc"
           #include "UnityLightingCommon.cginc"
           #include "Lighting.cginc"
           #include "AutoLight.cginc"

           float4 _ShadowColor;
           float4 _Color;

           struct appdata {
               float4 vertex : POSITION;
               float3 normal : NORMAL;
               float4 texcoord : TEXCOORD0;
           };
           struct v2f
           {
               float2 uv : TEXCOORD0;
               fixed4 diff : COLOR0;
               float4 pos: SV_POSITION;
               SHADOW_COORDS(1)
           };
           v2f vert(appdata v)
           {
               v2f o;
               //o.vertex = UnityObjectToClipPos(v.vertex);
               o.pos = UnityObjectToClipPos(v.vertex);
               o.uv = v.texcoord;
               half3 worldNormal = UnityObjectToWorldNormal(v.normal);
               half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
               o.diff = nl * _LightColor0 * _ShadowColor;
               //o.diff = _Color;//REMOVE THIS
               TRANSFER_SHADOW(o)
               return o;
           }
           sampler2D _MainTex;

           fixed4 frag(v2f i) : SV_Target
           {
               fixed4 col = tex2D(_MainTex, i.uv);
               fixed shadow = SHADOW_ATTENUATION(i);
               //col.rgb *= i.diff * shadow;
               col.rgb *= i.diff * (_ShadowColor.rgb - shadow);
               return col;
           }
           ENDCG


       }

       Pass 
       {
           Tags {"LightMode" = "ShadowCaster"}
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           #pragma multi_compile_shadowcaster
           #include "UnityCG.cginc"

           float4 _Color;

           struct appdata {
               float4 vertex : POSITION;
               float3 normal : NORMAL;
               float4 texcoord : TEXCOORD0;
           };
           struct v2f {
               V2F_SHADOW_CASTER;
           };
           v2f vert(appdata v)
           {
               v2f o;
               
               TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
               return o;
           }
           float4 frag(v2f i) : SV_Target
           {
                SHADOW_CASTER_FRAGMENT(i)
           }

           ENDCG
       }

    }
    FallBack "Diffuse"
}
