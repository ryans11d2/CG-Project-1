Shader "Custom/Toon"
{
    Properties
    {
        _Color ("Colour", Color) = (1,1,1,1)
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _myOverlay ("Overlay Texture", 2D) = "white" {}
        _Aer ("Overlay Colour", Color) = (1,1,1,1)
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf ToonRamp
        //#pragma surface aer Lambert;

        float4 _Color;
        sampler2D _RampTex;
        sampler2D _myOverlay;
        float4 _Aer;
        
        float4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten) 
        {
            float diff = dot (s.Normal, lightDir);//The difference in angle between surface normal and light direction
            float h = diff * 0.5 + 0.5;//Set diff between a horizontal range from -0.5 to 0.5
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;//set ramp to pixel on ramp texture corresponding to h
            
            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);//Set the rgb value based on the light colour and h
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_myOverlay;
        };

        
        void surf (Input IN, inout SurfaceOutput o)
        {
            //o.Albedo = tex2D(_myOverlay, IN.uv_myOverlay).rgb * _Aer;
            o.Albedo = _Color.rgb;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
