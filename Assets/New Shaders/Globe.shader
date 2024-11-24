Shader "Game/Globe"
{

    //Holographic rimlighting with scrolling texture inside

    Properties
    {
        _RimColor ("Hologram Colour", Color) = (0, 0.5, 0.5, 0.0)//Colour of rim lighting
        _RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0//Power of rim lighting
        _GlobeScale ("Globe Scale", Range(0, 1)) = 0.6//Scale of globe object (vs hologram object)
        _GlobeTex ("Globe Texture", 2D) = "white" {}//Globe texture
        _GlobeScroll ("Globe Speed", float) = 0//Globe spin speed
    }
    SubShader//Rimlighting with a transparent base
    {

        CGPROGRAM//Draw inner globe
        #pragma surface surf Lambert vertex:vert alpha:fade

        struct Input
        {
            float3 viewDir;
            float2 uv_GlobeTex;
        };

        struct appdata {
            float4 vertex: POSITION;
            float3 normal: NORMAL;
            float4 texcoord: TEXCOORD0;
        };

        float4 _RimColor;
        float _RimPower;
        float _GlobeScale;
        float _GlobeScroll;
        sampler2D _GlobeTex;

        void vert (inout appdata_full v) {
             v.vertex.xyz *= _GlobeScale;//Extrude vertices to make the shape appear larger
             v.texcoord.x += _GlobeScroll *= _Time;//Offset texture x position based on time
        }

        void surf (Input IN, inout SurfaceOutput o)
        {

            //Set pixel colour based on corresponding pixel in MainTex
            float4 c = tex2D(_GlobeTex, IN.uv_GlobeTex);

            //Set  Albedo and Alpha from texture
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG

        Tags {"Queue" = "Transparent"}

        Pass {
            ZWrite On
            ColorMask 0//Set to ColorMask 0 so only Emission is visible
        }

            CGPROGRAM//Draw hologram
            #pragma surface surf Lambert alpha:fade

            struct Input
            {
                float3 viewDir;
            };

            float4 _RimColor;
            float _RimPower;

            void surf (Input IN, inout SurfaceOutput o)
            {
                //Set emmision based on angle between surface and view direction, higher angles are brighter
                half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));

                o.Emission = _RimColor.rgb * pow(rim,_RimPower) * 10;
                o.Alpha = pow(rim,_RimPower);//Increase alpha based on rim (pixels with rim lighting have higher alpha)
            }
            ENDCG

        

    }
    FallBack "Diffuse"
}
