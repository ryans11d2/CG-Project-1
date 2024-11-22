Shader "Custom/NewThing"
{
    Properties
    {
        _myDiffuse ("Diffuse Texture", 2D) = "white" {}
        _myOverlay ("Overlay Texture", 2D) = "white" {}
        _myBump ("Bump Texture", 2D) = "bump" {}
        _mySlider ("Bump Amount", Range(-10, 10)) = 1
        _myScaler ("Scale Amount", Range(-10, 10)) = 1
        _myColor ("Overlay Colour", Color) = (1, 1, 1, 0.5)
        _RimColor ("Rim Colour", Color) = (0, 0.5, 0.5, 0.0)
        _RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0
    }
    SubShader
    {

        Tags { "RenderType"="Transparent" }

        CGPROGRAM

        #pragma surface surf Lambert

        sampler2D _myDiffuse;
        sampler2D _myOverlay;
        sampler2D _myBump;
        half _mySlider;
        half _myScaler;
        fixed4 _myColor;
        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float2 uv_myDiffuse;
            float2 uv_myOverlay;
            float2 uv_myBump;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {

            o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
            o.Albedo += tex2D(_myOverlay, IN.uv_myOverlay).rgb * _myColor;
            o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump));
            o.Normal *= float3(_mySlider, _mySlider, 1);

            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = tex2D(_myOverlay, IN.uv_myOverlay).rgb * _RimColor.rgb * pow(rim,_RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
