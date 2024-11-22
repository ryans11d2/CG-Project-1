Shader "Custom/SpecularOutline"
{
    Properties
    {
        _RimColor ("Hologram Colour", Color) = (0, 0.5, 0.5, 0.0)
        _RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0

        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor ("Colour", Color) = (1,1,1,1)
        _Outline ("Outline Width", Range (0, 3)) = 0.1
    }
    SubShader
    {

        Tags {"Queue" = "Transparent"}

        CGPROGRAM

        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG

        CGPROGRAM

            #pragma surface surf Lambert vertex:vert alpha:fade

            struct Input
            {
                float2 uv_MainTex;
                float3 viewDir;
            };
        
            float _Outline;
            float4 _OutlineColor;

            float4 _RimColor;
            float _RimPower;
        
            void vert (inout appdata_full v) {
                //v.vertex.xyz += v.normal * _Outline;
                v.vertex.xyz *= 1 + _Outline;
            }

            sampler2D _MainTex;

            void surf (Input IN, inout SurfaceOutput o)
            {
                half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
                o.Emission = _RimColor.rgb * pow(rim,_RimPower) * 10;
                o.Alpha = pow(rim, _RimPower);
            }

        ENDCG

        //Tags { "LightMode" = "ForwardBase" }

        

        //FallBack "Diffuse"
    }
    
}
