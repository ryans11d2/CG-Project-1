Shader "Custom/RimLight"
{
    Properties
    {
        _Color ("Colour",Color) = (1, 1, 1, 1)
        _RimColor ("Rim Colour", Color) = (0, 0.5, 0.5, 0.0)//Colour of rim light
        _RimPower ("Rim Power", Range(0.5, 10.0)) = 3.0//Power of rim light
        _Invert ("Invert", Range(-1, 1)) = 1
    }
    SubShader
    {
        CGPROGRAM//Light the edges based on view direction
        #pragma surface surf Lambert

        struct Input
        {
            float3 viewDir;//Angle to camera
        };

        float4 _Color;
        float4 _RimColor;
        float _RimPower;
        float _Invert;

        void surf (Input IN, inout SurfaceOutput o)
        {
            //Set emision based the angle between view direection and surface normal
            half rim = _Invert - dot (normalize(IN.viewDir), o.Normal);//Dot product between camera and normal

            //Invert the lighting on the edges, with full inversion 0.8 -> 0.2
            rim = _Invert > 0 ? rim : abs(_Invert) * saturate(dot(normalize(IN.viewDir), o.Normal));

            //Increase pixel colour by rim power, using power for an exponential gradient
            o.Emission = _RimColor.rgb * pow(rim,10 - _RimPower);
            o.Albedo = _Color;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
