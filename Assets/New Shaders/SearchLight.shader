Shader "Game/SearchLight"
{
    Properties
    {
        _RimColor ("Hologram Colour", Color) = (0, 0.5, 0.5, 0.0)//Colour of rim lighting
        _RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0//Power of rim lighting
        _Inside ("Inside", Range(0.01, 1)) = 0.6
    }
    SubShader//Rimlighting with a transparent base
    {

        Tags {"Queue" = "Transparent+1"}//Set RenderQueue so light doesn't draw over switches

        Pass {
            ZWrite On
            ColorMask 0
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        struct Input
        {
            float3 viewDir;
        };

        float4 _RimColor;
        float _RimPower;

        void surf (Input IN, inout SurfaceOutput o)
        {
            //Set emmision based on angle between surface and view direction, higher angles are brighter
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));

            o.Emission = _RimColor.rgb * pow(rim,_RimPower) * 10;
            o.Alpha = pow(rim,_RimPower);//Increase alpha based on rim (pixels with rim lighting have higher alpha)
        }
        ENDCG

        

    }
    FallBack "Diffuse"
}
