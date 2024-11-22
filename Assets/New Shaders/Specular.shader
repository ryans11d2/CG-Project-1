Shader "Custom/Specular"
{
    Properties
    {
        _Color ("Colour", Color) = (1.0, 1.0, 1.0)
        _SpecColor("Specular Colour", Color) = (1.0, 1.0, 1.0)
        _Shininess("Shininess", Float) = 10
        _Aer ("Specular-Ambient-Diffuse", Range(0, 1)) = 1
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
            uniform float4 _SpecColor;
            uniform float _Shininess;
            uniform float _Aer;

            uniform float4 _LightColor0;//Colour of directional light

            struct vertexInput 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct vertexOutput 
            {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float4 normalDir : TEXCOORD1;
            };

            vertexOutput vert(vertexInput v) 
            {
                vertexOutput o;

                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag(vertexOutput i) : COLOR
            {
                float3 normalDirection = i.normalDir;
                float atten = 1.0;

                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));

                float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
                float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.posWorld.xyz));
                float3 lightSeeDirection = max(0.0, dot(lightReflectDirection, viewDirection));
                float3 shininessPower = pow(lightSeeDirection, _Shininess);


                float3 specularReflection = atten * _SpecColor.rgb * shininessPower;

                //Combine diffuse lighting, ambient lighting, and specular reflection
                float3 lightFinal = diffuseReflection;
                lightFinal = _Aer == 1 ? lightFinal : lightFinal + UNITY_LIGHTMODEL_AMBIENT;

                lightFinal = _Aer > 0 ? lightFinal : lightFinal + specularReflection;


                return float4(lightFinal * _Color.rgb, 1.0);
            }
            ENDCG
        }
        
    }
    FallBack "Diffuse"
}
