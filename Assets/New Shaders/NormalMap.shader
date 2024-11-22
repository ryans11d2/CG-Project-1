Shader "Custom/NormalMap"
{
    Properties
    {
        _myDiffuse ("Diffuse Texture", 2D) = "white" {}//Diffuse Texture
        _myBump ("Bump Texture", 2D) = "bump" {}//Bump Map
        _mySlider ("Bump Amount", Range(0, 10)) = 1//Bump Multiplier
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf Lambert
        sampler2D _myDiffuse;
        sampler2D _myBump;
        half _mySlider;

        struct Input
        {
            float2 uv_myDiffuse;
            float2 uv_myBump;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;//Set pixel colour based on corresponding pixel in MainTex
            o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump));//Set pixel normal based on corresponding pixel in bump map
            o.Normal *= float3(_mySlider, _mySlider, 1);//Multiply normal by slider to increase depth of bumps
        }
        ENDCG
    }
    FallBack "Diffuse"
}
