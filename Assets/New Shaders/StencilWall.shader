Shader "Custom/StencilWall"
{
    Properties
    {
        _Color ("Colour", Color) = (1,1,1,1)
        _MainTex ("Diffuse", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }

        Stencil//If no reference is found, draw this as per usual
        {
            Ref 1//Stencil reference value, to be compared with other overlapping stencils using the same reference
            Comp notequal//If no reference 1 stencils can are found, dont draw
            Pass keep//Don't draw with stencil if it doesn't overlap with the hole stencil?
        }

        CGPROGRAM

        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
