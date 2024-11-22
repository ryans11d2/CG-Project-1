Shader "Custom/Toggle"
{
    Properties
    {
        _Color ("Colour", Color) = (1,1,1,1)
        _Toggle ("Toggle", Range(0, 1)) = 0.5 
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_MainTex;
        };
        
        fixed4 _Color;
        fixed4 _EndColor;
        float _Toggle;

        void surf (Input IN, inout SurfaceOutput o)
        {
            _EndColor.rgb = fixed3(0, 0, 0);
            //_EndColor.r = _Toggle > 0 ? _EndColor.r : 1;
            //_EndColor.g = _Toggle == 0 || _Toggle == 1 ? _EndColor.g : 1;
            //_EndColor.b = _Toggle < 1 ? _EndColor.b : 1;

            _EndColor.r = sin(_Time * 10);
            _EndColor.g = cos(_Time * 5);
            _EndColor.b = 1 / tan(_Time * 10);

            o.Albedo = _EndColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
