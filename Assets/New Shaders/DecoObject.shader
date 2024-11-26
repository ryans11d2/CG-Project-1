Shader "Game/DecoObject"
{
    Properties
    {
        _Color ("Colour", Color) = (1, 1, 1, 1)//Colour
        _MainTex ("Texture", 2D) = "white" {}//Texture
        _BumpMap ("Bump Map", 2D) = "bump" {}//Bump Map
        _BumpDepth ("Bump Amount", Range(0, 10)) = 1//Bump Multiplier
        _Active ("Active", Range(0, 1)) = 1
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf Lambert
        float4 _Color;
        sampler2D _MainTex;
        sampler2D _BumpMap;
        half _BumpDepth;
        float _Active;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Color.rgb * _Active;//Set pixel colour based on corresponding pixel in MainTex
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));//Set pixel normal based on corresponding pixel in bump map
            o.Normal *= float3(_BumpDepth, _BumpDepth, 1) * _Active;//Multiply normal by slider to increase depth of bumps
        }
        ENDCG
    }
    FallBack "Diffuse"
}
