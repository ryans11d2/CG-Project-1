Shader "Custom/ColourVertexShader"
{
    Properties
    {
        //_Color ("Colour", Color) = (1,1,1,1)
        //_MainTex ("Texture", 2D) = "white" {}
        //_SCALEUVX("ScaleX", Range(1, 10)) = 1
        //_SCALEUVY("ScaleY", Range(1, 10)) = 1
    }
    SubShader
    {
        Pass 
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            //sampler2D _MainTex;
            //float4 _MainTex_ST;
            //float _SCALEUVX;
            //float _SCALEUVY;
            //float4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                //float2 uv : TEXCOORD0;
            };
            struct v2f
            {
                //float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color: COLOR;
            };
            v2f vert (appdata v)
            {
                v2f o;
                //UNITY_INITIALIZE_OUTPUT(v2f, 0)
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.uv.x = sin(o.uv.x * _SCALEUVX);
                //o.uv.y = sin(o.uv.y * _SCALEUVY);
                o.color.r = v.vertex.x;
                //o.color.g = v.vertex.y;
                //o.color.b = v.vertex.z;

                return o;
            }
            fixed4 frag (v2f i) : SV_Target 
            {
                fixed4 col = i.color;// * tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG

        }
    }
    FallBack "Diffuse"
}
