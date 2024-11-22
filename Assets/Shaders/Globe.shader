Shader "Custom/Globe"
{
    Properties
    {
        _RimColor ("Rim Colour", Color) = (0, 0.5, 0.5, 0.0)
        _RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0
        _Color ("Colour", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"Queue" = "Transparent"}

        Pass {
            ZWrite On
            ColorMask 0
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        struct Input
        {
            float3 viewDir;
            float2 uv_MainTex;
        };

        float4 _RimColor;
        float _RimPower;
        fixed4 _Color;
        sampler2D _MainTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim,_RimPower) * 10;
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb + _RimColor.rgb;//Remove this for ghost effect
            o.Alpha = pow(rim, _RimPower) + tex2D(_MainTex, IN.uv_MainTex).rgb;//subtract for reverse contrast
        }
        ENDCG
    }
    FallBack "Diffuse"
}
