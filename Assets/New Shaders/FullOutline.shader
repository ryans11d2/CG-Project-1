Shader "Custom/FullOutline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor ("Colour", Color) = (1,1,1,1)
        _Outline ("Outline Width", Range (0, 10)) = 1
    }
    SubShader
    {

        Tags {"Queue" = "Transparent"}//Outline draws on top of everything (otherwise outline will be blocked by other objects)
        ZWrite off//Render first pass behind second pass

        CGPROGRAM

            #pragma surface surf Lambert vertex:vert

            struct Input
            {
                float2 uv_MainTex;
            };
        
            float _Outline;
            float4 _OutlineColor;
        
            void vert (inout appdata_full v) {
                //v.vertex.xyz += v.normal * _Outline;
                v.vertex.xyz *= 1 + _Outline;//Extrude vertices to make the shape appear larger
            }

            sampler2D _MainTex;

            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Emission = _OutlineColor.rgb;//Colour object red, uses Emission so outline doesn't have a shadow
            }

        ENDCG

        ZWrite on//Render second pass normaly

        CGPROGRAM//Typical texture diffuse

            #pragma surface surf Lambert

            struct Input
            {
                float2 uv_MainTex;
            };
        
            sampler2D _MainTex;

            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;//Set pixel colour based on corresponding pixel in MainTex
            }
        ENDCG
    }
    FallBack "Diffuse"
}
