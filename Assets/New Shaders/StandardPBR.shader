Shader "Custom/StandardPBR"
{
    Properties
    {
        _Color ("Colour", Color) = (1,1,1,1)
        _MetallicTex ("Metalic (R)", 2D) = "white" {}
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Smoothness ("Smoothness", Range(0.0, 1.0)) = 0.5
        _SpecColor ("Specular Colour", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags {"Queue" = "Geometry"}

        CGPROGRAM
        
        #pragma surface surf StandardSpecular

        sampler2D _MetallicTex;
        half _Metallic;
        half _Smoothness;
        fixed4 _Color;

        struct Input
        {
            float2 uv_MetallicTex;
        };

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            o.Albedo = _Color.rgb;
            o.Smoothness = tex2D(_MetallicTex, IN.uv_MetallicTex).r * _Smoothness;
            //o.Metallic = _Metallic;
            o.Alpha = _Color.a;
            o.Specular = _SpecColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
