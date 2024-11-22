Shader "Custom/Toggle"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,0,0,1)
        _ColorB ("Color B", Color) = (0,1,0,1)
        _ColorC ("Color C", Color) = (0,0,1,1)
        _Selection ("Selection", Range(0,2)) = 0
    }
    SubShader
    {
       CGPROGRAM

        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _ColorA;
        fixed4 _ColorB;
        fixed4 _ColorC;
        int _Selection;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _ColorA;
            o.Albedo = _Selection >= 1 ? o.Albedo : _ColorB;
            o.Albedo = _Selection >= 2 ? o.Albedo : _ColorC;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
