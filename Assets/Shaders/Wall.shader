Shader "Custom/Wall"
{
    Properties
    {
        _MainTex ("Back", 2D) = "white" {}
        _FrontTex ("Front", 2D) = "white" {}
        _Color ("Colour", Color) = (1,1,1,1)
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }

        Stencil
        {
            Ref 1
            Comp notequal
            Pass keep
        }

        CGPROGRAM

        //#pragma surface surf Lambert
        #pragma surface surf Standard alpha:fade

        sampler2D _FrontTex;
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };
        fixed4 _Color;
        fixed4 _White;

        half _Metallic;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 d = tex2D (_FrontTex, IN.uv_MainTex);
            o.Metallic = _Metallic;
            o.Albedo = d.r > 0.1 ? d.rgb : c.rgb;
            //o.Albedo = d.rgb;
            o.Alpha = d.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
