Shader "Custom/Stencil"
{
    Properties
    {
        _Color ("Colour", Color) = (1,1,1,1)
        _MainTex ("Diffuse", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Geometry-1" }//Have this draw first (before stencil wall), that way the stencil wall behind it is not drawn

        ColorMask 0//Don't render any colours, making object invisible
        ZWrite off//Disable ZWrite, so that this is always considered drawn behind other objects

        //Stencil Buffer
        Stencil
        {
            Ref 1//Stencil reference value, to be compared with other overlapping stencils using the same reference
            Comp always//Compare 1 to the stencil buffer
            Pass replace//Replace 1 with this (render this instead of other)
        }

        CGPROGRAM

        #pragma surface surf Lambert

        fixed4 _Color;
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };
        //fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
