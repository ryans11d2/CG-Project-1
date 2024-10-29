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

        Stencil
        {
            Ref 1
            Comp notequal
            Pass keep
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
