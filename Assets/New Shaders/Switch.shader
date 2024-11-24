Shader "Game/Switch"
{
    Properties
    {
        _myDiffuse ("Diffuse Texture", 2D) = "white" {}//Diffuse Texture
        _BumpMap ("Bump Texture", 2D) = "bump" {}//Bump Map
        _Bump ("Bump Amount", Range(0, 1)) = 1//Bump Multiplier

        _RimColor ("Rim Colour", Color) = (0, 0.5, 0.5, 0.0)//Colour of rim light
        _RimPower ("Rim Power", Range(0.5, 10.0)) = 3.0//Power of rim light

        _Active ("Active", Range(0, 1)) = 1

    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf Lambert
        sampler2D _myDiffuse;
        sampler2D _BumpMap;
        half _Bump;

        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float2 uv_myDiffuse;
            float2 uv_BumpMap;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {;

            o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;//Set pixel colour based on corresponding pixel in MainTex

            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));//Set pixel normal based on corresponding pixel in bump map
            o.Normal *= float3(_Bump, _Bump, 1);//Multiply normal by slider to increase depth of bumps

        }
        ENDCG

        Tags {"Queue" = "Transparent"}

        Pass {
            ColorMask 0//Set colour mask to 0 so only emissions are visible
        }

        CGPROGRAM//Draw emmision on bumps
        #pragma surface surf Lambert alpha:fade

        struct Input
        {
            float3 viewDir;//Camera direction
            float2 uv_BumpMap;
        };

        float4 _RimColor;
        float _RimPower;

        sampler2D _myDiffuse;
        sampler2D _BumpMap;
        half _Bump;

        float _Active;

        void surf (Input IN, inout SurfaceOutput o)
        {
            //Set emmision based on angle between surface and view direction, higher angles are brighter
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));

            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));//Set pixel normal based on corresponding pixel in bump map
            o.Normal *= float3(_Bump, _Bump, 1);//Multiply normal by slider to increase depth of bumps

            o.Emission = _RimColor.rgb * pow(rim,_RimPower) * 10 * _Active;
            o.Alpha = o.Normal.y < 0 ? o.Normal : pow(rim,_RimPower) * _Active;//Increase alpha based on rim (pixels with rim lighting have higher alpha)
        }
        ENDCG

    }
    FallBack "Diffuse"
}
