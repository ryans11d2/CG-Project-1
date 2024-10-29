Shader "Custom/Decal"
{
    Properties
    {
        _Color ("Colour", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _DecalTex ("Decal", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"Queue" = "Geometry"}

        CGPROGRAM

        #pragma surface surf Lambert

        fixed4 _Color;
        sampler2D _MainTex;
        sampler2D _DecalTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 a = tex2D(_MainTex, IN.uv_MainTex);// * _Color;
            fixed4 b = tex2D(_DecalTex, IN.uv_MainTex);// * _Color;
            o.Albedo = a.rgb + b.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
