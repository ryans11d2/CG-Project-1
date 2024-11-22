Shader "Custom/Highlight"
{

    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Amount ("Amount", Range (0, 0.1)) = 0
    }
    SubShader
    {

        CGPROGRAM
        
        //#pragma surface surf Lambert
        #pragma surface surf Lambert vertex:vert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };
       
        struct appdata {
            float4 vertex: POSITION;
            float3 normal: NORMAL;
            float4 texcoord: TEXCOORD0;
        };

        fixed4 _Color;
        float _Amount;

        void vert(inout appdata v) {
            v.vertex.xyz += v.normal * _Amount;
            //v.vertex.xyz *= _Amount;//Scale
        }


        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
