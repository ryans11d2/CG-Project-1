Shader "Game/SearchLight"
{
    Properties
    {
        _RimColor ("Hologram Colour", Color) = (0, 0.5, 0.5, 0.0)//Colour of rim lighting
        _RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0//Power of rim lighting
        _Active ("Active", Range(0, 1)) = 1
    }
    SubShader//Rimlighting with a transparent base
    {

        Tags {"Queue" = "Transparent+1"}//Set RenderQueue so light doesn't draw over switches

        Pass {
            ColorMask 0//Only draw emission
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        struct Input
        {
            float3 viewDir;//Camera direction
        };

        float4 _RimColor;
        float _RimPower;
        float _Active;

        void surf (Input IN, inout SurfaceOutput o)
        {
            //Set emmision based on angle between surface and view direction, higher angles are brighter
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            rim *= _Active;

            o.Emission = _RimColor.rgb * pow(rim,_RimPower) * 10;//Set emission useing rim lighting
            o.Alpha = pow(rim,_RimPower);//Increase alpha based on rim (pixels with rim lighting have higher alpha)
        }
        ENDCG

        

    }
    FallBack "Diffuse"
}
