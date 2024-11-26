Shader "Game/SpecularFloor"
{
    Properties
    {

        _Color ("Colour", Color) = (1, 0, 0, 1)//Colour
		_MainTex ("Texture", 2D) = "white" {}//Texture
		_BumpMap ("Bump Texture", 2D) = "bump" {}//Bump Map
        _Bump ("Bump Amount", Range(0, 10)) = 1//Bump Map Depth

        _Shininess("Shininess", Float) = 10

        _Active ("Active", Range(0, 1)) = 1

    }
    SubShader
    {
        Pass 
        {
            Tags { "LightMode" = "ForwardBase" }
        

            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            uniform float4 _Color;
            uniform float _Shininess;

            sampler2D _MainTex;
			sampler2D _BumpMap;
			uniform float _Bump;

            uniform float4 _LightColor0;//Colour of directional light

            float _Active;

            struct vertexInput 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;//Texture coordinates (pixel from texture to use)
            };

            struct vertexOutput 
            {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float4 normalDir : TEXCOORD1;
                float2 uv : TEXCOORD3;//Texture coordinates (pixel from texture to use)
            };

            vertexOutput vert(vertexInput v) 
            {
                vertexOutput o;

                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));
                o.normalDir *= (tex2D(_BumpMap, v.texcoord), 1, 1) * _Bump * _Active;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            float4 frag(vertexOutput i) : COLOR
            {

                //Calculate Normal Direction (ddirection for light to reflect off)
                float3 normalDirection = i.normalDir;
                normalDirection *= tex2D(_BumpMap, -i.uv) * _Bump * _Active;//Add normal-map normals
                float atten = 1.0;

                float4 tex = tex2D(_MainTex, -i.uv)  * _Active;//Add texture

                //Diffuse Reflection
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten * _LightColor0.xyz * tex.rgb * max(0.0, dot(normalDirection, lightDirection));

                //Specular Reflection
                float3 lightReflectDirection = reflect(-lightDirection, normalDirection);//Reflect Direction
                float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.posWorld.xyz));//Camera Direction
                float3 lightSeeDirection = max(0.0, dot(lightReflectDirection, viewDirection));//Angle between light reflect and camera direction
                float3 shininessPower = pow(lightSeeDirection, _Shininess);//Shine Power

                float3 specularReflection = atten * _LightColor0.rgb * shininessPower * tex;

                //Combine diffuse lighting, ambient lighting, and specular reflection
                float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT + specularReflection;
                lightFinal *= _Active;
                return float4(lightFinal * _Color.rgb, 1.0);//Add colour and return
            }
            ENDCG
        }
        
    }
    FallBack "Diffuse"
}
