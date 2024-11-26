Shader "Game/AimLaser"
{
    Properties
    {
        _Color ("Colour", Color) = (1,1,1,1)
    }
    SubShader
    {

        Tags {"Queue" = "Transparent"}

        CGPROGRAM

        #pragma surface surf Lambert alpha:fade

        struct Input
        {
            float3 viewDir;
        };
        
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Emission = _Color;// * pow(o.Normal.y, 3);
            o.Alpha = _Color.a * pow(o.Normal.y, 3);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
