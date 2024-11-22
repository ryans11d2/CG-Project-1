Shader "Custom/Scroll"
{
    Properties
    {
        _Color ("Main Colour", Color) = (1,1,1,1)
        _FoamColor ("Foam Colour", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _FoamTex ("Foam", 2D) = "white" {}

        _BumpMap ("Bump Texture", 2D) = "bump" {}
        _Bump ("Bump Amount", Range(0, 10)) = 1

        _ScrollX ("Scroll X", Range(-5, 5)) = 1
        _ScrollY ("Scroll Y", Range(-5, 5)) = 1
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };
        
        fixed4 _Color;
        fixed4 _FoamColor;
        sampler2D _MainTex;
        sampler2D _FoamTex;

        sampler2D _BumpMap;
        half _Bump;

        float _ScrollX;
        float _ScrollY;

        void surf (Input IN, inout SurfaceOutput o)
        {
            //Adjust scroll amount by time
            _ScrollX *= _Time;
            _ScrollY *= _Time;

            //Set texture, displace texture coordinates by scroll amount
            float3 water = (tex2D (_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY))).rgb * _Color;
            float3 foam = (tex2D (_FoamTex, IN.uv_MainTex + float2(_ScrollX / 2.0, _ScrollY / 2.0))).rgb * _FoamColor;

            //Set normal, displace bump map coordinates by scroll amount
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap + float2(_ScrollX, _ScrollY)));
            o.Normal *= float3(_Bump, _Bump, 1);

            o.Albedo = (water + foam) / 2.0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
