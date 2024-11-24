Shader "Game/FacilityWall"
{
    Properties
    {
        _Color ("Colour", Color) = (1.0, 1.0, 1.0)
        //_SpecColor("Specular Colour", Color) = (1.0, 1.0, 1.0)
        //_Shininess("Shininess", Float) = 10

        _MainTex ("Wall Texture", 2D) = "white" {}//Diffuse Texture
        _MainBump ("Main Bump Texture", 2D) = "bump" {}//Bump Map
        _MainDepth ("Main Bump Amount", Range(-10, 10)) = 1//Bump Multiplier

        _FrontTex ("Decoration Texture", 2D) = "white" {}//Diffuse Texture
        _FrontBump ("Deco Bump Texture", 2D) = "bump" {}//Bump Map
        _FrontDepth ("Deco Bump Amount", Range(-10, 10)) = 1//Bump Multiplier

        _Active ("Active", Range(0, 1)) = 1

    }
    SubShader
    {
        Tags { "LightMode" = "ForwardBase" }
        
        Stencil//If no reference is found, draw this as per usual
        {
            Ref 1//Stencil reference value, to be compared with other overlapping stencils using the same reference
            Comp notequal//If no reference 1 stencils can are found, dont draw
            Pass keep//Don't draw with stencil if it doesn't overlap with the hole stencil?
        }

        CGPROGRAM
            
        #pragma surface surf Lambert

        float4 _Color;
            
        sampler2D _MainTex;
        sampler2D _MainBump;
        float _MainDepth;

        sampler2D _FrontTex;
        sampler2D _FrontBump;
        float _FrontDepth;

        float _Active;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainBump;

            float2 uv_FrontTex;
            float2 uv_FrontBump;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_FrontTex, IN.uv_FrontTex).rgb;//Set pixel colour based on corresponding pixel in MainTex
            o.Albedo = tex2D(_FrontTex, IN.uv_FrontTex).a != 0 ? o.Albedo : tex2D(_MainTex, IN.uv_MainTex).rgb * _Color;//Replace transparent pixels with main texture
            o.Albedo *= _Active;

            //Set pixel normal based on corresponding pixel in bump map
            o.Normal = UnpackNormal(tex2D(_FrontBump, IN.uv_FrontBump)) * float3(_FrontDepth, _FrontDepth, 1);
            o.Normal = tex2D(_FrontTex, IN.uv_FrontTex).a != 0 ? o.Normal : UnpackNormal(tex2D(_MainBump, IN.uv_MainBump)) * float3(_MainDepth, _MainDepth, 1);
            o.Normal *= _Active;
        }

        ENDCG
        
    }
    FallBack "Diffuse"
}
